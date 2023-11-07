#!/bin/sh

# list all `input`s in `flake.lock` in flakeref URL-like syntax

# @see `input`s https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=inputs#flake-inputs
# @see `flake.lock` https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flake.lock#lock-files
# @see flakeref URL-like syntax https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakeref#url-like-syntax

_FLAKE_LOCK_FILTER='.nodes | to_entries[] | select(.value.locked.type == "github") | { "input": .key, "original-flakeref": (.value.original | .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end ), "locked-flakeref": (.value.locked | .type + ":" + .owner + "/" + .repo + "/" + .rev ) }'
jq -c "$_FLAKE_LOCK_FILTER" "${PWD}/flake.lock"
