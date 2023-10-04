#!/bin/sh

rm database.sqlite3

cat database.sql | grep -Ev '^INSERT INTO' >database-sorted.sql
(
  printf 'PRAGMA foreign_keys=OFF;\nBEGIN TRANSACTION;\n'
  cat database.sql | grep -E '^INSERT INTO' | sort -u
  printf 'COMMIT;\n'
) >>database-sorted.sql

cat database-sorted.sql | sqlite3 database.sqlite3