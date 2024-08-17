#!/usr/bin/env bash

set -eoux pipefail

cd "$(dirname $(readlink -f $0))/../"

./test/test_helper.py ${1:-gcd} ${2:-nangate45} ${3:-config.mk} --make_issue