#!/bin/sh

if [ $# != 3 ]; then
	printf "%s: expecting 3 arguments, got %s\n" "$0" "$#" 1>&2
	printf "%s\n" "$@" 1>&2
	exit 4
fi

_expr="$1"
_out="$2"
_broken="$3"

_target="$(nix --extra-experimental-features 'nix-command flakes' eval --raw "$_expr" 2>"$_broken")"
if [ "$_target" = "" ]; then
	rm -- "$_out"
	cat -- "$_broken" 1>&2
else
	rm -- "$_out" "$_broken"
	ln -s "$_target" "$_out"
fi

exit 0
