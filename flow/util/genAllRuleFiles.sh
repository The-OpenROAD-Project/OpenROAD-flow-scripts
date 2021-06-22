#!/usr/bin/env bash

cd "$(dirname $(readlink -f $0))/../"

for f in $(find . -name "rules.json")
do
    dir="$(dirname $f)"
    echo "${dir/.\/designs\//}"
    ./util/genRuleFile.py "$dir"
    echo
done
