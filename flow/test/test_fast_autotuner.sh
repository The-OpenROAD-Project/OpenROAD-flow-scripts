#!/usr/bin/env bash

set -euox pipefail

# run the commands in ORFS root dir
echo "[INFO FLW-0029] Installing dependencies in virtual environment."
cd ../
./tools/AutoTuner/installer.sh
. ./tools/AutoTuner/setup.sh

echo "Running Autotuner fast smoke test"
python3 -m unittest tools.AutoTuner.test.fast_smoke_test.FastSmokeTest.test
