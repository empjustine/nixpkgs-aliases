#!/bin/sh

# list all inputs in current folder flake.lock as flakerefs

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flake.lock#lock-files
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flakerefs#flake-references

_FLAKE_LOCK_FILTER='.nodes | to_entries[] | select(.value.locked.type == "github") | { "input": .key, "original-flakerefs": (.value.original | .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end ), "locked-flakerefs": (.value.locked | .type + ":" + .owner + "/" + .repo + "/" + .rev ) }'
jq -c "$_FLAKE_LOCK_FILTER" "${PWD}/flake.lock"
