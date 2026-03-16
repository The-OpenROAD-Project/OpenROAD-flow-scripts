#!/bin/bash
# Test build idempotency for a given design by running the flow twice
# SEQUENTIALLY with different FLOW_VARIANTs and comparing per-stage hashes.
#
# Usage: ./util/test_idempotency.sh <platform/design>
#   e.g.: ./util/test_idempotency.sh asap7/gcd
#         ./util/test_idempotency.sh nangate45/swerv_wrapper
#
# Uses FLOW_VARIANT=idem_run1 and FLOW_VARIANT=idem_run2.
# Runs are sequential to avoid resource contention affecting results.
#
# Exit code: 0 if deterministic, 1 if non-deterministic, 2 on usage error

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

MAKE="make DESIGN_CONFIG=$DESIGN_CONFIG EQUIVALENCE_CHECK=0"

extract_hashes() {
    local variant="$1"
    python3 util/genElapsedTime.py -d "logs/${PLATFORM}/${DESIGN_NAME}/${variant}/" 2>/dev/null \
        | awk 'NF>=4 && $4 ~ /^[0-9a-f]/ {print $1, $4}'
}

echo "Testing idempotency: $DESIGN (sequential runs)"
echo "================================"

# Run 1
echo "Run 1 (FLOW_VARIANT=idem_run1)..."
$MAKE FLOW_VARIANT=idem_run1 clean_all >/dev/null 2>&1 || true
$MAKE FLOW_VARIANT=idem_run1 finish 2>&1 | tail -1

# Run 2
echo "Run 2 (FLOW_VARIANT=idem_run2)..."
$MAKE FLOW_VARIANT=idem_run2 clean_all >/dev/null 2>&1 || true
$MAKE FLOW_VARIANT=idem_run2 finish 2>&1 | tail -1

# Extract and compare
extract_hashes idem_run1 > /tmp/idempotency_run1_${PLATFORM}_${DESIGN_NAME}.txt
extract_hashes idem_run2 > /tmp/idempotency_run2_${PLATFORM}_${DESIGN_NAME}.txt

echo ""
echo "Run 1 hashes:"
cat /tmp/idempotency_run1_${PLATFORM}_${DESIGN_NAME}.txt
echo ""
echo "Run 2 hashes:"
cat /tmp/idempotency_run2_${PLATFORM}_${DESIGN_NAME}.txt
echo ""

if diff -q /tmp/idempotency_run1_${PLATFORM}_${DESIGN_NAME}.txt \
           /tmp/idempotency_run2_${PLATFORM}_${DESIGN_NAME}.txt >/dev/null 2>&1; then
    echo "RESULT: $DESIGN is DETERMINISTIC (all hashes match)"
    exit 0
else
    echo "RESULT: $DESIGN is NON-DETERMINISTIC!"
    echo ""
    echo "Diverging stages:"
    diff /tmp/idempotency_run1_${PLATFORM}_${DESIGN_NAME}.txt \
         /tmp/idempotency_run2_${PLATFORM}_${DESIGN_NAME}.txt || true
    exit 1
fi
