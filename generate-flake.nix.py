#!/usr/bin/env python3
import collections.abc
import contextlib
import json
import logging
import os
import pathlib
import random
import shlex

import subprocess
import sqlite3
import multiprocessing
import typing

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


MULTIPROCESSING = True
_sql_logger = logging.getLogger("sql")
_subprocess_logger = logging.getLogger("subprocess")
_sql_logger.level = logging.DEBUG
_subprocess_logger.level = logging.DEBUG
T = typing.TypeVar("T")


class NixpkgEntry(typing.TypedDict):
    rev: str
    input: str
    pname: str
    disabled: str
    broken: str


_FLAKE_NIX_FOOTER = pathlib.Path("flake.nix.footer").read_text()
_FLAKE_NIX_HEADER = pathlib.Path("flake.nix.header").read_text()
_NIXPKGS_ALIASES_RUN = pathlib.Path("../nixpkgs-aliases-run.sh")
_GCROOTS_D = pathlib.Path("gcroots")


def _ln_s(source: pathlib.Path, target: pathlib.Path):
    _subprocess_logger.debug({"$@": shlex.join(["ln", "-s", str(target), str(source)])})
    source.symlink_to(target)


def _subprocess_run(_cmd):
    _env = dict(os.environ)
    _env["TERM"] = "dumb"
    _result = subprocess.run(_cmd, capture_output=True, env=_env)
    # 0: stdin
    # 1: stdout
    # 2: stderr
    _debug_result = {}
    if _result.returncode != 0:
        _debug_result["$?"] = _result.returncode
    _debug_result["$@"] = shlex.join(_cmd)
    if _result.stdout != b"":
        _debug_result[1] = _result.stdout.decode("utf-8", "surrogateescape")
    if _result.stderr != b"":
        _debug_result[2] = _result.stderr.decode("utf-8", "surrogateescape")
    _subprocess_logger.debug(_debug_result)
    return _result


def _stdout_json(_subprocess: subprocess.CompletedProcess, empty_is_none=False):
    try:
        if empty_is_none and _subprocess.stdout == b"":
            return None
        return json.loads(_subprocess.stdout)
    except json.decoder.JSONDecodeError:
        _subprocess_logger.error(repr(_subprocess))
        _subprocess_logger.error("json.decoder.JSONDecodeError", exc_info=True)
        raise


def _escape_nix_set_key(_name):
    if '"' in _name:
        msg = f"unhandled name {_name}"
        raise OSError(msg)
    if "." in _name or "+" in _name or "[" in _name:
        return f'"{_name}"'
    if _name in ["rec"]:  # nixlang keywords
        return f'"{_name}"'
    return _name


@contextlib.contextmanager
def sqlite3_autocommit_connection(database: os.PathLike | str) -> sqlite3.Connection:
    """
    open sqlite3 connection in autocommit mode, with explicit sqlite3 transaction handling

    @see https://docs.python.org/3/library/sqlite3.html#transaction-control

    > The sqlite3 module does not adhere to the transaction handling recommended by PEP 249.
    >
    > If isolation_level is set to None, no transactions are implicitly opened at all.
    > This leaves the underlying SQLite library in autocommit mode,
    > but also allows the user to perform their own transaction handling using explicit SQL statements.
    """
    _connection = sqlite3.connect(database, isolation_level=None)
    _connection.execute("pragma journal_mode=wal;")
    _connection.execute("pragma busy_timeout=10000;")
    _connection.execute("pragma synchronous=NORMAL;")
    _connection.set_trace_callback(_sql_logger.debug)
    with contextlib.closing(_connection):
        yield _connection


@contextlib.contextmanager
def transaction(_connection: sqlite3.Connection):
    """
    begin a transaction
    """
    _connection.execute("BEGIN;")
    try:
        yield
    except:
        _connection.rollback()
        raise
    else:
        _connection.commit()


