#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$RESULTS_DIR" "$LOG_DIR" "$REPORTS_DIR" "$OBJECTS_DIR"

# The rest of the flow runs logged commands through RUN_CMD; do the same
# here so an override reaches the stage logs too. Unset -- a plain `make`
# -- keeps exactly the command this script used to spell out inline.
RUN_CMD="${RUN_CMD:-$PYTHON_EXE $SCRIPTS_DIR/run_command.py}"

echo "Running $2.tcl, stage $1"

# A stale snapshot would be drawn as if this run produced it.
rm -f "$REPORTS_DIR/$1.art.json"

status=0
(
  trap 'mv "$LOG_DIR/$1.tmp.log" "$LOG_DIR/$1.log"' EXIT

  eval "$OPENROAD_EXE $OPENROAD_ARGS -exit \"$SCRIPTS_DIR/noop.tcl\"" \
    >"$LOG_DIR/$1.tmp.log" 2>&1

  # run_stage.tcl sources the stage script and snapshots the result.
  export ORFS_STAGE="$1" ORFS_STAGE_SCRIPT="$2.tcl"
  $RUN_CMD --log "$(realpath "$LOG_DIR/$1.tmp.log")" --append --tee -- \
    $OPENROAD_CMD -no_splash "$SCRIPTS_DIR/run_stage.tcl" -metrics "$LOG_DIR/$1.json"
) || status=$?

if [ "$status" -ne 0 ]; then
  # Explain the failure, then fail with the stage's own exit status.
  if [ "$SKIP_STAGE_ART" != 1 ]; then
    "$PYTHON_EXE" "$UTILS_DIR/stage_art.py" --stage "$1" --script "$2" \
      --status "$status" || true
  fi
  exit "$status"
fi

# Log the hash for this step. The summary "make elapsed" in "make finish",
# will not have all the .odb files for the bazel-orfs use-case.
"$PYTHON_EXE" "$UTILS_DIR/genElapsedTime.py" --match "$1" -d "$LOG_DIR" \
  | tee -a "$(realpath "$LOG_DIR/$1.log")"

if [ "$SKIP_STAGE_ART" != 1 ]; then
  "$PYTHON_EXE" "$UTILS_DIR/stage_art.py" --stage "$1" --script "$2" --status 0
fi
