#!/bin/bash
# Drilldown into idempotency for a single design using every A/B trick
# in the book. Each trick uses a unique FLOW_VARIANT so all tests run
# in parallel with independent output directories.
#
# Usage: ./util/drilldown_idempotency.sh <platform/design>
#   e.g.: ./util/drilldown_idempotency.sh asap7/gcd
#
# Make variables used for perturbation (from variables.mk):
#   FLOW_VARIANT  — output directory selector (logs/results/objects/reports)
#   NUM_CORES     — thread count, feeds into OPENROAD_ARGS via -threads
#   OR_ARGS       — extra args appended to OPENROAD_ARGS
#   OPENROAD_EXE  — path to openroad binary (can be a wrapper)
#
# Environment perturbations:
#   MALLOC_PERTURB_  — fills freed memory to detect uninitialized reads
#   setarch -R       — disables ASLR
#
# Exit code: 0 if all match baseline, 1 if any trick reveals divergence.

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <platform/design>" >&2
    exit 2
fi

DESIGN="$1"
DESIGN_CONFIG="./designs/${DESIGN}/config.mk"
PLATFORM=$(echo "$DESIGN" | cut -d/ -f1)
DESIGN_NAME=$(echo "$DESIGN" | cut -d/ -f2)

if [ ! -f "$DESIGN_CONFIG" ]; then
    echo "ERROR: Design config not found: $DESIGN_CONFIG" >&2
    exit 2
fi

# Common make arguments shared by all variants
MAKE="make DESIGN_CONFIG=$DESIGN_CONFIG EQUIVALENCE_CHECK=0"

extract_hashes() {
    local variant="$1"
    python3 util/genElapsedTime.py -d "logs/${PLATFORM}/${DESIGN_NAME}/${variant}/" 2>/dev/null \
        | awk 'NF>=4 && $4 ~ /^[0-9a-f]/ {print $1, $4}'
}

echo "Drilldown idempotency: $DESIGN"
echo ""

# --- Define variants ---
# Each entry: "variant_name|shell command"
# Uses make VAR=val syntax for readability; env wrappers where needed.

VARIANTS=(
    # Baseline: two identical runs
    "plain_a|$MAKE FLOW_VARIANT=plain_a finish"
    "plain_b|$MAKE FLOW_VARIANT=plain_b finish"

    # Single-threaded: eliminates thread scheduling non-determinism
    "thread1|$MAKE FLOW_VARIANT=thread1 NUM_CORES=1 finish"

    # ASLR disabled: eliminates pointer-address-dependent ordering
    "noaslr|setarch $(uname -m) -R $MAKE FLOW_VARIANT=noaslr finish"

    # Memory perturbation: detects use of uninitialized memory
    "mallocperturb|env MALLOC_PERTURB_=1 $MAKE FLOW_VARIANT=mallocperturb finish"
)

echo "Variants to test:"
for entry in "${VARIANTS[@]}"; do
    name="${entry%%|*}"
    echo "  - $name"
done
echo ""

# --- Clean all variants ---
for entry in "${VARIANTS[@]}"; do
    name="${entry%%|*}"
    $MAKE FLOW_VARIANT="$name" clean_all >/dev/null 2>&1 || true
done

# --- Launch all in parallel ---
declare -A PIDS LOGS
for entry in "${VARIANTS[@]}"; do
    name="${entry%%|*}"
    cmd="${entry#*|}"
    logfile="/tmp/drill_${PLATFORM}_${DESIGN_NAME}_${name}.log"
    LOGS[$name]="$logfile"
    echo "Starting: $name"
    bash -c "$cmd" > "$logfile" 2>&1 &
    PIDS[$name]=$!
done

# --- Wait for all ---
echo ""
echo "Waiting for all variants to complete..."
VARIANT_NAMES=()
for entry in "${VARIANTS[@]}"; do
    name="${entry%%|*}"
    VARIANT_NAMES+=("$name")
    if wait "${PIDS[$name]}"; then
        echo "  $name: completed"
    else
        echo "  $name: FAILED (check ${LOGS[$name]})"
    fi
done

# --- Extract hashes ---
echo ""
echo "========================================"
echo "Hash results"
echo "========================================"

declare -A HASH_FILES
for name in "${VARIANT_NAMES[@]}"; do
    hfile="/tmp/drill_hashes_${PLATFORM}_${DESIGN_NAME}_${name}.txt"
    extract_hashes "$name" > "$hfile"
    HASH_FILES[$name]="$hfile"
    echo ""
    echo "--- $name ---"
    cat "$hfile"
done

# --- Compare against baseline (plain_a) ---
echo ""
echo "========================================"
echo "Comparisons against baseline (plain_a)"
echo "========================================"

BASELINE="${HASH_FILES[plain_a]}"
FAIL=0
DIVERGENT=()

for name in "${VARIANT_NAMES[@]}"; do
    [ "$name" = "plain_a" ] && continue
    echo ""
    echo "--- plain_a vs $name ---"
    if diff -q "$BASELINE" "${HASH_FILES[$name]}" >/dev/null 2>&1; then
        echo "MATCH"
    else
        echo "DIVERGENT!"
        diff "$BASELINE" "${HASH_FILES[$name]}" || true
        FAIL=1
        DIVERGENT+=("$name")
    fi
done

# --- Summary ---
echo ""
echo "========================================"
if [ $FAIL -eq 0 ]; then
    echo "DRILLDOWN: $DESIGN — all variants match. Build is robust."
else
    echo "DRILLDOWN: $DESIGN — DIVERGENCE in: ${DIVERGENT[*]}"
    echo ""
    echo "Next steps:"
    echo "  1. Identify which stage first diverges in: ${DIVERGENT[*]}"
    echo "  2. Create issue: make DESIGN_CONFIG=$DESIGN_CONFIG <stage>_issue"
    echo "  3. Whittle: python3 tools/OpenROAD/etc/whittle.py --error_string NON_DETERMINISTIC ..."
fi
echo "========================================"
exit $FAIL
