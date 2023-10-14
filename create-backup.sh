#!/bin/sh

set -ex

sqlite3 ':memory:' 'SELECT sqlite_version();'

# sqlite3 database.sqlite3 .dump >database.sql

printf '%s\n' 'PRAGMA foreign_keys=0;' >database.sql
printf '%s\n' 'PRAGMA ignore_check_constraints=1;' >>database.sql
printf '%s\n' 'BEGIN TRANSACTION;' >>database.sql
sqlite3 database.sqlite3 '.schema --indent' >>database.sql
sqlite3 database.sqlite3 '.dump --data-only' | sort -u >>database.sql
printf '%s\n' 'COMMIT;' >>database.sql
