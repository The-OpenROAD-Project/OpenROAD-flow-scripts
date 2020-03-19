#!/bin/bash -ex

# Setting args (and setting default values for testing)
DESIGN_CONFIG=${1:-gcd}
PLATFORM=${2:-nangate45}

# TODO: Currently assumes this script must be called from the flowdir.
TEST_DIR=${TEST_DIR:-test}

if [ -z "$DESIGN_NICKNAME" ]
then
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN_CONFIG.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN_CONFIG.log
else
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN/$DESIGN_NICKNAME.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN/$DESIGN_NICKNAME.log
fi


set -o pipefail

mkdir -p $TEST_DIR/logs/$PLATFORM

if [ -f "./private/util/utils.mk" ]; then
  TARGETS="finish metadata private_drc private_congestion private_metadata"
else
  TARGETS="finish metadata"
fi

make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_CONFIG.mk clean_all clean_metadata
make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_CONFIG.mk $TARGETS 2>&1 | tee $LOG_FILE


#diff $LOG_FILE $GOLD_LOG_FILE
