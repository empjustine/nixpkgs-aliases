#!/bin/sh

set -e

./json.d-to-ndjson.py ../legacyPackages.x86_64-linux >../legacyPackages.x86_64-linux.ndjson
./ndjson-to-ndjson.d.py ../legacyPackages.x86_64-linux.ndjson
