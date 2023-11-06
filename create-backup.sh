#!/bin/sh

set -ex

sqlite3 ':memory:' 'SELECT sqlite_version();'

# sqlite3 database.sqlite3 .dump >database.sql
{
	#	printf '%s\n' 'PRAGMA foreign_keys=0;'
	#	printf '%s\n' 'PRAGMA ignore_check_constraints=1;'
	sqlite3 database.sqlite3 '.schema --indent'
	printf '%s\n' 'BEGIN TRANSACTION;'
	sqlite3 database.sqlite3 '.dump --data-only' | sort -u | sed 's/INSERT INTO /INSERT OR IGNORE INTO /g' -
	printf '%s\n' 'COMMIT;'
} >database.sql
