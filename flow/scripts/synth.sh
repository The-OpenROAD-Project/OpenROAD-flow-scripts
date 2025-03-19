#!/bin/bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR
(env time -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.' \
 $YOSYS_EXE $YOSYS_FLAGS -c $1) 2>&1 | tee $(realpath $2)
