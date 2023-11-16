#!/bin/sh

set -x

mkdir -p ../target

jq -S '
  def url_like_syntax_from_original: .type + ":" + .owner + "/" + .repo + if .ref then "/" + .ref else "" end;
  def url_like_syntax_from_locked: .type + ":" + .owner + "/" + .repo + "/" + .rev;

  [
    .nodes | to_entries[] | select(.value | keys == ["locked", "original"]) |
    {
      "input": .key,
      "original": (.value.original | url_like_syntax_from_original),
      "locked": (.value.locked | url_like_syntax_from_locked)
    }
  ]
' ../flake.lock | tee ../target/flakerefs.json

(
	printf 'set -x\n'
	jq -r '.[] | @sh "nix --extra-experimental-features \"nix-command flakes\" search --json \(.locked) >../target/\(.input).json "' ../target/flakerefs.json
) | tee ../target/flakerefs.search.sh

sh ../target/flakerefs.search.sh
