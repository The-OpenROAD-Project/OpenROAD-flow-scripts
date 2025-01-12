#!/usr/bin/env bash
DESIGN_NAME=${1:-gcd}
PLATFORM=${2:-nangate45}

# run the commands in ORFS root dir
echo "[INFO FLW-0029] Installing dependencies in virtual environment."
cd ../
./tools/AutoTuner/installer.sh
. ./tools/AutoTuner/setup.sh

# remove dashes and capitalize platform name
PLATFORM=${PLATFORM//-/}
# convert to uppercase
PLATFORM=${PLATFORM^^}

echo "Running Autotuner smoke tune test"
python3 -m unittest tools.AutoTuner.test.smoke_test_tune.${PLATFORM}TuneSmokeTest.test_tune

echo "Running Autotuner smoke sweep test"
python3 -m unittest tools.AutoTuner.test.smoke_test_sweep.${PLATFORM}SweepSmokeTest.test_sweep

echo "Running Autotuner smoke tests for --sample and --iteration."
python3 -m unittest tools.AutoTuner.test.smoke_test_sample_iteration.${PLATFORM}SampleIterationSmokeTest.test_sample_iteration

if [ "$PLATFORM" == "asap7" ] && [ "$DESIGN_NAME" == "gcd" ]; then
  echo "Running Autotuner ref file test (only once)"
  python3 -m unittest tools.AutoTuner.test.ref_file_check.RefFileCheck.test_files

  echo "Running AutoTuner resume test (only once)"
  python3 -m unittest tools.AutoTuner.test.resume_check.ResumeCheck.test_tune_resume
fi

echo "Running Autotuner plotting smoke test"
all_experiments=$(ls -d ./flow/logs/${PLATFORM}/${DESIGN_NAME}/*/)
if [ -z "$all_experiments" ]; then
  echo "No experiments found for plotting"
  exit 0
fi
all_experiments=$(basename -a $all_experiments)
for expt in $all_experiments; do
  python3 tools/AutoTuner/src/autotuner/utils/plot.py \
    --platform ${PLATFORM} \
    --design ${DESIGN_NAME} \
    --experiment $expt
done

exit $ret
