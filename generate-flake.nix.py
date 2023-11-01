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

NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE = pathlib.Path("flake.nix.footer")
NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE = pathlib.Path("flake.nix.header")
NIXPKGS_ALIASES_RUN_FILE = pathlib.Path("../nixpkgs-aliases-run.sh")
NIXPKGS_ALIASES_GCROOTS_FOLDER = pathlib.Path("gcroots")
NIXPKGS_ALIASES_ALIASES_FOLDER = pathlib.Path("aliases")

CMD_UPDATE_FLAKE = shlex.split(
    "nix --extra-experimental-features 'nix-command flakes' flake update path:."
)
PACKAGE_DESCRIPTIONS = shlex.split(
    "nix --extra-experimental-features 'nix-command flakes' --refresh flake show --json path:."
)


def _ln_s(source: pathlib.Path, target: pathlib.Path):
    print({"$@": shlex.join(["ln", "-s", str(target), str(source)])})
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
    print(_debug_result)
    return _result


def _escape_nix_set_key(_name):
    if '"' in _name:
        msg = f"unhandled name {_name}"
        raise OSError(msg)
    if "." in _name or "+" in _name:
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
    _connection.execute("pragma busy_timeout=5000;")
    _connection.execute("pragma synchronous=NORMAL;")
    _connection.set_trace_callback(print)
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
    cleanup = True
    NIXPKGS_ALIASES_ALIASES_FOLDER.mkdir(parents=True, exist_ok=True)
    NIXPKGS_ALIASES_GCROOTS_FOLDER.mkdir(parents=True, exist_ok=True)

    if cleanup:
        for _folder in (
            NIXPKGS_ALIASES_ALIASES_FOLDER,
            NIXPKGS_ALIASES_GCROOTS_FOLDER,
            NIXPKGS_ALIASES_GCROOTS_FOLDER,
        ):
            for _file in _folder.glob("*"):
                with contextlib.suppress(FileNotFoundError):
                    _file.unlink()

    _subprocess_run(CMD_UPDATE_FLAKE)
    _nodes = json.loads(pathlib.Path("flake.lock").read_text())["nodes"]
    _revs = {
        _node_name.replace("i-", "n-"): _node_value["locked"]["rev"]
        for _node_name, _node_value in _nodes.items()
        if _node_name.startswith("i-")
    }

    print(repr(_revs))

    with sqlite3_autocommit_connection("database.sqlite3") as _con_map:
        _con_map.execute("DELETE FROM nixpkgs_bin;")

        _nixpkgs: list[NixpkgEntry] = [
            NixpkgEntry(
                rev=_revs[_row[0]],
                input=_row[0],
                pname=_row[1],
                disabled=_row[2],
            )
            for _row in _con_map.execute(
                "SELECT input, pname, disabled FROM nixpkgs ORDER BY pname;"
            )
        ]

    random.shuffle(_nixpkgs)
    do_multiprocessing(_process_nixpkg, _nixpkgs, 3)

    with sqlite3_autocommit_connection("database.sqlite3") as _con_reduce:
        _binaries = [
            {
                "input": _row[0],
                "pname": _row[1],
                "bin": _row[2],
            }
            for _row in _con_reduce.execute(
                "SELECT input, pname, bin FROM nixpkgs_bin ORDER BY input, pname, bin;",
            )
        ]
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
            _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE.read_text())
            for _binary in _binaries:
                _input = _binary["input"]
                _pname = _binary["pname"]
                _suffix = _binary["bin"]
                _app_key = _escape_nix_set_key(_suffix.removeprefix("/bin/"))
                _flake_file.write(
                    f"      apps.{_app_key} = {'{'} type = \"app\"; program = \"${'{'}{_input}.{_pname}{'}'}{_suffix}\"; {'}'};\n"
                )
            for _package in _packages:
                _input = _package["input"]
                _pname = _package["pname"]
                _package_key = _escape_nix_set_key(_pname)
                _flake_file.write(
                    f"      packages.{_package_key} = {_input}.{_pname};\n"
                )
            _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE.read_text())
        _descriptions = _subprocess_run(PACKAGE_DESCRIPTIONS)
        if _descriptions.stdout == b"":
            return

        _descriptions = [
            {
                "pname": k,
                "description": v["description"],
            }
            for k, v in json.loads(_descriptions.stdout)["packages"][
                "x86_64-linux"
            ].items()
            if "description" in v
        ]
        _con_reduce.executemany(
            "UPDATE nixpkgs SET description = :description WHERE pname = :pname;",
            _descriptions,
        )


MULTIPROCESSING = True
T = typing.TypeVar("T")


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


class NixpkgEntry(typing.TypedDict):
    rev: str
    input: str
    pname: str
    disabled: str


def _process_nixpkg(_data: NixpkgEntry):
    _rev = _data["rev"]
    _pname = _data["pname"]
    _disabled = _data["disabled"]
    _input = _data["input"]
    if _disabled is None:
        _build = _subprocess_run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' build --json --no-link"
                ),
                f"github:NixOS/nixpkgs/{_rev}#{_pname}",
            ]
        )
        if _build.stdout == b"":
            print({"out": b"", "_data": _data})
        _build_paths = json.loads(_build.stdout)
        for _output in _build_paths:
            if "outputs" in _output:
                for k, v in _output["outputs"].items():
                    _ln_s(
                        source=NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(
                            f"system-{_pname}-{k}"
                        ),
                        target=pathlib.Path(v),
                    )

    _eval = _subprocess_run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' eval --json"
            ),
            f"github:NixOS/nixpkgs/{_rev}#{_pname}",
        ],
    )

    if _eval.stdout == b"":
        return

    _prefix = pathlib.Path(json.loads(_eval.stdout))

    _ln_s(
        source=NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(f"system-{_pname}"),
        target=_prefix,
    )

    if _disabled is not None:
        return
    _packages = []
    with sqlite3_autocommit_connection("database.sqlite3") as con:
        for _candidate_bin_path in _prefix.rglob("*"):
            if _candidate_bin_path.is_dir():
                continue
            _bin = _candidate_bin_path.name
            if (
                _bin.startswith(".")
                or _bin.endswith(".so")
                or _bin.endswith("-wrapped")
                or _bin.endswith("-wrapped_")
            ):
                continue

            if (
                _candidate_bin_path.is_file()
                and _candidate_bin_path.stat().st_mode & 0o111
            ) or (
                _candidate_bin_path.is_symlink()
                and _candidate_bin_path.resolve().stat().st_mode & 0o111
            ):
                _suffix = _candidate_bin_path.as_posix().removeprefix(
                    _prefix.as_posix()
                )
                if not _suffix.startswith("/bin/"):
                    print({"_suffix": _suffix})
                    continue
                if "/" in _suffix.removeprefix(
                    "/bin/"
                ):  # "${n-23-05.mailutils}/bin/mu-mh/ali"
                    print({"_suffix": _suffix})
                    continue

                if not NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).exists():
                    _packages.append(
                        {
                            "input": _input,
                            "pname": _pname,
                            "bin": _suffix,
                        }
                    )
                    _ln_s(
                        source=NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin),
                        target=NIXPKGS_ALIASES_RUN_FILE,
                    )
        con.executemany(
            "INSERT INTO nixpkgs_bin(input, pname, bin) VALUES (:input, :pname, :bin) ON CONFLICT DO NOTHING;",
            _packages,
        )


if __name__ == "__main__":
    main()
