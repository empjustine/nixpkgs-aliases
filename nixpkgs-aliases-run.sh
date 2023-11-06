#!/bin/sh

_bin="$(basename "$0")"
_gcroots="${XDG_DATA_HOME:-$HOME/.local/share}/nixpkgs-aliases/gcroots"
_matches="$(find -L "$_gcroots" -path "${_gcroots}/*^*/bin/*" -name "$_bin" | head -1)"

if [ "$_matches" != "" ]; then
	exec "$_matches" "$@"
fi

exec nix --extra-experimental-features "nix-command flakes" run "github:empjustine/nixpkgs-aliases/nixos-23.05#$(basename "$0")" -- "$@"
exit 127
