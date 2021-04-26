#!/bin/bash

set -eoux pipefail

# Setting args (and setting default values for testing)
DESIGN_NAME=${1:-gcd}
PLATFORM=${2:-nangate45}
CONFIG_MK=${3:-config.mk}
FLOW_VARIANT=${4:-base}
DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK

cd "$(dirname $(readlink -f $0))/../"

source ../setup_env.sh

if [ -z "$DESIGN_NICKNAME" ]
then
  LOG_FILE=./logs/$PLATFORM/$DESIGN_NAME.log
else
  LOG_FILE=./logs/$PLATFORM/$DESIGN/$DESIGN_NICKNAME.log
fi

mkdir -p ./logs/$PLATFORM

if [ -f "../../private_tool_scripts/util/utils.mk" ]; then
  TARGETS="finish metadata drc_calibre"
else
  TARGETS="finish metadata"
fi

make DESIGN_CONFIG=$DESIGN_CONFIG FLOW_VARIANT=$FLOW_VARIANT clean_all clean_metadata 2>&1 | tee $LOG_FILE

# turn off abort on error so we can always capture the result
set +e

make DESIGN_CONFIG=$DESIGN_CONFIG FLOW_VARIANT=$FLOW_VARIANT $TARGETS 2>&1 | tee -a $LOG_FILE

# Save the return code to return as the overall status after we package
# the results
ret=$?
set -e

if [ ! -z ${MAKE_ISSUE+x} ]; then
  make DESIGN_CONFIG=$DESIGN_CONFIG FLOW_VARIANT=$FLOW_VARIANT final_report_issue 2>&1 | tee -a $LOG_FILE
fi

exit $ret
