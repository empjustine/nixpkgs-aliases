#!/usr/bin/env python3
import argparse
import json
import pathlib
import shlex
import subprocess


def _mtime(path):
    try:
        return pathlib.Path(path).stat().st_mtime
    except:
        return 0


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument("--src", type=str, help="src")
    parser.add_argument("--target", type=str, help="target")
    parser.add_argument("--expr", type=str, help="base nix expression")

    args = parser.parse_args()
    meta = json.loads(pathlib.Path(args.target).read_text())
    outputs_to_install = meta["meta"]["outputsToInstall"]
    if all(
        pathlib.Path(path).exists()
        for out, path in meta.items()
        if out in outputs_to_install
    ):
        raise IOError(meta)

    subprocess.run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' build --no-link"
            ),
            meta["...flakeref"],
        ],
        encoding="utf8",
    )


if __name__ == "__main__":
    main()
