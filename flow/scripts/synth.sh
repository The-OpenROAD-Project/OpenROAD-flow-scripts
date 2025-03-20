#!/bin/bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR

export YOSYS_FLAGS="${YOSYS_FLAGS:-} -v 3"

eval "$TIME_CMD $YOSYS_EXE $YOSYS_FLAGS -c $1" 2>&1 | tee $(realpath $2)
