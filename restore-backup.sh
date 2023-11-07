#!/bin/sh

set -e

./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqlite-interactive"
./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqldiff"

sqlite3 ':memory:' 'SELECT sqlite_version();' >/dev/null

{
	sqlite3 database.sqlite3 '.schema --indent'
	sqlite3 database.sqlite3 '.dump --data-only' | sort -u
} >database-asis.sql

(
	grep <database.sql -Ev '^INSERT INTO'
	cat database.sql | grep -E '^INSERT INTO ' | sort -u
) >database-tobe.sql

comm -3 database-asis.sql database-tobe.sql
