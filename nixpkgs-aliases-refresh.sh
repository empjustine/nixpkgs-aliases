#!/bin/sh
nix --refresh --extra-experimental-features "nix-command flakes" path-info "github:empjustine/nixpkgs-aliases/nixos-23.05#git-gui"