#!/usr/bin/env python3
import contextlib
import json
import logging
import pathlib
import shlex
import subprocess
import sqlite3

NIXPKGS_ALIASES_FLAKE_NIX_FILE = pathlib.Path("flake.nix")
NIXPKGS_ALIASES_FLAKE_LOCK_FILE = pathlib.Path("flake.lock")
NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE = pathlib.Path("flake.nix.footer")
NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE = pathlib.Path("flake.nix.header")
NIXPKGS_ALIASES_RUN_FILE = pathlib.Path("../nixpkgs-aliases-run.sh")
NIXPKGS_ALIASES_GCROOTS_FOLDER = pathlib.Path("gcroots")
NIXPKGS_ALIASES_ALIASES_FOLDER = pathlib.Path("aliases")

NIXPKG_BINARY_SEARCH_PATHS = [
    "bin",
    "lib/node_modules/.bin",
]
NIXPKGS_ALIASES_DENY_LIST = json.loads(pathlib.Path("nixpkgs-deny.json").read_text())

XDG_DATA_HOME_FOLDER = pathlib.Path("../.local/share")
NIX_CHROOT_FOLDER = pathlib.Path("../nix/root")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def _nixpkgs_flakeref():
    subprocess.run(
        shlex.split(
            "nix --extra-experimental-features 'nix-command flakes' flake update path:."
        ),
    )
    with NIXPKGS_ALIASES_FLAKE_LOCK_FILE.open() as _flake_lock_file:
        _flake_lock = json.load(_flake_lock_file)
        _rev = _flake_lock["nodes"]["nixpkgs"]["locked"]["rev"]
    with sqlite3_autocommit_connection("database.sqlite3") as con:
        with contextlib.suppress(sqlite3.IntegrityError):
            con.execute(
                "INSERT INTO rev(rev, flakeref) VALUES (:rev, 'github:NixOS/nixpkgs/nixos-23.05')",
                {"rev": _rev},
            )
    return _rev


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
    _connection.execute("pragma journal_mode=wal")
    _connection.execute("pragma foreign_keys=1")
    _connection.execute("pragma busy_timeout=5000")
    _connection.execute("pragma synchronous=NORMAL")
    with contextlib.closing(_connection):
        yield _connection


@contextlib.contextmanager
def transaction(_connection: sqlite3.Connection):
    """
    begin a transaction
    """
    _connection.execute("BEGIN")
    try:
        yield
    except:
        _connection.rollback()
        raise
    else:
        _connection.commit()


def _deny_list(_package, _path, _bin):
    for _denylist_entry in NIXPKGS_ALIASES_DENY_LIST:
        if (
            _denylist_entry["package"] == _package
            and _denylist_entry["path"] == _path
            and _denylist_entry["bin"] == _bin
        ):
            return True


def main():
    NIXPKGS_ALIASES_ALIASES_FOLDER.mkdir(parents=True, exist_ok=True)
    NIXPKGS_ALIASES_GCROOTS_FOLDER.mkdir(parents=True, exist_ok=True)

    for _alias in NIXPKGS_ALIASES_ALIASES_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _alias})
            _alias.unlink()
    for _gcroot in NIXPKGS_ALIASES_GCROOTS_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _gcroot})
            _gcroot.unlink()
    for _store_subpath in NIXPKGS_ALIASES_GCROOTS_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _store_subpath})
            _store_subpath.unlink()

    _rev = _nixpkgs_flakeref()

    with sqlite3_autocommit_connection("database.sqlite3") as con:
        _data = [
            {
                "pname": _row[0],
                "rev": _rev,
            }
            for _row in con.execute(
                "SELECT nixpkg.pname FROM nixpkg WHERE nixpkg.disabled IS NULL"
            )
        ]

    # with multiprocessing.Pool(2) as pool:
    #     for i in pool.imap_unordered(_process_nixpkg_allow, _data):
    #         print(i)
    for _d in _data:
        _process_nixpkg_allow(_d)

    with sqlite3_autocommit_connection("database.sqlite3") as con:
        _data2 = [
            {
                "pname": _row[0],
                "bin": _row[1],
                "rev": _row[2],
            }
            for _row in con.execute(
                "SELECT pname, bin, rev FROM nixpkg_rev_bin WHERE rev = :rev ORDER BY pname, bin",
                {"rev": _rev},
            )
        ]
    with NIXPKGS_ALIASES_FLAKE_NIX_FILE.open("w") as _flake_file:
        _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE.read_text())
        for _d in _data2:
            _pname = _d["pname"]
            _suffix = _d["bin"]
            _raw_nix_key = _suffix.rsplit("/", maxsplit=1)[1]
            _nix_key = _escape_nix_set_key(_raw_nix_key)
            _flake_file.write(
                f"      apps.{_nix_key} = {'{'} type = \"app\"; program = \"${'{'}pkgs.{_pname}{'}'}{_suffix}\"; {'}'};\n"
            )
            _flake_file.write(f"      packages.{_nix_key} = pkgs.{_pname};\n")
        with sqlite3_autocommit_connection("database.sqlite3") as con:
            _data3 = [
                {
                    "pname": _row[0],
                }
                for _row in con.execute(
                    "SELECT nixpkg.pname FROM nixpkg LEFT OUTER JOIN nixpkg_rev_bin on (nixpkg.pname = nixpkg_rev_bin.pname) WHERE nixpkg.disabled IS NULL AND nixpkg_rev_bin.bin IS NULL"
                )
            ]
        for _d in _data3:
            _flake_file.write(
                "      # package doesn't contain binaries, or binary name doesn't match package name\n"
            )
            _flake_file.write(
                f"      packages.{_escape_nix_set_key(_d['pname'])} = pkgs.{_d['pname']};\n"
            )
        _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE.read_text())


