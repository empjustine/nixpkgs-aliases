#!/bin/sh

# run <flakeref> or <flakeref>[#<attrpath>]
#
# <flakeref> only:
# "${flakeref}#apps.x86_64-linux.default" or "${flakeref}#apps.${builtins.currentSystem}.default"
# "${flakeref}#defaultApp.x86_64-linux" or "${flakeref}#defaultApp.${builtins.currentSystem}"
# "${flakeref}#packages.x86_64-linux.default" or "${flakeref}#packages.${builtins.currentSystem}.default"
# "${flakeref}#defaultPackage.x86_64-linux" or "${flakeref}#defaultPackage.${builtins.currentSystem}"
# <flakeref>[#attrpath]:
# "${flakeref}#apps.x86_64-linux.${attrpath}" or "${flakeref}#apps.${builtins.currentSystem}.${attrpath}"
# "${flakeref}#packages.x86_64-linux.${attrpath}" or "${flakeref}#packages.${builtins.currentSystem}.${attrpath}"
# "${flakeref}#legacyPackages.x86_64-linux.${attrpath}" or "${flakeref}#legacyPackages.${builtins.currentSystem}.${attrpath}"
# "<flakeref>#<attrpath>"

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix.html?highlight=attrpath#flake-output-attribute
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run

if [ $# -lt 1 ]; then
	echo "Usage: $0 <flakeref>[#<attrpath>] [args...]" 2>&1
	exit 1
fi

_flakerefs_and_attrpath="$1"
shift
nix --extra-experimental-features "nix-command flakes" run "$_flakerefs_and_attrpath" -- "$@"
