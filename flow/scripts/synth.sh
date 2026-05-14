#!/usr/bin/env bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR
touch $2
$YOSYS_EXE -V > $(realpath $2)
$PYTHON_EXE "$SCRIPTS_DIR/run_command.py" --log "$(realpath $2)" --append --tee -- \
  $YOSYS_EXE $YOSYS_FLAGS -c $1

# Log result hash, mirroring flow.sh's epilogue for OpenROAD stages.
# genElapsedTime.py understands .odb/.rtlil/.v so it hashes the yosys
# output (1_2_yosys.v, 1_1_yosys_canonicalize.rtlil) automatically.
# Informational; sandbox edge-cases (no matching log, result not declared
# as a bazel action output) must not fail the synth action — but route
# stderr into the log rather than silently dropping it, so a real bug
# in the helper is still discoverable after the fact.
stage=$(basename "$2" .log)
log_file=$(realpath "$2")
"$PYTHON_EXE" "$UTILS_DIR/genElapsedTime.py" --match "$stage" -d "$LOG_DIR" \
  2>>"$log_file" \
  | tee -a "$log_file" || true
