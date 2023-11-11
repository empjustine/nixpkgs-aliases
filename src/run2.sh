#!/bin/sh

set -x
find .. -xtype l -print -delete

./flake.lock-flakerefs.jq -c ../flake.lock >../target/flakerefs.json

mkdir -p -- ../target/meta

find package ../target/meta -type f -size 0 -print -delete

./json.d-to-ndjson.py package >../target/package.ndjson

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
  "dst": ( .filename | gsub("package/"; "../target/meta/") ),
  "package": .,
}
' ../target/flakerefs.json ../target/package.ndjson >../target/jobs.package.ndjson

mkdir -p -- ../target/gcroots ../target/meta

# warm cache
jq -r 'values[] | @sh "nix --extra-experimental-features \"nix-command flakes\" search \(.)"' ../target/flakerefs.json | /bin/sh

(
  printf 'set -x\n'
  jq -r '@sh "./build_meta.py --src=\(.src) --target=\(.dst) --expr=\(.expr) #&"' ../target/jobs.package.ndjson
  printf '\nwait\n'
) >../target/jobs.meta.package.sh

/bin/sh ../target/jobs.meta.package.sh

(
  printf 'set -x\n'
  jq -r '@sh "./build_package.py --meta=\(.dst) #&"' ../target/jobs.package.ndjson
  printf '\nwait\n'
) >../target/jobs.build.package.sh

/bin/sh ../target/jobs.build.package.sh

./80_generate_bin.py
