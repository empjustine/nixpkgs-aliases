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

    parser.add_argument("--src", type=str, help="src")
    parser.add_argument("--target", type=str, help="target")
    parser.add_argument("--expr", type=str, help="base nix expression")

    args = parser.parse_args()

    # --no-eval-cache
    raw_meta = subprocess.run(
        [
            *shlex.split(
                "nix --extra-experimental-features 'nix-command flakes' eval --json"
            ),
            args.expr + ".meta",
        ],
        stdout=subprocess.PIPE,
        encoding="utf8",
    ).stdout
    meta = json.loads(raw_meta)
    package = json.loads(pathlib.Path(args.src).read_text())

    suffix = "@".join(
        package["flakeref"]
        .replace("/", "@")
        .replace(":", "@")
        .split("@")[::-1]
    )
    pname = package["attrpath"]

    _err = []
    for denylist in ["", "meta", "...flakeref", "...err"]:
        if denylist in meta["outputsToInstall"]:
            _err.append(denylist)
    if package["disabled"]:
        _err.append("package.disabled")
    if meta["broken"]:
        _err.append("meta.broken")
    if meta["insecure"]:
        _err.append("meta.insecure")
    if meta["unfree"]:
        _err.append("meta.unfree")

    if len(_err) > 0:
        _err_payload = {
            "": package,
            "meta": meta,
            "...err": _err,
        }
        pathlib.Path(args.target).write_text(
            json.dumps(
                _err_payload,
                ensure_ascii=False,
                separators=(",", ":"),
                sort_keys=True,
            )
        )
        for out in meta["outputsToInstall"]:
            symlink_name = f"{out}@{pname}@{suffix}"
            _symlink = pathlib.Path("../target/gcroots", symlink_name)
            _symlink.unlink(missing_ok=True)
        sys.stderr.write(f"{_err_payload}\n")
        return
    else:
        # --no-eval-cache
        outputs_to_install = {
            o: subprocess.run(
                [
                    *shlex.split(
                        "nix --extra-experimental-features 'nix-command flakes' eval --raw"
                    ),
                    args.expr + f".{o}",
                ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                encoding="utf8",
            )
            for o in meta["outputsToInstall"]
        }
        if any(o for o in outputs_to_install.values() if o.returncode != 0):
            _err_payload = {
                "": package,
                "...err": {
                    k: o.stderr
                    for k, o in outputs_to_install.items()
                    if o.returncode != 0
                },
                "...flakeref": meta,
                "meta": meta,
            }
            pathlib.Path(args.target).write_text(
                json.dumps(
                    _err_payload,
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
            )
            for out in meta["outputsToInstall"]:
                symlink_name = f"{out}@{pname}@{suffix}"
                _symlink = pathlib.Path("../target/gcroots", symlink_name)
                _symlink.unlink(missing_ok=True)
            sys.stderr.write(f"{_err_payload}\n")
            return
        else:
            gcroots = {out: path.stdout for out, path in outputs_to_install.items()}
            _ok_payload = {
                "": package,
                "...flakeref": args.expr,
                "meta": meta,
                **gcroots,
            }
            pathlib.Path(args.target).write_text(
                json.dumps(
                    _ok_payload,
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
            )
            for out, path in gcroots.items():
                symlink_name = f"{out}@{pname}@{suffix}"
                _symlink = pathlib.Path("../target/gcroots", symlink_name)
                _symlink.unlink(missing_ok=True)
                _symlink.symlink_to(path)


if __name__ == "__main__":
    main()
