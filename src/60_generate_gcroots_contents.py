#!/usr/bin/env python3
import json
import logging
import pathlib

_excluded = logging.getLogger("excluded")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)


def main():
    flakerefs = {
        "{type}:{owner}/{repo}/{ref}".format(
            **v["original"]
        ): "{type}:{owner}/{repo}/{rev}".format(**v["locked"])
        for k, v in json.loads(pathlib.Path("../flake.lock").read_text())[
            "nodes"
        ].items()
        if "original" in v and "locked" in v
    }

    packages = {
        p.name: json.loads(p.read_text())
        for p in pathlib.Path("../legacyPackages.x86_64-linux").glob("*")
    }

    nix_store_outputs = set()

    print("pool build_nix_pool")
    print("    depth = 6")
    print("rule build_nix")
    print(
        "    command = nix --extra-experimental-features 'nix-command flakes' build --show-trace --no-link $expr"
    )
    print("    pool = build_nix_pool")

    for fn, p in packages.items():
        if pathlib.Path("../legacyPackages.x86_64-linux.broken", fn).exists():
            _excluded.debug(f".broken: {fn}")
            continue
        try:
            m = json.loads(
                pathlib.Path("../legacyPackages.x86_64-linux.meta", fn).read_text()
            )
        except:
            _excluded.debug(f"!.meta: {fn}")
            continue

        if p["disabled"]:
            _excluded.debug(f".pdisabled: {fn}")
            continue
        if m["broken"]:
            _excluded.debug(f".mbroken: {fn}")
            continue
        if m["insecure"]:
            _excluded.debug(f".minsecure: {fn}")
            continue
        if m["unfree"]:
            _excluded.debug(f".munfree: {fn}")
            continue

        flakeref = flakerefs.get(p["flakeref"], p["flakeref"])
        attrpath = p["attrpath"]

        for output in m["outputsToInstall"]:
            gcroots = pathlib.Path(f"gcroots/{fn}^{output}")
            if not gcroots.exists(follow_symlinks=False):
                _excluded.debug(f".gcroots: {fn}")
                continue
            try:
                nix_store = pathlib.Path(f"gcroots/{fn}^{output}").readlink()
            except:
                _excluded.debug(f"readlink: {fn}")
                continue
            if nix_store not in nix_store_outputs:
                print(
                    f"build {nix_store}: build_nix legacyPackages.x86_64-linux.meta/{fn} legacyPackages.x86_64-linux/{fn} flake.lock"
                )
                print(f"    expr = {flakeref}#legacyPackages.x86_64-linux.{attrpath}")
                nix_store_outputs.add(nix_store)
            else:
                _excluded.debug(f"nix_store_outputs dup: {fn}")


if __name__ == "__main__":
    main()
