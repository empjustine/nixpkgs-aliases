#!/bin/sh

set -x

bin-override/flakerefs-attrpaths-build.sh "$(bin-override/flake.lock-flakeref.sh github:NixOS/nixpkgs/nixos-23.05)#ninja"

nix --extra-experimental-features 'nix-command flakes' flake update "path:."

./20_generate_metas.py | bin/ninja@ninja\^out -f /dev/stdin
find gcroots -xtype l -print -delete
./40_generate_gcroots.py | bin/ninja@ninja\^out -f /dev/stdin
./60_generate_gcroots_contents.py | bin/ninja@ninja\^out -f /dev/stdin
./80_generate_bin.py

# git add bin flake.lock gcroots legacyPackages.x86_64-linux legacyPackages.x86_64-linux.broken legacyPackages.x86_64-linux.meta
