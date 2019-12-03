#!/bin/bash

# TODO: Currently the scripts
DESIGN=${1:-gcd}
PLATFORM=${2:-nangate45}

# TODO: Currently assumes this script must be called from the flowdir
TEST_DIR=${TEST_DIR:-test}

if [ -z "$DESIGN_NAME" ]
then
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN.log
else
  LOG_FILE=$TEST_DIR/logs/$PLATFORM/$DESIGN\_$DESIGN_NAME.log
  GOLD_LOG_FILE=$TEST_DIR/gold_logs/$PLATFORM/$DESIGN\_$DESIGN_NAME.log
fi


set -o pipefail

mkdir -p $TEST_DIR/logs/$PLATFORM

make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$DESIGN\_$PLATFORM.mk clean_all
make -C $TEST_DIR/.. DESIGN_CONFIG=./designs/$DESIGN\_$PLATFORM.mk 2>&1 | tee $LOG_FILE


#diff $LOG_FILE $GOLD_LOG_FILE
