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


def _subprocess_run(_cmd):
    _env = dict(os.environ)
    _env["TERM"] = "dumb"
    _result = subprocess.run(_cmd, capture_output=True, env=_env)
    # 0: stdin
    # 1: stdout
    # 2: stderr
    print(
        {
            "$@": shlex.join(_cmd),
            1: _result.stdout.decode("utf-8", "surrogateescape"),
            2: _result.stderr.decode("utf-8", "surrogateescape"),
        }
    )
    return _result


def _escape_nix_set_key(_name):
    if '"' in _name:
        msg = f"unhandled name {_name}"
        raise OSError(msg)
    if "." in _name:
        return f'"{_name}"'
    return _name


@contextlib.contextmanager
def sqlite3_autocommit_connection(database):
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
    _rev = json.loads(pathlib.Path("flake.lock").read_text())["nodes"]["nixpkgs"][
        "locked"
    ]["rev"]
    with sqlite3_autocommit_connection("database.sqlite3") as _con_map:
        if cleanup:
            for _statement in [
                "DELETE FROM rev WHERE rev.rev NOT IN (SELECT rev.rev FROM rev ORDER BY rev.ctime DESC LIMIT 3);",
                "DELETE FROM nixpkg_rev WHERE rev NOT IN (SELECT DISTINCT rev FROM rev);",
                "DELETE FROM nixpkg_rev_bin WHERE rev NOT IN (SELECT DISTINCT rev FROM rev);",
            ]:
                with transaction(_con_map):
                    _con_map.execute(_statement)
        for _statement in [
            "DELETE FROM nixpkg_rev WHERE nixpkg_rev.rev = :rev;",
            "DELETE FROM nixpkg_rev_bin WHERE nixpkg_rev_bin.rev = :rev;",
        ]:
            with transaction(_con_map):
                _con_map.execute(_statement, {"rev": _rev})
        _con_map.execute(
            "INSERT INTO rev(rev, flakeref) VALUES (:rev, 'github:NixOS/nixpkgs/nixos-23.05') ON CONFLICT DO NOTHING;",
            {"rev": _rev},
        )
        _nixpkgs: list[NixpkgEntry] = [
            {
                "pname": _row[0],
                "disabled": _row[1],
                "rev": _rev,
            }
            for _row in _con_map.execute(
                "SELECT pname, disabled FROM nixpkg ORDER BY pname;"
            )
        ]

    random.shuffle(_nixpkgs)
    do_multiprocessing(_process_nixpkg, _nixpkgs, 3)

    with sqlite3_autocommit_connection("database.sqlite3") as _con_reduce:
        _binaries = [
            {"pname": _row[0], "bin": _row[1]}
            for _row in _con_reduce.execute(
                "SELECT pname, bin FROM nixpkg_rev_bin WHERE rev = :rev ORDER BY pname, bin;",
                {"rev": _rev},
            )
        ]
        _packages = [
            {
                "pname": _row[0],
            }
            for _row in _con_reduce.execute(
                "SELECT DISTINCT pname FROM nixpkg ORDER BY pname;",
                {"rev": _rev},
            )
        ]
        with pathlib.Path("flake.nix").open("w") as _flake_file:
            _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE.read_text())
            for _binary in _binaries:
                _pname = _binary["pname"]
                _suffix = _binary["bin"]
                _raw_nix_key = _suffix.removeprefix("/bin/")
                _flake_file.write(
                    f"      apps.{_escape_nix_set_key(_raw_nix_key)} = {'{'} type = \"app\"; program = \"${'{'}pkgs.{_pname}{'}'}{_suffix}\"; {'}'};\n"
                )
            for _binary in _packages:
                _flake_file.write(
                    f"      packages.{_escape_nix_set_key(_binary['pname'])} = pkgs.{_binary['pname']};\n"
                )
            _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE.read_text())
        _descriptions = _subprocess_run(PACKAGE_DESCRIPTIONS)
        if _descriptions.stdout == b"":
            return

        for k, v in json.loads(_descriptions.stdout)["packages"][
            "x86_64-linux"
        ].items():
            if "description" in v:
                _con_reduce.execute(
                    "UPDATE nixpkg SET description = :description WHERE pname = :pname;",
                    {
                        "pname": k,
                        "description": v["description"],
                    },
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
    pname: str
    disabled: str


def _process_nixpkg(_data: NixpkgEntry):
    _rev = _data["rev"]
    _pname = _data["pname"]
    _disabled = _data["disabled"]
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
                    NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(
                        f"system-{_pname}-{k}"
                    ).symlink_to(pathlib.Path(v))

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

    NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(f"system-{_pname}").symlink_to(_prefix)

    with sqlite3_autocommit_connection("database.sqlite3"):
        if _disabled is not None:
            return
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
                    continue

                with sqlite3_autocommit_connection("database.sqlite3") as con:
                    con.execute(
                        "INSERT INTO nixpkg_rev_bin(pname, bin, rev) VALUES (:pname, :bin, :rev);",
                        {
                            "pname": _pname,
                            "rev": _rev,
                            "bin": _suffix,
                        },
                    )
                if not NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).exists():
                    NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).symlink_to(
                        NIXPKGS_ALIASES_RUN_FILE
                    )


if __name__ == "__main__":
    main()
