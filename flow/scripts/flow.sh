#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$RESULTS_DIR" "$LOG_DIR" "$REPORTS_DIR" "$OBJECTS_DIR"

# The rest of the flow runs logged commands through RUN_CMD; do the same
# here so an override reaches the stage logs too. Unset -- a plain `make`
# -- keeps exactly the command this script used to spell out inline.
RUN_CMD="${RUN_CMD:-$PYTHON_EXE $SCRIPTS_DIR/run_command.py}"

echo "Running $2.tcl, stage $1"

# A failure checkpoint left by an earlier run of this step is stale.
rm -f "$RESULTS_DIR/$1-failed.odb" "$RESULTS_DIR/$1-failed.sdc"

(
  trap 'mv "$LOG_DIR/$1.tmp.log" "$LOG_DIR/$1.log"' EXIT
  export STEP_NAME="$1"
  export STEP_TCL="$SCRIPTS_DIR/$2.tcl"

  eval "$OPENROAD_EXE $OPENROAD_ARGS -exit \"$SCRIPTS_DIR/noop.tcl\"" \
    >"$LOG_DIR/$1.tmp.log" 2>&1

  # OPENROAD_CMD is a command line, quotes included: a wrapper in
  # OPENROAD_EXE can have a quoted argument of its own, as in
  # gdb -ex 'thread apply all bt' --args openroad. The shell parses it,
  # as it does in a make recipe; plain word splitting would hand the
  # wrapper the quotes and the pieces.
  log="$(realpath "$LOG_DIR/$1.tmp.log")"
  eval "$RUN_CMD --log \"\$log\" --append --tee -- $OPENROAD_CMD" \
    '-no_splash "$SCRIPTS_DIR/run_step.tcl" -metrics "$LOG_DIR/$1.json"'
)

# Log the hash for this step. The summary "make elapsed" in "make finish",
# will not have all the .odb files for the bazel-orfs use-case.
"$PYTHON_EXE" "$UTILS_DIR/genElapsedTime.py" --match "$1" -d "$LOG_DIR" \
  | tee -a "$(realpath "$LOG_DIR/$1.log")"
