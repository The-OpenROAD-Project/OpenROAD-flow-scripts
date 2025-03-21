#!/bin/bash
set -u -eo pipefail
source "$(dirname $0)/defaults.sh"
# if failed, exit
if [ "${ORFS_DEFAULTS_LOADED:-}" = "" ]; then
  exit 1
fi

mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR

export YOSYS_FLAGS="${YOSYS_FLAGS:-} -v 3"

eval "$TIME_CMD $YOSYS_EXE $YOSYS_FLAGS -c $1" 2>&1 | tee $(realpath $2)
