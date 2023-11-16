#!/usr/bin/env python3
import json
import pathlib


def main():
    flakerefs = {
        "{type}:{owner}/{repo}/{ref}".format(
            **v["original"],
        ): "{type}:{owner}/{repo}/{rev}".format(**v["locked"])
        for k, v in json.loads(pathlib.Path("../flake.lock").read_text())[
            "nodes"
        ].items()
        if "original" in v and "locked" in v
    }

    packages = {
        p.name: json.loads(p.read_text())
        for p in pathlib.Path("legacyPackages.x86_64-linux").glob("*")
    }

    pathlib.Path("../legacyPackages.x86_64-linux.meta").mkdir(exist_ok=True)

    print("pool build_meta_pool")
    print("    depth = 24")
    print("rule build_meta")
    print("    command = src/build_meta.sh $expr $out")
    print("    pool = build_meta_pool")

    for fn, p in packages.items():
        flakeref = flakerefs.get(p["flakeref"], p["flakeref"])
        attrpath = p["attrpath"]
        print(
            f"build legacyPackages.x86_64-linux.meta/{fn}: build_meta legacyPackages.x86_64-linux/{fn} flake.lock",
        )
        print(f"    expr = {flakeref}#{attrpath}.meta")


if __name__ == "__main__":
    main()
