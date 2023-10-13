#!/bin/sh

set -ex

sqlite3 ':memory:' 'SELECT sqlite_version();'

rm database.sqlite3

cat database.sql | grep -Ev '^INSERT INTO' >database-sorted.sql
(
  # @see https://www.sqlite.org/pragma.html#pragma_foreign_keys
  # @see https://www.sqlite.org/pragma.html#pragma_ignore_check_constraints
  # PRAGMA ignore_check_constraints
	printf 'PRAGMA foreign_keys=OFF;\nBEGIN TRANSACTION;\n'
	cat database.sql | grep -E '^INSERT INTO' | sort -u
	printf 'COMMIT;\n'
) >>database-sorted.sql

cat database-sorted.sql | sqlite3 database.sqlite3
