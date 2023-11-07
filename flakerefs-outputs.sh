#!/bin/sh

# list all outputs from flakerefs[#attrpath]

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-metadata
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix.html#derivation-output-selection

for _flakerefs_and_attrpath in "$@"; do
	nix --extra-experimental-features 'nix-command flakes' eval --json "$_flakerefs_and_attrpath" | jq -c --arg r "$_flakerefs_and_attrpath" '{ "flakerefs": ($r), "": . }'
	nix --extra-experimental-features 'nix-command flakes' eval --json "${_flakerefs_and_attrpath}.meta.outputsToInstall" | jq -c --arg r "$_flakerefs_and_attrpath" '{ "flakerefs": ($r), "meta.outputsToInstall": . }'

	_outputs="$(nix --extra-experimental-features 'nix-command flakes' eval --json "${_flakerefs_and_attrpath}.outputs")"
	printf '%s' "$_outputs" | jq -c --arg r "$_flakerefs_and_attrpath" '{ "flakerefs": ($r), "outputs": . }' &
	# shellcheck disable=SC2066
	for _base64_output in "$(printf '%s' "$_outputs" | jq -r '.[] | @base64')"; do
		_output="$(printf '%s' "$_base64_output" | base64 -d)"
		nix --extra-experimental-features 'nix-command flakes' eval --json "${_flakerefs_and_attrpath}.${_output}" | jq -c --arg r "$_flakerefs_and_attrpath" --arg o "$_output" '{ "flakerefs": ($r), ($o): . }'
	done
done
