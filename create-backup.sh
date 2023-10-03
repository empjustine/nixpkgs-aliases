#!/bin/sh

sqlite3 database.sqlite3 .dump >database.sql
