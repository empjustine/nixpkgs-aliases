#!/usr/bin/env python3
import contextlib
import logging
import pathlib
import shlex


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    _subprocess_logger = logging.getLogger("subprocess")
    _subprocess_logger.level = logging.DEBUG


_GCROOTS_D = pathlib.Path("gcroots")
_BIN_D = pathlib.Path("bin")
_RBIN_D = pathlib.Path("inverted-bin")


def _ln_s(source: pathlib.Path, target: pathlib.Path):
    _subprocess_logger.debug({"$@": shlex.join(["ln", "-s", str(target), str(source)])})
    if not source.exists():
        source.symlink_to(target)


def main():
    for _folder in (_BIN_D, _RBIN_D):
        _folder.mkdir(parents=True, exist_ok=True)
        for _file in _folder.glob("*"):
            with contextlib.suppress(FileNotFoundError):
                _file.unlink()

    for _bin in sorted(_GCROOTS_D.glob("*^*/bin/*")):
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
        _ln_s(
            source=_BIN_D.joinpath(f"{_bin.name}@{_bin.parent.parent.name}"),
            target=_target,
        )
        _ln_s(
            source=_RBIN_D.joinpath(f"{_bin.parent.parent.name}@{_bin.name}"),
            target=_target,
        )


if __name__ == "__main__":
    main()
