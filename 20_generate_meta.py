#!/usr/bin/env python3
import collections.abc
import json
import logging
import pathlib
import shlex
import subprocess
import typing


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def main():
    subprocess.run(
        shlex.split("find legacyPackages.x86_64-linux.meta/ -depth -print -delete")
    )
    subprocess.run(shlex.split("mkdir -p legacyPackages.x86_64-linux.meta"))

    flakerefs = {
        _jsonnl["original-flakeref"]: _jsonnl["locked-flakeref"]
        for _jsonnl in [
            json.loads(_line)
            for _line in subprocess.run(
                ["bin-override/flake.lock-inputs.sh"],
                stdout=subprocess.PIPE,
                encoding="utf8",
            ).stdout.splitlines(keepends=False)
        ]
    }

    _packages = [
        json.loads(p.read_text())
        for p in pathlib.Path("legacyPackages.x86_64-linux").glob("*")
    ]
    for _package in _packages:
        if _package["flakeref"] in flakerefs:
            _package["flakeref"] = flakerefs[_package["flakeref"]]

    do_multiprocessing(do_package, _packages, 24)


def do_package(_package):
    pathlib.Path("legacyPackages.x86_64-linux.meta", _package["attrpath"]).write_text(
        subprocess.run(
            [
                *shlex.split(
                    "nix --extra-experimental-features 'nix-command flakes' eval --json"
                ),
                f'{_package["flakeref"]}#legacyPackages.x86_64-linux.{_package["attrpath"]}.meta',
            ],
            stdout=subprocess.PIPE,
            encoding="utf8",
        ).stdout
    )


T = typing.TypeVar("T")


def do_multiprocessing(
    _worker: collections.abc.Callable[[T], typing.Any],
    _jobs: typing.Iterable[T],
    _pool_size: typing.Optional[int] = None,
):
    if _pool_size:
        import multiprocessing

        with multiprocessing.Pool(_pool_size) as _pool:
            for _ in _pool.imap_unordered(
                func=_worker, iterable=_jobs, chunksize=20 * _pool_size
            ):
                ...
    else:
        for _job in _jobs:
            _worker(_job)


if __name__ == "__main__":
    main()
