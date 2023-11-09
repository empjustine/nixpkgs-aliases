#!/usr/bin/env python3
import json
import logging
import pathlib

_subprocess_logger = logging.getLogger("subprocess")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    _subprocess_logger.level = logging.DEBUG


def main():
    pathlib.Path("legacyPackages.x86_64-linux.broken").mkdir(exist_ok=True)
    pathlib.Path("gcroots").mkdir(exist_ok=True)

    flakerefs = {
        "{type}:{owner}/{repo}/{ref}".format(
            **v["original"]
        ): "{type}:{owner}/{repo}/{rev}".format(**v["locked"])
        for k, v in json.loads(pathlib.Path("flake.lock").read_text())["nodes"].items()
        if "original" in v and "locked" in v
    }

    packages = {
        p.name: json.loads(p.read_text())
        for p in pathlib.Path("legacyPackages.x86_64-linux").glob("*")
    }

    print("pool build_gcroots_pool")
    print("    depth = 24")
    print("rule build_gcroots")
    print("    command = bin-override/build_gcroots.sh $expr $out $broken")
    print("    pool = build_gcroots_pool")

    for fn, p in packages.items():
        try:
            m = json.loads(
                pathlib.Path("legacyPackages.x86_64-linux.meta", fn).read_text()
            )
        except:
            continue
        if p["disabled"] or m["broken"] or m["insecure"] or m["unfree"]:
            continue

        flakeref = flakerefs.get(p["flakeref"], p["flakeref"])
        attrpath = p["attrpath"]

        for output in m["outputsToInstall"]:
            print(
                f"build gcroots/{fn}^{output}: build_gcroots legacyPackages.x86_64-linux.meta/{fn} legacyPackages.x86_64-linux/{fn} flake.lock"
            )
            print(
                f"    expr = {flakeref}#legacyPackages.x86_64-linux.{attrpath}.{output}"
            )
            print(f"    broken = legacyPackages.x86_64-linux.broken/{fn}")


if __name__ == "__main__":
    main()
