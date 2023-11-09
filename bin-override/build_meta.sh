#!/bin/sh

set -e

if [ $# -ne 2 ]; then
	printf "%s: expecting 2 arguments, got %s\n" "$0" "$#" 1>&2
	exit 4
fi

nix --extra-experimental-features 'nix-command flakes' eval --json "$1" | tee "$2"
