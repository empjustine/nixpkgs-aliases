#!/bin/sh

set -ex

sqlite3 ':memory:' 'SELECT sqlite_version();'

sqlite3 database.sqlite3 .dump >database.sql
