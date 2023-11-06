#!/bin/sh

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-lock
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-update

# jq --null-input -c '{"input":"nixpkgs-aliases","flakeref":"github:empjustine/nixpkgs-aliases/nixos-23.05"}'
jq -c '.nodes | to_entries[] | select(.value.locked.type == "github") | { "input": .key, "original-flakerefs": (.value.original | .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end ), "locked-flakerefs": (.value.locked | .type + ":" + .owner + "/" + .repo + "/" + .rev ) }' flake.lock
