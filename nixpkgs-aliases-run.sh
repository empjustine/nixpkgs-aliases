#!/bin/sh

exec nix --extra-experimental-features "nix-command flakes" run "github:empjustine/nixpkgs-aliases/nixos-23.05#$(basename "$0")" -- "$@"
exit 127
