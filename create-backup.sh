#!/bin/sh

set -ex

./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqlite-interactive"

sqlite3 ':memory:' 'SELECT sqlite_version();'

{
	sqlite3 database.sqlite3 '.schema --indent'
	sqlite3 database.sqlite3 '.dump --data-only' | sort -u
} >database.sql
