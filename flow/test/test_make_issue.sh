#!/bin/bash
# make issue smoketest
set -ue -o pipefail

testname=Element

make DESIGN_CONFIG=designs/asap7/mock-array/$testname/config.mk floorplan
make DESIGN_CONFIG=designs/asap7/mock-array/$testname/config.mk io_placement_random_issue
latest_file=$(ls -t io_placement_random_mock-array_${testname}_asap7_base*.tar.gz | head -n1)
echo "Testing $latest_file"
. ../env.sh
rm -rf results/make-issue/
mkdir -p results/make-issue/
cd results/make-issue/
tar --strip-components=1 -xzf ../../$latest_file
runme=run-me-mock-array_$testname-asap7-base.sh
sed -i 's/openroad -no_init/openroad -exit -no_init/g' $runme
./$runme
