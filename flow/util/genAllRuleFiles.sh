#!/usr/bin/env bash

cd "$(dirname $(readlink -f $0))/../"

for variant in base hier_rtlmp
do
    for f in $(find . -name "rules-${variant}.json")
    do
        dir="$(dirname $f)"
        echo "${dir/.\/designs\//}"
        ./util/genRuleFile.py "$dir" "$variant"
        echo
    done
done
