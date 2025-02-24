#!/bin/bash
# make issue smoketest
set -ue -o pipefail

# Pick a design that builds quickly and has
# has some interesting "make issue" features to test,
# such as ADDITIONAL_FILES

make DESIGN_CONFIG=designs/asap7/mock-array/Element/config.mk floorplan
make ISSUE_TAG=tag DESIGN_CONFIG=designs/asap7/mock-array/Element/config.mk io_placement_random_issue
# io placement needs ADDITIONAL_FILES to work, so not a random test
test_archive=io_placement_random_tag.tar.gz
ls -l $test_archive
echo "Testing $test_archive"
. ../env.sh
rm -rf results/make-issue/
mkdir -p results/make-issue/
cd results/make-issue/
tar --strip-components=1 -xzf ../../$test_archive
runme=run-me-mock-array_Element-asap7-base.sh
sed -i 's/openroad -no_init/openroad -exit -no_init/g' $runme
./$runme
# check for basic syntax errors
openroad -exit -no_init vars-mock-array_Element-asap7-base.tcl
