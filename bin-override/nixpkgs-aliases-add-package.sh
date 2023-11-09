#!/bin/sh

if [ $# -lt 1 ]; then
	printf '%s\n' "Usage: [flakeref=github:NixOS/nixpkgs/nixos-23.05] $0 [<attrpath> [<attrpath> ...]]" 2>&1
fi

for _attrpath in "$@"; do
	jq -c -S --null-input \
		--arg attrpath "$_attrpath" \
		--arg flakeref "${flakeref:-github:NixOS/nixpkgs/nixos-23.05}" \
		'{"attrpath":($attrpath),"comment":null,"dependency":null,"disabled":null,"flakeref":($flakeref)}' |
		tee "legacyPackages.x86_64-linux/${_attrpath}"
done
