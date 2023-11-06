#!/bin/sh
for _nixpkg in "$@"; do
	nix --extra-experimental-features 'nix-command flakes' build --json --no-link "github:empjustine/nixpkgs-aliases/nixos-23.05#${_nixpkg}"
done
exit 127
