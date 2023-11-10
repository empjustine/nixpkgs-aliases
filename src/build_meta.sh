#!/bin/sh

set -e

if [ $# -ne 3 ]; then
	printf "expecting 3 arguments, got %s: %s\n" "$#" "$*" 1>&2
	exit 4
fi

_expr="$1"
_src="$2"
_target="$2"

if [ ../flake.lock -nt "$_target" ] && [ "$_src" -nt "$_target" ]; then
  nix --extra-experimental-features 'nix-command flakes' eval --json "$_expr" | jq --slurpfile _src "$_src" '{"meta": ., "": "": ($_f[0]) }' | tee "$_target"


fi