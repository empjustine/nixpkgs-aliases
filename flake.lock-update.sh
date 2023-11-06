#!/bin/sh

# update the current folder flake.lock

# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html?highlight=flake.lock#lock-files
# @see https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-update

nix --extra-experimental-features 'nix-command flakes' flake update path:.
