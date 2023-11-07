#!/bin/sh

for _json in "$@"; do
	(jq --compact-output --sort-keys '.' -- "$_json" || cat "$_json") | tee "$_json"
done
