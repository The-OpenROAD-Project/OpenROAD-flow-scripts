#!/usr/bin/env bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR
echo Running $2.tcl, stage $1
(trap 'mv $LOG_DIR/$1.tmp.log $LOG_DIR/$1.log' EXIT; \
 $OPENROAD_EXE $OPENROAD_ARGS -exit $SCRIPTS_DIR/noop.tcl 2>&1 >$LOG_DIR/$1.tmp.log; \
 eval "$TIME_CMD $OPENROAD_CMD -no_splash $SCRIPTS_DIR/$2.tcl -metrics $LOG_DIR/$1.json" 2>&1 | \
 tee -a $(realpath $LOG_DIR/$1.tmp.log))
# Log the hash for this step. The summary "make elapsed" in "make finish",
# will not have all the .odb files for the bazel-orfs use-case.
$PYTHON_EXE $UTILS_DIR/genElapsedTime.py --match $1 -d $LOG_DIR | tee -a $(realpath $LOG_DIR/$1.log)
