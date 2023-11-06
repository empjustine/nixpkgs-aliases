#!/bin/sh

# run flakerefs or flakerefs[#attrpath]

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix.html?highlight=attrpath#flake-output-attribute
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run

if [ $# -lt 1 ]; then
	echo "Usage: $0 <flakerefs[#attrpath]> [args...]" 2>&1
	exit 1
fi

_flakerefs_and_attrpath="$1"
shift
nix --extra-experimental-features "nix-command flakes" run "$_flakerefs_and_attrpath" -- "$@"
