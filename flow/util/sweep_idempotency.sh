#!/bin/bash
# Sweep multiple designs for idempotency, running ALL designs in parallel.
# Each design runs two flows (idem_run1, idem_run2) via FLOW_VARIANT,
# and each design uses its own results/logs directory, so everything
# is fully parallel.
#
# Usage: ./util/sweep_idempotency.sh [extra_design1 extra_design2 ...]
#   e.g.: ./util/sweep_idempotency.sh nangate45/swerv_wrapper
#
# Always tests asap7/gcd and nangate45/gcd first, plus any extra designs.
# Exit code: 0 if all deterministic, 1 if any non-determinism found.

set -euo pipefail

DESIGNS=("asap7/gcd" "nangate45/gcd" "$@")

# Remove duplicates while preserving order
UNIQUE_DESIGNS=()
declare -A SEEN
for d in "${DESIGNS[@]}"; do
    if [ -z "${SEEN[$d]:-}" ]; then
        UNIQUE_DESIGNS+=("$d")
        SEEN[$d]=1
    fi
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Running idempotency tests for ${#UNIQUE_DESIGNS[@]} designs IN PARALLEL:"
for d in "${UNIQUE_DESIGNS[@]}"; do echo "  - $d"; done
echo ""

# Launch all designs in parallel
declare -A PIDS
declare -A LOGS
for design in "${UNIQUE_DESIGNS[@]}"; do
    logfile="/tmp/idempotency_sweep_${design//\//_}.log"
    LOGS[$design]="$logfile"
    "$SCRIPT_DIR/test_idempotency.sh" "$design" > "$logfile" 2>&1 &
    PIDS[$design]=$!
done

# Wait for all and collect results
FAIL=0
for design in "${UNIQUE_DESIGNS[@]}"; do
    echo "========================================"
    echo "Waiting for: $design (PID ${PIDS[$design]})"
    if wait "${PIDS[$design]}"; then
        echo "PASS: $design"
    else
        echo "FAIL: $design — NON-DETERMINISTIC"
        FAIL=1
    fi
    echo "--- Output ---"
    cat "${LOGS[$design]}"
    echo ""
done

echo "========================================"
if [ $FAIL -eq 0 ]; then
    echo "SWEEP RESULT: All ${#UNIQUE_DESIGNS[@]} designs are DETERMINISTIC"
else
    echo "SWEEP RESULT: NON-DETERMINISM DETECTED in one or more designs"
fi
echo "========================================"
exit $FAIL
