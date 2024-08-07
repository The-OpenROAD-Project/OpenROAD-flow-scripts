#!/bin/bash
#
# Run a smoketest with two builds and check for identical results
set -ue -o pipefail

cd "$(dirname "$0")/.."
. ../env.sh

make FLOW_VARIANT=a
# Pile on as many options as possible that should not affect the result
make SKIP_REPORT_TIMING=1 FLOW_VARIANT=b
diff -r results/nangate45/gcd/a/ results/nangate45/gcd/b/
