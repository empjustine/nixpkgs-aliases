#!/bin/sh

set -x

bin-override/flake.lock-update.sh
./20_generate_metas.py | bin/ninja@ninja\^out -f /dev/stdin
./40_generate_gcroots.py | bin/ninja@ninja\^out -f /dev/stdin
./60_generate_gcroots_contents.py | bin/ninja@ninja\^out -f /dev/stdin
./80_generate_bin.py

# git add bin flake.lock gcroots legacyPackages.x86_64-linux legacyPackages.x86_64-linux.broken legacyPackages.x86_64-linux.meta
