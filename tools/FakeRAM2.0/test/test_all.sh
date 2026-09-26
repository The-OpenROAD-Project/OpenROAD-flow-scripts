#!/usr/bin/env bash

set -eoux pipefail

if [[ -v COVERAGE_RUN ]]; then
    rm -rf .coverage*
    cmd_preamble="coverage run --parallel-mode"
else
    cmd_preamble=""
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for test_file in $SCRIPT_DIR/*_test.py; do
    $cmd_preamble $test_file
done

if [[ -v COVERAGE_RUN ]]; then
    coverage combine
fi

