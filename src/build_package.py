#!/usr/bin/env python3
import argparse
import json
import pathlib
import shlex
import subprocess
import sys


def _mtime(path):
    try:
        return pathlib.Path(path).stat().st_mtime
    except:
        return 0


def main():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("--meta", type=str, help="meta")

    args = parser.parse_args()
    meta = json.loads(pathlib.Path(args.meta).read_text())

    if "...flakeref" not in meta:
        sys.stderr.write(f"{meta}\n")
        return

    flakeref = meta["...flakeref"]

    outputs_to_install = meta["meta"]["outputsToInstall"]

    if all(
        pathlib.Path(path).exists()
        for out, path in meta.items()
        if out in outputs_to_install
    ):
        sys.stderr.write(f"{meta}\n")
        return

    subprocess.run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' build --no-link",
            ),
            flakeref,
        ],
        encoding="utf8",
    )


if __name__ == "__main__":
    main()
