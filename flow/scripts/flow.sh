#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$RESULTS_DIR" "$LOG_DIR" "$REPORTS_DIR" "$OBJECTS_DIR"

echo "Running $2.tcl, stage $1"

(
  trap 'mv "$LOG_DIR/$1.tmp.log" "$LOG_DIR/$1.log"' EXIT

  eval "$OPENROAD_EXE $OPENROAD_ARGS -exit \"$SCRIPTS_DIR/noop.tcl\"" \
    >"$LOG_DIR/$1.tmp.log" 2>&1

  $PYTHON_EXE "$SCRIPTS_DIR/run_command.py" --log "$(realpath "$LOG_DIR/$1.tmp.log")" --append --tee -- \
    $OPENROAD_CMD -no_splash "$SCRIPTS_DIR/$2.tcl" -metrics "$LOG_DIR/$1.json"
)

# Log the hash for this step. The summary "make elapsed" in "make finish",
# will not have all the .odb files for the bazel-orfs use-case.
"$PYTHON_EXE" "$UTILS_DIR/genElapsedTime.py" --match "$1" -d "$LOG_DIR" \
  | tee -a "$(realpath "$LOG_DIR/$1.log")"