def _process_nixpkg_allow(_data):
    _rev = _data["rev"]
    _flakeref = f"github:NixOS/nixpkgs/{_rev}"
    _pname = _data["pname"]
    _flakeurl = f"{_flakeref}#{_pname}"
    _outputs = json.loads(
        subprocess.run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' build --json --no-link"
                ),
                _flakeurl,
            ],
            capture_output=True,
        ).stdout
    )
    print(repr({"_flakeurl": _flakeurl, "_outputs": _outputs}))

    with sqlite3_autocommit_connection("database.sqlite3") as con:
        with contextlib.suppress(sqlite3.IntegrityError):
            with transaction(con):
                con.execute(
                    "INSERT INTO nixpkg_rev(pname, hash, etc) VALUES (:pname, :hash, :etc)",
                    {
                        "pname": _pname,
                        "hash": _rev,
                        "etc": json.dumps(_outputs, ensure_ascii=False),
                    },
                )
                print(
                    repr(
                        {
                            "pname": _pname,
                            "hash": _rev,
                            "etc": json.dumps(_outputs, ensure_ascii=False),
                        }
                    )
                )

    for _out_name, _out in _outputs[0]["outputs"].items():
        _prefix = pathlib.Path(_out).as_posix()
        for _candidate_bin_path in pathlib.Path(_out).glob("bin/**/*"):
            if _candidate_bin_path.is_dir():
                continue
            _bin = _candidate_bin_path.name
            if _bin.startswith(".") and _bin.endswith("-wrapped"):
                continue
            if _bin.startswith(".") and _bin.endswith("-wrapped_"):
                continue
            if (
                _candidate_bin_path.is_file()
                and _candidate_bin_path.stat().st_mode & 0o111
            ):
                with sqlite3_autocommit_connection("database.sqlite3") as con:
                    _suffix = _candidate_bin_path.as_posix().removeprefix(_prefix)
                    with contextlib.suppress(sqlite3.IntegrityError):
                        con.execute(
                            "INSERT INTO nixpkg_rev_bin(pname, bin, rev) VALUES (:pname, :bin, :rev)",
                            {
                                "pname": _pname,
                                "rev": _rev,
                                "bin": _suffix,
                            },
                        )
                _nix_key = _escape_nix_set_key(_bin)
                print(
                    {
                        "pname": _pname,
                        "rev": _rev,
                        "bin": _suffix,
                    }
                )
            if (
                _candidate_bin_path.is_symlink()
                and _candidate_bin_path.resolve().stat().st_mode & 0o111
            ):
                with sqlite3_autocommit_connection("database.sqlite3") as con:
                    _suffix = _candidate_bin_path.as_posix().removeprefix(_prefix)
                    with contextlib.suppress(sqlite3.IntegrityError):
                        con.execute(
                            "INSERT INTO nixpkg_rev_bin(pname, bin, rev) VALUES (:pname, :bin, :rev)",
                            {
                                "pname": _pname,
                                "rev": _rev,
                                "bin": _suffix,
                            },
                        )
                        print(
                            {
                                "pname": _pname,
                                "rev": _rev,
                                "bin": _suffix,
                            }
                        )
            if not NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).exists():
                NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).symlink_to(
                    NIXPKGS_ALIASES_RUN_FILE
                )
        NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(
            f"system-{_pname}-{_out_name}"
        ).symlink_to(_out)


if __name__ == "__main__":
    main()
