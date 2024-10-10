#!/usr/bin/env bash

set -eoux pipefail

cd "$(dirname "$(readlink -f "$0")")/../"

# Setting args (and setting default values for testing)
DESIGN_NAME=${1:-gcd}
PLATFORM=${2:-nangate45}
CONFIG_MK=${3:-config.mk}
if [ $# -eq 4 ]; then
  FLOW_VARIANT=$4
fi
DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK
LOG_FILE=./logs/$PLATFORM/$DESIGN_NAME.log
mkdir -p "./logs/$PLATFORM"

__make="make DESIGN_CONFIG=$DESIGN_CONFIG"
if [ -n "${FLOW_VARIANT+x}" ]; then
  __make+=" FLOW_VARIANT=$FLOW_VARIANT"
fi

mkdir -p "$(dirname "$LOG_FILE")"
$__make clean_all clean_metadata 2>&1 | tee "$LOG_FILE"

# turn off abort on error so we can always capture the result
set +e

$__make finish metadata 2>&1 | tee -a "$LOG_FILE"

# Save the return code to return as the overall status after we package
# the results
ret=$?

if [ -z "${PRIVATE_DIR+x}" ]; then
  PRIVATE_DIR="../../private_tool_scripts"
fi

if [ -f "$PRIVATE_DIR/openRoad/private.mk" ] && [ -n "${SAVE_TO_DB+x}" ]; then
  $__make save_to_metrics_db
  ret=$(( ret + $? ))
fi

if [ -f "$PRIVATE_DIR/util/utils.mk" ] && [ -n "${RUN_CALIBRE+x}" ]; then
  $__make calibre_drc
  ret=$(( ret + $? ))
  $__make convert_calibre
  ret=$(( ret + $? ))
  if [ -n "${SAVE_TO_DB+x}" ]; then
    $__make save_to_drc_db
    ret=$(( ret + $? ))
  fi
  if [ -n "${CHECK_DRC_DB+x}" ]; then
    $__make check_drc_db
    ret=$(( ret + $? ))
  fi
fi

# Only enabled abort on error at the end to allow script to reach make issue
set -e

if [ -n "${MAKE_ISSUE+x}" ]; then
  $__make final_report_issue 2>&1 | tee -a "$LOG_FILE"
fi

# Find make targets
set +x # These rules are noisy
TARGETS=$($__make -np | grep -e '^[^ ]*:')
if [ $ret -eq 0 ] && grep -q 'simulate:' <(echo $TARGETS); then
  echo "Start simulate"
  $__make simulate 2>&1 | tee -a "$LOG_FILE"
  ret=$(( ret + $? ))
fi
if [ $ret -eq 0 ] && grep -q 'power:' <(echo $TARGETS); then
  echo "Start power"
  $__make power 2>&1 | tee -a "$LOG_FILE"
  ret=$(( ret + $? ))
fi

# Run Autotuner CI specifically for gcd on selected platforms.
RUN_AUTOTUNER=0
case $DESIGN_NAME in
  "gcd")
    RUN_AUTOTUNER=1
    ;;
esac
case $PLATFORM in
     "asap7" | "sky130hd" | "ihp-sg13g2" )
      # Keep RUN_AUTOTUNER enabled only for these platforms
      ;;
     *)
      RUN_AUTOTUNER=0
      ;;
esac

if [ $RUN_AUTOTUNER -eq 1 ]; then
  # change directory to the root of the repo
  echo "Install and starting venv"
  cd ../
  ./tools/AutoTuner/installer.sh
  . ./tools/AutoTuner/setup.sh

  # remove dashes
  PLATFORM=${PLATFORM//-/}
  # convert to uppercase
  PLATFORM=${PLATFORM^^}

  echo "Running Autotuner smoke tune test"
  python3 -m unittest tools.AutoTuner.test.smoke_test_tune.${PLATFORM}TuneSmokeTest.test_tune

  echo "Running Autotuner smoke sweep test"
  python3 -m unittest tools.AutoTuner.test.smoke_test_sweep.${PLATFORM}SweepSmokeTest.test_sweep

  echo "Running Autotuner ref file test (only once)"
  if [ "$PLATFORM" == "asap7" ] && [ "$DESIGN" == "gcd" ]; then
    python3 -m unittest tools.AutoTuner.test.ref_file_check.RefFileCheck.test_files
  fi

  echo "Running Autotuner smoke algorithm & evaluation test"
  python3 -m unittest tools.AutoTuner.test.smoke_test_algo_eval.${PLATFORM}AlgoEvalSmokeTest.test_algo_eval
fi

exit $ret
