#!/usr/bin/env python3
import json
import pathlib


def main():
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

    nix_store_outputs = set()

    print("pool build_nix_pool")
    print("    depth = 6")
    print("rule build_nix")
    print(
        "    command = nix --extra-experimental-features 'nix-command flakes' build --show-trace --no-link $expr"
    )
    print("    pool = build_nix_pool")

    for fn, p in packages.items():
        if pathlib.Path("legacyPackages.x86_64-linux.broken", fn).exists():
            continue
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
            gcroots = pathlib.Path(f"gcroots/{fn}^{output}")
            if not gcroots.exists():
                continue
            try:
                nix_store = pathlib.Path(f"gcroots/{fn}^{output}").readlink()
            except:
                continue
            if nix_store not in nix_store_outputs:
                print(
                    f"build {nix_store}: build_nix gcroots/{fn}^{output} legacyPackages.x86_64-linux.meta/{fn} legacyPackages.x86_64-linux/{fn} flake.lock"
                )
                print(f"    expr = {flakeref}#legacyPackages.x86_64-linux.{attrpath}")
                nix_store_outputs.add(nix_store)


if __name__ == "__main__":
    main()
