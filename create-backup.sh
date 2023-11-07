#!/bin/sh

set -ex

./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqlite-interactive"
sqlite3 ':memory:' 'SELECT sqlite_version();'

# sqlite3 database.sqlite3 .dump >database.sql
{
	#	printf '%s\n' 'PRAGMA foreign_keys=0;'
	#	printf '%s\n' 'PRAGMA ignore_check_constraints=1;'
	sqlite3 database.sqlite3 '.schema --indent'
	printf '%s\n' 'BEGIN TRANSACTION;'
	sqlite3 database.sqlite3 '.dump --data-only' | sort -u
	printf '%s\n' 'COMMIT;'
} >database.sql
