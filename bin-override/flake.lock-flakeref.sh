#!/bin/sh

# `flake.lock` + flakeref URL-like syntax -> `input`'s flakeref URL-like syntax

# @see `flake.lock` https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flake.lock#lock-files
# @see flakeref URL-like syntax https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakeref#url-like-syntax
# @see `input` https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=inputs#flake-inputs

_FLAKE_LOCK_FILTER='.nodes | to_entries[] | select(.value.locked.type == "github") | { "input": .key, "original-flakeref": (.value.original | .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end ), "locked-flakeref": (.value.locked | .type + ":" + .owner + "/" + .repo + "/" + .rev ) }'
_FLAKE_LOCK_INPUT_FILTER='select(.["original-flakeref"] == ($k))["locked-flakeref"]'
jq -r --arg k "$1" "${_FLAKE_LOCK_FILTER} | ${_FLAKE_LOCK_INPUT_FILTER}" "${PWD}/flake.lock"
