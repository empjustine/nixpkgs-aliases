#!/bin/sh

if [ $# -lt 1 ]; then
	echo "Usage: $0 <attrpath> [flakeref]" 2>&1
	echo "default flakeref: github:NixOS/nixpkgs/nixos-23.05" 2>&1
	exit 1
fi

jq -c -S --null-input \
	--arg attrpath "$1" \
	--arg flakeref "${2:-github:NixOS/nixpkgs/nixos-23.05}" \
	'{"attrpath":($attrpath),"comment":null,"dependency":null,"disabled":null,"flakeref":($flakeref)}' |
	tee "legacyPackages.x86_64-linux/${1}"
