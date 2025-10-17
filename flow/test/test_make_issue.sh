#!/usr/bin/env bash
# make issue smoketest
set -ue -o pipefail

# Pick a design that builds quickly and has
# has some interesting "make issue" features to test,
# such as ADDITIONAL_FILES

TARGET=3_2_place_iop
ISSUE_TARGET=io_placement

make DESIGN_CONFIG=designs/asap7/gcd/config.mk $TARGET
make ISSUE_TAG=tag DESIGN_CONFIG=designs/asap7/gcd/config.mk ${ISSUE_TARGET}_issue
# io placement needs ADDITIONAL_FILES to work, so not a random test
test_archive=${ISSUE_TARGET}_tag.tar.gz
ls -l $test_archive
echo "Testing $test_archive"
runme=$(realpath run-me-gcd-asap7-base.sh)
. ../env.sh
rm -rf results/make-issue/
mkdir -p results/make-issue/
cd results/make-issue/
tar --strip-components=1 -xzf ../../$test_archive
sed -i 's/openroad -no_init/openroad -exit -no_init/g' $runme
$runme
# check for basic syntax errors
openroad -exit -no_init vars-gcd-asap7-base.tcl
