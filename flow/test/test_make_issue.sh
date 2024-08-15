#!/bin/bash
# make issue smoketest
set -ue -o pipefail

testname=Element

make DESIGN_CONFIG=designs/asap7/mock-array/$testname/config.mk floorplan
make ISSUE_TAG=tag DESIGN_CONFIG=designs/asap7/mock-array/$testname/config.mk io_placement_random_issue
test_archive=io_placement_random_tag.tar.gz
ls -l $test_archive
echo "Testing $test_archive"
. ../env.sh
rm -rf results/make-issue/
mkdir -p results/make-issue/
cd results/make-issue/
tar --strip-components=1 -xzf ../../$test_archive
runme=run-me-mock-array_$testname-asap7-base.sh
sed -i 's/openroad -no_init/openroad -exit -no_init/g' $runme
./$runme
