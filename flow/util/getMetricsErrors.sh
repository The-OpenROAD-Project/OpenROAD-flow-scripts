#!/bin/bash

set -uo pipefail

cd "$(dirname $(readlink -f $0))/../"

files=($(find . -name metadata-check.log))
numErrors=0

for f in ${files[@]}
do
  errors=$(grep '^\[ERROR]' ${f})
  echo "$f"
  if [[ ! -z $errors ]]; then
    ((numErrors += 1))
    echo "$errors"
    echo
  else
    echo "No errors"
    echo
  fi
done

echo "Found ${numErrors} while parsing ${#files[@]} files"
