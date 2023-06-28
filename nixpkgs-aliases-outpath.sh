#!/bin/sh
for _nixpkg in "$@"; do
	nix --extra-experimental-features 'nix-command flakes' eval --json "github:empjustine/nixpkgs-aliases/nixos-23.05#${_nixpkg}.outPath" | jq -r
done
