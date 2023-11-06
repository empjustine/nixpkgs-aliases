#!/bin/sh

# check newest version of specific flakerefs

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-metadata

for _flakerefs in "$@"; do
	nix --refresh --extra-experimental-features "nix-command flakes" flake metadata "$_flakerefs"
done
