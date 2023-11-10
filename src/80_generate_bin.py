#!/usr/bin/env python3
import logging
import pathlib
import shlex
import subprocess

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def main():
    subprocess.run(shlex.split("mkdir -p ../target/bin"))
    subprocess.run(shlex.split("find ../target/bin -delete"))
    subprocess.run(shlex.split("mkdir -p ../target/bin"))

    for _bin in sorted(pathlib.Path("../target/gcroots").glob("*/bin/*")):
        if _bin.is_dir():
            continue
        if not _bin.stat().st_mode & 0o111:
            continue

        _name = _bin.name
        if _name.startswith(".") and _name.endswith("-wrapped"):
            continue
        if _name.startswith(".") and _name.endswith("-wrapped_"):
            continue
        if _name.startswith("Microsoft.") and _name.endswith(".dll"):
            continue
        if _name.startswith("System.") and _name.endswith(".dll"):
            continue

        # TODO: 🍱 U+1F371 Bento Box
        # TODO: 🧰 U+1F9F0 Toolbox
        # TODO: 📦 U+1F4E6 Package
        # TODO: 📤 U+1F4E4 Outbox Tray
        # TODO: 📥 U+1F4E5 Inbox Tray

        pname = _bin.parent.parent.name
        pathlib.Path(f"../target/bin/{_name}@{pname}").unlink(missing_ok=True)
        subprocess.run(
            [
                "ln",
                "-s",
                "--",
                f"../gcroots/{pname}/bin/{_name}",
                f"../target/bin/{_name}@{pname}",
            ]
        )


if __name__ == "__main__":
    main()
