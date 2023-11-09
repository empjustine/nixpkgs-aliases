#!/usr/bin/env python3
import logging
import pathlib
import shlex
import subprocess

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def main():
    subprocess.run(shlex.split("find bin -depth -print -delete"))
    subprocess.run(shlex.split("mkdir -p bin"))

    for _bin in sorted(pathlib.Path("gcroots").glob("*^*/bin/*")):
        if _bin.is_dir() or _bin.name.startswith(".") or _bin.name.endswith("-wrapped"):
            continue
        if (
            _bin.name == "git"
            or _bin.name.startswith("System.")
            or _bin.name.endswith(".dll")
            or _bin.name.endswith(".pdb")
        ):
            continue

        _target = pathlib.Path("../" + str(_bin))

        # TODO: 🍱 U+1F371 Bento Box
        # TODO: 🧰 U+1F9F0 Toolbox
        # TODO: 📦 U+1F4E6 Package
        # TODO: 📤 U+1F4E4 Outbox Tray
        # TODO: 📥 U+1F4E5 Inbox Tray

        subprocess.run(
            [
                "ln",
                "-s",
                "--",
                _target,
                pathlib.Path("bin", f"{_bin.name}@{_bin.parent.parent.name}"),
            ]
        )


if __name__ == "__main__":
    main()
