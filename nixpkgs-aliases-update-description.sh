#!/bin/sh

set -xe

sqlite3 database.sqlite3 'UPDATE nixpkg SET description=NULL'
nix --extra-experimental-features 'nix-command flakes' --refresh flake show --json path:. | jq -c -r '.packages["x86_64-linux"] | to_entries[] | "UPDATE nixpkg SET description=\"\(.value.description)\" WHERE pname=\"\(.key)\";"' | sqlite3 database.sqlite3
