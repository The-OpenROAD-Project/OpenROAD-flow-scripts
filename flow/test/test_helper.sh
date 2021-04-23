#!/bin/bash -ex

# Setting args (and setting default values for testing)
DESIGN_NAME=${1:-gcd}
PLATFORM=${2:-nangate45}
CONFIG_MK=${3:-config.mk}

# TODO: Currently assumes this script must be called from the flowdir.
TEST_DIR=${TEST_DIR:-test}

if [ -z "$DESIGN_NICKNAME" ]
then
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN_NAME.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN_NAME.log
else
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN/$DESIGN_NICKNAME.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN/$DESIGN_NICKNAME.log
fi


set -o pipefail

mkdir -p $TEST_DIR/logs/$PLATFORM

if [ -f "../../private_tool_scripts/util/utils.mk" ]; then
  TARGETS="finish metadata drc_calibre"
else
  TARGETS="finish metadata"
fi

make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK clean_all clean_metadata

# turn off abort on error so we can always capture the result
set +e

make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK $TARGETS 2>&1 | tee $LOG_FILE

# Save the return code to return as the overall status after we package
# the results
ret=$?
set -e

if [ ! -z ${MAKE_ISSUE+x} ]; then
  make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK final_report_issue
fi

exit $ret
