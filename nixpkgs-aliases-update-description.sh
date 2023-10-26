#!/bin/sh

set -xe

sqlite3 database.sqlite3 'UPDATE nixpkg SET description=NULL'
nix --extra-experimental-features 'nix-command flakes' --refresh flake show --json path:. | jq '[.packages["x86_64-linux"] | to_entries[] | { "pname": (.key), "description": (.value.description) }]' | sqlite-utils upsert database.sqlite3 nixpkg - --pk=pname