def main():
    for _folder in (_GCROOTS_D,):
        _folder.mkdir(parents=True, exist_ok=True)
        for _file in _folder.glob("*"):
            with contextlib.suppress(FileNotFoundError):
                _file.unlink()

    _revs = {
        _node_name.replace("i-", "n-"): _node_value["locked"]["rev"]
        for _node_name, _node_value in json.loads(
            pathlib.Path("flake.lock").read_text()
        )["nodes"].items()
        if _node_name.startswith("i-")
    }

    with sqlite3_autocommit_connection("database.sqlite3") as _con_map:
        _nixpkgs: list[NixpkgEntry] = [
            NixpkgEntry(
                rev=_revs[_row[0]],
                input=_row[0],
                pname=_row[1],
                disabled=_row[2],
                broken=_row[3],
            )
            for _row in _con_map.execute(
                "SELECT input, pname, disabled, broken FROM nixpkgs ORDER BY pname;"
            )
        ]

    random.shuffle(_nixpkgs)
    do_multiprocessing(_process_nixpkg, _nixpkgs, 8)

    with sqlite3_autocommit_connection("database.sqlite3") as _con_reduce:
        _packages = [
            {
                "input": _row[0],
                "pname": _row[1],
            }
            for _row in _con_reduce.execute(
                "SELECT DISTINCT input, pname FROM nixpkgs ORDER BY input, pname;",
            )
        ]
        with pathlib.Path("flake.nix").open("w") as _flake_file:
            _flake_file.write(_FLAKE_NIX_HEADER)
            for _package in _packages:
                _input = _package["input"]
                _pname = _package["pname"]
                _package_key = _escape_nix_set_key(_pname)
                _flake_file.write(
                    "".join(
                        [
                            "      packages.",
                            _package_key,
                            " = ",
                            _input,
                            ".",
                            _pname,
                            ";\n",
                        ]
                    )
                )
            _flake_file.write(_FLAKE_NIX_FOOTER)


def do_multiprocessing(
    _worker: collections.abc.Callable[[T], typing.Any],
    _jobs: typing.Iterable[T],
    _pool_size: int,
):
    if MULTIPROCESSING:
        with multiprocessing.Pool(_pool_size) as _pool:
            for _completed_job in _pool.imap_unordered(func=_worker, iterable=_jobs):
                ...
    else:
        for _job in _jobs:
            _worker(_job)


def _process_nixpkg(_data: NixpkgEntry):
    _rev = _data["rev"]
    _pname = _data["pname"]
    _disabled = _data["disabled"]
    _broken = _data["broken"]
    _input = _data["input"]
    all_output_paths = {}
    for _output in _stdout_json(
        _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}.outputs",
            ]
        )
    ):
        _this_output = _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}.{_output}",
            ]
        )
        if _this_output.stdout == b"":
            with sqlite3_autocommit_connection("database.sqlite3") as _con_update:
                _broken = _this_output.stderr.decode("utf-8", "surrogateescape")
                if "\n" in _broken:
                    _first_line, _rest = _broken.split("\n", maxsplit=1)
                    if _first_line.startswith(
                        "error (ignored): error: SQLite database '"
                    ) and _first_line.endswith(".sqlite' is busy"):
                        _broken = _rest
                _con_update.execute(
                    "UPDATE nixpkgs SET broken = :broken WHERE pname = :pname;",
                    {
                        "pname": _pname,
                        "broken": _broken,
                    },
                )
        else:
            with sqlite3_autocommit_connection("database.sqlite3") as _con_update:
                _con_update.execute(
                    "UPDATE nixpkgs SET broken = NULL WHERE pname = :pname;",
                    {"pname": _pname},
                )
            _broken = None
            _pname_with_output = f"{_pname}^{_output}"
            _target = pathlib.Path(_stdout_json(_this_output))
            _ln_s(source=_GCROOTS_D.joinpath(_pname_with_output), target=_target)
            all_output_paths[_target] = _pname_with_output

    if len(all_output_paths) > 0:
        _prefix = _stdout_json(
            _subprocess_run(
                [
                    *shlex.split(
                        "nix --extra-experimental-features 'nix-command flakes' eval --json"
                    ),
                    f"github:NixOS/nixpkgs/{_rev}#{_pname}",
                ],
            ),
            empty_is_none=True,
        )

        # reduce symlink churn by pointing to pre-exising explicitly named output if it exists
        if _prefix in all_output_paths:
            _prefix = all_output_paths[_prefix]
        if _prefix:
            _ln_s(
                source=_GCROOTS_D.joinpath(f"{_pname}"),
                target=pathlib.Path(_prefix),
            )

    _description = _stdout_json(
        _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}.meta.description",
            ],
        ),
        empty_is_none=True,
    )
    _long_description = _stdout_json(
        _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}.meta.longDescription",
            ],
        ),
        empty_is_none=True,
    )

    _db_description = None
    if _description is None and _long_description is not None:
        _db_description = _long_description
    elif _long_description is None and _description is not None:
        _db_description = _description
    elif _description is not None and _long_description is not None:
        _db_description = _description + "\n\n" + _long_description

    with sqlite3_autocommit_connection("database.sqlite3") as _con_update:
        _con_update.execute(
            "UPDATE nixpkgs SET description = :description WHERE pname = :pname;",
            {
                "pname": _pname,
                "description": _db_description,
            },
        )

    if _disabled is None and _broken is None:
        _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' build --json --no-link"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}",
            ]
        )


if __name__ == "__main__":
    main()
