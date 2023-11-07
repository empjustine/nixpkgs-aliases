#!/usr/bin/env python3
import collections.abc
import contextlib
import json
import logging
import pathlib
import shlex
import subprocess
import typing

_subprocess_logger = logging.getLogger("subprocess")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    _subprocess_logger.level = logging.DEBUG


def main():
    subprocess.run(
        shlex.split("find legacyPackages.x86_64-linux.broken/ -depth -print -delete")
    )
    subprocess.run(shlex.split("mkdir -p legacyPackages.x86_64-linux.broken"))

    for _folder in (pathlib.Path("gcroots"),):
        _folder.mkdir(parents=True, exist_ok=True)
        for _file in _folder.glob("*"):
            with contextlib.suppress(FileNotFoundError):
                _file.unlink()

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
    _metas = [
        {**json.loads(p.read_text()), "pname": str(p.name)}
        for p in pathlib.Path("legacyPackages.x86_64-linux.meta").glob("*")
    ]

    _unfree = []
    _broken = []
    _insecure = []
    _disabled = []

    _outputs_to_install = {}
    for _meta in _metas:
        if _meta["unfree"]:
            _unfree.append(_meta["pname"])
        if _meta["broken"]:
            _broken.append(_meta["pname"])
        if _meta["insecure"]:
            _insecure.append(_meta["pname"])
        if not _meta["unfree"] and not _meta["broken"] and not _meta["insecure"]:
            _outputs_to_install[_meta["pname"]] = _meta["outputsToInstall"]
    _package_outputs = []

    for _package in _packages:
        if _package["disabled"]:
            _disabled.append(_package["attrpath"])
            continue
        if _package["flakeref"] in flakerefs:
            _package["flakeref"] = flakerefs[_package["flakeref"]]
        if _package["attrpath"] in _outputs_to_install:
            for _output_to_install in _outputs_to_install[_package["attrpath"]]:
                _package_outputs.append(
                    {
                        "flakeref": _package["flakeref"],
                        "attrpath": _package["attrpath"],
                        "output": _output_to_install,
                    }
                )

    do_multiprocessing(do_package_output, _package_outputs, 24)


def do_package_output(_package):
    _proc = subprocess.run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' eval --raw"
            ),
            f'{_package["flakeref"]}#legacyPackages.x86_64-linux.{_package["attrpath"]}.{_package["output"]}',
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf8",
    )

    if _proc.stdout == "":
        _file = pathlib.Path("legacyPackages.x86_64-linux.broken", _package["attrpath"])
        _first_line, _, _rest = _proc.stderr.partition("\n")
        if (
            _first_line.startswith("error (ignored): error: SQLite database '/")
            and _first_line.endswith(".sqlite' is busy")
            and _rest != ""
        ):
            _file.write_text(_rest)
        else:
            _file.write_text(_proc.stderr)
    else:
        source = pathlib.Path(
            "gcroots", _package["attrpath"] + "^" + _package["output"]
        )
        target = pathlib.Path(_proc.stdout.strip())
        subprocess.run(["ln", "-s", "--", target, source])


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
