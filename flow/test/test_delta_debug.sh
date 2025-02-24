#!/bin/bash
#
# deltaDebug.py integration smoke-test, run from ORFS/flow folder.
#
# Exit with error if anything is amiss, including evaluation of
# variable names such as $(false), unused variables, etc.
set -ue -o pipefail

cd "$(dirname "$0")/.."
. ../env.sh

echo "Test deltaDebug.py with a make invocation"
make DESIGN_CONFIG=designs/asap7/gcd/config.mk clean_all floorplan
openroad -exit -python ../tools/OpenROAD/etc/deltaDebug.py --persistence 2 --use_stdout --error_string "100 overflow" --base_db_path results/asap7/gcd/base/2_floorplan.odb --step "make DESIGN_CONFIG=designs/asap7/gcd/config.mk do-3_1_place_gp_skip_io"

echo "Test deltaDebug.py with a make issue"
testname=uart
make DESIGN_CONFIG=designs/asap7/$testname/config.mk place
make DESIGN_CONFIG=designs/asap7/$testname/config.mk global_place_issue
latest_file=$(ls -t global_place_${testname}_asap7_base*.tar.gz | head -n1)
echo "Testing $latest_file"
rm -rf results/delta-debug/
mkdir -p results/delta-debug/
cd results/delta-debug/
tar --strip-components=1 -xzf ../../$latest_file
sed -i 's/openroad -no_init/openroad -exit -no_init/g' run-me-$testname-asap7-base.sh
openroad -exit -python ../../../tools/OpenROAD/etc/deltaDebug.py --persistence 3 --use_stdout --error_string "100 overflow" --base_db_path results/asap7/$testname/base/3_2_place_iop.odb --step ./run-me-$testname-asap7-base.sh --multiplier 2
