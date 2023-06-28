#!/usr/bin/env python3
import contextlib
import json
import logging
import pathlib
import shlex
import subprocess

NIXPKGS_ALIASES_FLAKE_NIX_FILE = pathlib.Path("flake.nix")
NIXPKGS_ALIASES_FLAKE_LOCK_FILE = pathlib.Path("flake.lock")
NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE = pathlib.Path("flake.nix.footer")
NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE = pathlib.Path("flake.nix.header")
NIXPKGS_ALIASES_ALLOW_LIST_FILE = pathlib.Path("nixpkgs-allow.ndjson")
NIXPKGS_ALIASES_DENY_LIST_FILE = pathlib.Path("nixpkgs-deny.json")
NIXPKGS_ALIASES_RUN_FILE = pathlib.Path("../nixpkgs-aliases-run.sh")
NIXPKGS_ALIASES_GCROOTS_FOLDER = pathlib.Path("gcroots")
NIXPKGS_ALIASES_ALIASES_FOLDER = pathlib.Path("aliases")

NIXPKG_BINARY_SEARCH_PATHS = [
    "bin",
    "lib/node_modules/.bin",
]
NIXPKGS_ALIASES_DENY_LIST = json.loads(NIXPKGS_ALIASES_DENY_LIST_FILE.read_text())

XDG_DATA_HOME_FOLDER = pathlib.Path("../.local/share")
NIX_CHROOT_FOLDER = pathlib.Path("../nix/root")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    NIXPKGS_ALIASES_ALIASES_FOLDER.mkdir(parents=True, exist_ok=True)
    NIXPKGS_ALIASES_GCROOTS_FOLDER.mkdir(parents=True, exist_ok=True)


def nixpkgs_flake_lock_url():
    subprocess.run(
        shlex.split(
            "nix --extra-experimental-features 'nix-command flakes' flake update path:."
        ),
    )
    with NIXPKGS_ALIASES_FLAKE_LOCK_FILE.open() as _flake_lock_file:
        _flake_lock = json.load(_flake_lock_file)
        _rev = _flake_lock["nodes"]["nixpkgs"]["locked"]["rev"]
        _flake_nixpkgs_url_root = f"github:NixOS/nixpkgs/{_rev}"
        return _flake_nixpkgs_url_root


def _escape_nix_set_key(_name):
    if '"' in _name:
        msg = f"unhandled name {_name}"
        raise OSError(msg)
    if "." in _name:
        return f'"{_name}"'
    return _name


def _deny_list(_package, _path, _bin):
    for _denylist_entry in NIXPKGS_ALIASES_DENY_LIST:
        if (
            _denylist_entry["package"] == _package
            and _denylist_entry["path"] == _path
            and _denylist_entry["bin"] == _bin
        ):
            return True


def main():
    _flake_url_root = nixpkgs_flake_lock_url()
    _packages_added = set()

    for _alias in NIXPKGS_ALIASES_ALIASES_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _alias})
            _alias.unlink()
    for _gcroot in NIXPKGS_ALIASES_GCROOTS_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _gcroot})
            _gcroot.unlink()
    NIXPKGS_ALIASES_GCROOTS_FOLDER.mkdir(parents=True, exist_ok=True)
    for _store_subpath in NIXPKGS_ALIASES_GCROOTS_FOLDER.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            print({"rm": _store_subpath})
            _store_subpath.unlink()

    with NIXPKGS_ALIASES_FLAKE_NIX_FILE.open(
        "w"
    ) as _flake_file, NIXPKGS_ALIASES_ALLOW_LIST_FILE.open() as _nixpkgs_ndjson:
        _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_HEADER_FILE.read_text())
        for _nixpkg_metadata_json in _nixpkgs_ndjson:
            _process_nixpkg_allow(
                _flake_file, _nixpkg_metadata_json, _packages_added, _flake_url_root
            )
        _flake_file.write(NIXPKGS_ALIASES_FLAKE_NIX_FOOTER_FILE.read_text())

        for _result_file in [
            "result",
            "result-bin",
            "result-dnsutils",
            "result-doc",
            "result-man",
        ]:
            with contextlib.suppress(FileNotFoundError):
                pathlib.Path(_result_file).unlink()


def _process_nixpkg_allow(
    _flake_file, _nixpkg_metadata_json, _packages_added, _flake_url_root
):
    _nixpkg_metadata = json.loads(_nixpkg_metadata_json)
    if "disabled" in _nixpkg_metadata.keys():
        return

    _package_name = _nixpkg_metadata["package"]
    subprocess.run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' build"
            ),
            f"{_flake_url_root}#{_package_name}",
        ],
    )
    _package_store_absolute_path = json.loads(
        subprocess.run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f"{_flake_url_root}#{_package_name}.outPath",
            ],
            capture_output=True,
        ).stdout
    )
    _package_store_relative_path = str(_package_store_absolute_path).lstrip("/")
    print(
        {
            "_package": _package_name,
            "_relative_nix_store_path": _package_store_relative_path,
        }
    )
    for _subpath in NIXPKG_BINARY_SEARCH_PATHS:
        for _candidate_bin_path in NIX_CHROOT_FOLDER.joinpath(
            _package_store_relative_path, _subpath
        ).glob("*"):
            _bin = _candidate_bin_path.name
            if _bin.startswith(".") and _bin.endswith("-wrapped"):
                continue
            if _bin.startswith(".") and _bin.endswith("-wrapped_"):
                continue

            if not _deny_list(_package_name, _subpath, _bin):
                _nix_key = _escape_nix_set_key(_bin)
                _flake_file.write(
                    f"      apps.{_nix_key} = {'{'} type = \"app\"; program = \"${'{'}pkgs.{_package_name}{'}'}/{_subpath}/{_bin}\"; {'}'};\n"
                )
                _flake_file.write(
                    f"      packages.{_nix_key} = pkgs.{_package_name};\n"
                )
                _packages_added.add(_nix_key)
                NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath(_bin).symlink_to(
                    NIXPKGS_ALIASES_RUN_FILE
                )
    NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(f"r-{_package_name}").symlink_to(
        pathlib.Path(_package_store_absolute_path)
    )
    NIXPKGS_ALIASES_GCROOTS_FOLDER.joinpath(f"c-{_package_name}").symlink_to(
        pathlib.Path("../../nix/root", _package_store_relative_path)
        # nixpkgs-aliases/chroot/../../nix/root
    )
    if _package_name == "gitFull":
        # special case for git-gui, that is located in /libexec/git-core/git-gui
        NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath("git-gui").symlink_to(
            NIXPKGS_ALIASES_RUN_FILE
        )
    if _package_name == "nixStatic":
        # special case for nix, should be direct link to chroot store path
        NIXPKGS_ALIASES_ALIASES_FOLDER.joinpath("nix").symlink_to(
            pathlib.Path("../../nix/root", _package_store_relative_path, "bin/nix")
        )
    if _package_name not in _packages_added:
        _flake_file.write(
            "      # package doesn't contain binaries, or binary name doesn't match package name\n"
        )
        _flake_file.write(f"      packages.{_package_name} = pkgs.{_package_name};\n")


if __name__ == "__main__":
    main()
