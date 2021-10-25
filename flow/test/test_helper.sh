#!/bin/bash

set -eoux pipefail

cd "$(dirname $(readlink -f $0))/../"

# Setting args (and setting default values for testing)
DESIGN_NAME=${1:-gcd}
PLATFORM=${2:-nangate45}
CONFIG_MK=${3:-config.mk}
FLOW_VARIANT=${4:-base}
DESIGN_CONFIG=./designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK
LOG_FILE=./logs/$PLATFORM/$DESIGN_NAME.log
mkdir -p ./logs/$PLATFORM
__make="make DESIGN_CONFIG=$DESIGN_CONFIG FLOW_VARIANT=$FLOW_VARIANT"

source ../setup_env.sh

$__make clean_all clean_metadata 2>&1 | tee $LOG_FILE

# turn off abort on error so we can always capture the result
set +e

$__make finish metadata 2>&1 | tee -a $LOG_FILE

# Save the return code to return as the overall status after we package
# the results
ret=$?
set -e

if [ ! -z ${MAKE_ISSUE+x} ]; then
  $__make final_report_issue 2>&1 | tee -a $LOG_FILE
fi

if [ -z "${PRIVATE_DIR+x}" ]; then
  PRIVATE_DIR="../../private_tool_scripts"
fi

if [ -f "$PRIVATE_DIR/util/utils.mk" ]; then
  $__make calibre_drc
fi

exit $ret
