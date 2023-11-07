#!/bin/sh

# list all outputs from <flakerefs>[#attrpaths]

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-metadata
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix.html#derivation-output-selection

for _flakeref_and_attrpath in "$@"; do
	for _base64_output in "$(nix --extra-experimental-features 'nix-command flakes' eval --json "${_flakeref_and_attrpath}.meta.outputsToInstall" | jq -r '.[] | @base64')"; do
		_output="$(printf '%s' "$_base64_output" | base64 -d)"
		nix --extra-experimental-features 'nix-command flakes' eval --json "${_flakeref_and_attrpath}.${_output}" | jq -c --arg r "$_flakeref_and_attrpath" --arg o "$_output" '{ "flakeref": ($r), ($o): . }'
	done
done
