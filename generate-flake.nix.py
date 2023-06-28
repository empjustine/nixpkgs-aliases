#!/usr/bin/env python3
import contextlib
import json
import logging
import os
import pathlib
import shlex
import subprocess

NIXPKG_BINARY_PATHS = [
    "bin",
    "lib/node_modules/.bin",
]
FLAKE_NIX_DENY_LIST = json.loads(pathlib.Path("nixpkgs-deny.json").read_text())

XDG_DATA_HOME = os.environ.get(
    "XDG_DATA_HOME", pathlib.Path.home().joinpath(".local/share")
)
NIX_CHROOT = pathlib.Path(XDG_DATA_HOME, "nix/root")
FLAKES_GCROOTS = NIX_CHROOT.joinpath("nix/var/nix/gcroots/nixkpgs-alias")


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def nixpkgs_flake_lock_url():
    subprocess.run(
        shlex.split(
            "nix --extra-experimental-features 'nix-command flakes' flake update path:."
        ),
    )
    with pathlib.Path("flake.lock").open() as _flake_lock_file:
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


def _deny_list(_nixpkg_name, _nix_store_subpath, _candidate_store_bin):
    for _denylist_entry in FLAKE_NIX_DENY_LIST:
        if _denylist_entry["package"] == _nixpkg_name and _denylist_entry[
            "binary"
        ] == str(pathlib.Path(_nix_store_subpath, _candidate_store_bin.name)):
            return True


def main():
    _root = nixpkgs_flake_lock_url()

    FLAKES_GCROOTS.mkdir(parents=True, exist_ok=True)
    for _bin in pathlib.Path("aliases").glob("*"):
        with contextlib.suppress(FileNotFoundError):
            _bin.unlink()

    with pathlib.Path("flake.nix").open("w") as _flake_file:
        _flake_file.write(pathlib.Path("flake.nix.header").read_text())
        for _nixpkg_name in json.loads(pathlib.Path("nixpkgs-allow.json").read_text()):
            subprocess.run(
                [
                    *shlex.split(
                        "nix --extra-experimental-features 'nix-command flakes' build"
                    ),
                    f"{_root}#{_nixpkg_name}",
                ],
            )
            _nix_store_path = json.loads(
                subprocess.run(
                    [
                        *shlex.split(
                            "nix --extra-experimental-features 'nix-command flakes' eval --json"
                        ),
                        f"{_root}#{_nixpkg_name}.outPath",
                    ],
                    capture_output=True,
                ).stdout
            )
            print({"_nixpkg_name": _nixpkg_name, "_store_path": _nix_store_path})
            for _nix_store_subpath in NIXPKG_BINARY_PATHS:
                _relative_nix_store_path = str(_nix_store_path).lstrip("/")
                _candidate_store_bins = NIX_CHROOT.joinpath(
                    _relative_nix_store_path, _nix_store_subpath
                ).glob("*")
                for _candidate_store_bin in _candidate_store_bins:
                    _bin = _candidate_store_bin.name
                    if _bin.startswith(".") and _bin.endswith("-wrapped"):
                        continue
                    if _bin.startswith(".") and _bin.endswith("-wrapped_"):
                        continue

                    if not _deny_list(
                        _nixpkg_name, _nix_store_subpath, _candidate_store_bin
                    ):
                        _nix_key = _escape_nix_set_key(_bin)
                        _apps_nix_expression = f"      apps.{_nix_key} = {'{'} type = \"app\"; program = \"${'{'}pkgs.{_nixpkg_name}{'}'}/{_nix_store_subpath}/{_bin}\"; {'}'};\n"
                        _packages_nix_expression = (
                            f"      packages.{_nix_key} = pkgs.{_nixpkg_name};\n"
                        )
                        _flake_file.write(_apps_nix_expression)
                        _flake_file.write(_packages_nix_expression)
                        pathlib.Path("aliases", _bin).symlink_to(
                            pathlib.Path("../nixpkgs-aliases-run.sh")
                        )
                        with contextlib.suppress(FileNotFoundError):
                            FLAKES_GCROOTS.joinpath(f"r-{_bin}").unlink()
                        with contextlib.suppress(FileNotFoundError):
                            FLAKES_GCROOTS.joinpath(f"c-{_bin}").unlink()
                        FLAKES_GCROOTS.joinpath(f"r-{_bin}").symlink_to(
                            pathlib.Path(_nix_store_path)
                        )
                        FLAKES_GCROOTS.joinpath(f"c-{_bin}").symlink_to(
                            NIX_CHROOT.joinpath(_nix_store_path)
                        )
            if (
                _nixpkg_name == "gitFull"
            ):  # special case for git-gui, that is located in /libexec/git-core/git-gui
                pathlib.Path("aliases", "git-gui").symlink_to(
                    pathlib.Path("../nixpkgs-aliases-run.sh")
                )
        _flake_file.write(pathlib.Path("flake.nix.footer").read_text())

        for _result_file in [
            "result",
            "result-bin",
            "result-dnsutils",
            "result-doc",
            "result-man",
        ]:
            with contextlib.suppress(FileNotFoundError):
                pathlib.Path(_result_file).unlink()


if __name__ == "__main__":
    main()
