#!/bin/sh

set -ex

sqlite3 ':memory:' 'SELECT sqlite_version();'

rm database.sqlite3

(
	# @see https://www.sqlite.org/pragma.html#pragma_foreign_keys
	# @see https://www.sqlite.org/pragma.html#pragma_ignore_check_constraints
	grep <database.sql -Ev '^INSERT INTO'
	printf '%s\n' 'PRAGMA foreign_keys=0;'
	printf '%s\n' 'PRAGMA ignore_check_constraints=1;'
	printf '%s\n' 'BEGIN TRANSACTION;'
	cat database.sql | grep -E '^INSERT INTO' | sort -u
	printf '%s\n' 'COMMIT;'
) >database-sorted.sql

cat database-sorted.sql | sqlite3 database.sqlite3
