#!/bin/sh

set -ex

./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqlite-interactive"
./flakerefs-build.sh "$(./flake.lock-input.sh i-23-05)#sqldiff"

sqlite3 ':memory:' 'SELECT sqlite_version();'

(
	#	@see https://www.sqlite.org/pragma.html#pragma_foreign_keys
	#	@see https://www.sqlite.org/pragma.html#pragma_ignore_check_constraints
	#	printf '%s\n' 'PRAGMA foreign_keys=0;'
	#	printf '%s\n' 'PRAGMA ignore_check_constraints=1;'
	grep <database.sql -Ev '^INSERT INTO'
	printf '%s\n' 'BEGIN TRANSACTION;'
	cat database.sql | grep -E '^INSERT (OR IGNORE )?INTO ' | sort -u | sed 's/INSERT INTO /INSERT OR IGNORE INTO /g' -
	printf '%s\n' 'COMMIT;'
) | sqlite3 database2.sqlite3

sqldiff database2.sqlite3 database.sqlite3