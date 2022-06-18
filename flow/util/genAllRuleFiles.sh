#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "usage: $0 <ARGS>"
    echo "<ARGS> will be given to genRuleFile.py"
    exit 1
fi

cd "$(dirname $(readlink -f $0))/../"

for variant in base hier_rtlmp
do
    for f in $(find . -name "rules-${variant}.json")
    do
        dir="$(dirname $f)"
        echo "${dir/.\/designs\//} $variant"
        ./util/genRuleFile.py "$dir" --variant "$variant" "$@"
        echo
    done
done
