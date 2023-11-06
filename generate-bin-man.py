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

_GCROOTS_D = pathlib.Path("gcroots")
_BIN_D = pathlib.Path("bin")


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


def main():
    for _folder in (_BIN_D,):
        _folder.mkdir(parents=True, exist_ok=True)
    for _file in _folder.glob("*"):
        with contextlib.suppress(FileNotFoundError):
            _file.unlink()

    for _bin in _GCROOTS_D.glob("*^*/bin/*"):
        if _bin.is_dir() or _bin.name.startswith(".") or _bin.name.endswith("-wrapped"):
            continue
        if _bin.name == "git" or _bin.name.startswith("System.") or _bin.name.endswith(".dll"):
            continue
        if not _BIN_D.joinpath(_bin.name).exists():
            _target = pathlib.Path("../" + str(_bin))
            _ln_s(
                source=_BIN_D.joinpath(_bin.name),
                target=_target,
            )


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


if __name__ == "__main__":
    main()
