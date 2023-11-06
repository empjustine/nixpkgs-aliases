#!/bin/sh

find -L . -maxdepth 4 -path './gcroots/*^*/bin' ! -name '.*-wrapped'
find -L . -path './gcroots/*^*/share/man/*' -type f
find -L . -path './gcroots/*^*/share/doc/*' -type f
find -L . -path './gcroots/*^*/share/bash-completion/*' -type f
