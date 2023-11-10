#!/bin/sh

set -x
find .. -xtype l -print -delete

./flake.lock-flakerefs.jq -c ../flake.lock >../target/flakerefs.json

mkdir -p -- ../target/meta

find legacyPackages.x86_64-linux ../target/meta -type f -size 0 -print -delete

./json.d-to-ndjson.py legacyPackages.x86_64-linux >../target/legacyPackages.x86_64-linux.ndjson

jq -s -c '
.[0] as $flakerefs
|
.[1:][]
|
{
  "expr": (
    .content
    |
    (
      ( $flakerefs[.flakeref] // .flakeref )
      + "#"
      + .attrpath
    )
  ),
  "src": .filename,
  "dst": ( .filename | gsub("legacyPackages.x86_64-linux"; "../target/meta") ),
  "package": .,
}
' ../target/flakerefs.json ../target/legacyPackages.x86_64-linux.ndjson >../target/jobs.package.ndjson

mkdir -p -- ../target/gcroots ../target/meta

(
  printf 'set -x\n'
  jq -r '@sh "./build_meta.py --src=\(.src) --target=\(.dst) --expr=\(.expr) &"' ../target/jobs.package.ndjson
  printf '\nwait\n'
) >../target/jobs.meta.package.sh

/bin/sh ../target/jobs.meta.package.sh

(
  printf 'set -x\n'
  jq -r '@sh "./build_package.py --src=\(.src) --target=\(.dst) --expr=\(.expr)"' ../target/jobs.package.ndjson
  printf '\nwait\n'
) >../target/jobs.build.package.sh

/bin/sh ../target/jobs.build.package.sh

./80_generate_bin.py