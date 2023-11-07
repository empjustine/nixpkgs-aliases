#!/bin/sh

# `flake.lock` + `input` -> flakeref URL-like syntax

# @see `flake.lock` https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flake.lock#lock-files
# @see `input` https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=inputs#flake-inputs
# @see flakeref URL-like syntax https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakeref#url-like-syntax

_FLAKE_LOCK_FILTER='.nodes | to_entries[] | select(.value.locked.type == "github") | { "input": .key, "original-flakeref": (.value.original | .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end ), "locked-flakeref": (.value.locked | .type + ":" + .owner + "/" + .repo + "/" + .rev ) }'
_FLAKE_LOCK_INPUT_FILTER='select(.input == ($k))["locked-flakeref"]'
jq -r --arg k "$1" "${_FLAKE_LOCK_FILTER} | ${_FLAKE_LOCK_INPUT_FILTER}" "${PWD}/flake.lock"
