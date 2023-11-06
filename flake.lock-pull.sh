#!/bin/sh

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-lock
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-update

# jq --null-input -c '{"input":"nixpkgs-aliases","flakeref":"github:empjustine/nixpkgs-aliases/nixos-23.05"}'
nix --refresh --extra-experimental-features "nix-command flakes" path-info "."
