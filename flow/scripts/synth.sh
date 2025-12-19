#!/usr/bin/env bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR
$YOSYS_EXE -V > $(realpath $2)
eval "$TIME_CMD $YOSYS_EXE $YOSYS_FLAGS -c $1" 2>&1 | tee --append $(realpath $2)
