#!/bin/sh

# make sure specific flakerefs[#attrpath] are in the nix store

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-metadata

for _flakerefs in "$@"; do
	nix --extra-experimental-features 'nix-command flakes' build --show-trace --no-link "$_flakerefs" &
done
wait
