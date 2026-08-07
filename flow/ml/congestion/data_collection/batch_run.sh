#!/usr/bin/env bash
# Collect congestion training data for a set of designs.
# Runs each design through placement + GRT, then extracts features and labels.
#
# Usage: bash batch_run.sh [--grid N] [--out-dir DIR]
#
# Must be run from the flow/ directory.
set -euo pipefail

GRID=64
OUT_DIR="ml/congestion/data"
FLOW_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --grid)    GRID="$2";    shift 2 ;;
        --out-dir) OUT_DIR="$2"; shift 2 ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

mkdir -p "$OUT_DIR"

# Designs to collect data from — mix of sizes and complexities
DESIGNS=(
    "nangate45/aes"
    "nangate45/gcd"
    "nangate45/jpeg"
    "nangate45/swerv"
    "nangate45/swerv_wrapper"
    "nangate45/ibex"
    "nangate45/coyote_tc"
    "nangate45/tinyRocket"
    "sky130hd/gcd"
    "sky130hd/ibex"
    "sky130hd/jpeg"
    "sky130hd/aes"
)

ok=0
fail=0

for entry in "${DESIGNS[@]}"; do
    platform="${entry%/*}"
    design="${entry#*/}"
    tag="${platform}_${design}"
    features_out="/work/ml/congestion/data/${tag}_features.npz"
    labels_out="/work/ml/congestion/data/${tag}_labels.npz"
    config="/work/designs/${platform}/${design}/config.mk"

    echo "=== $tag ==="

    # Check config exists
    if [[ ! -f "designs/${platform}/${design}/config.mk" ]]; then
        echo "  SKIP — no config.mk"
        continue
    fi

    # Run through GRT (make's dependency chain handles place+cts+grt)
    echo "  Running make grt..."
    if ! util/docker_shell make \
            DESIGN_CONFIG="$config" \
            DESIGN_HOME=/work/designs \
            grt 2>&1 | tee "/tmp/${tag}_make.log" | tail -5; then
        echo "  FAIL — make grt exited non-zero"
        (( fail++ )) || true
        continue
    fi

    # Extract features from detailed placement ODB
    # Resolve nickname from config (DESIGN_NICKNAME may differ from folder name)
    nickname=$(grep -m1 'DESIGN_NICKNAME' "designs/${platform}/${design}/config.mk" \
               | sed 's/.*=\s*//' | tr -d '[:space:]') || nickname="$design"
    dp_odb="/work/results/${platform}/${nickname}/base/3_5_place_dp.odb"
    grt_odb="/work/results/${platform}/${nickname}/base/5_1_grt.odb"

    echo "  Extracting features..."
    if ! util/docker_shell openroad -python \
            /work/ml/congestion/data_collection/extract_features.py \
            --odb "$dp_odb" --out "$features_out" --grid "$GRID"; then
        echo "  FAIL — feature extraction"
        (( fail++ )) || true
        continue
    fi

    echo "  Extracting labels..."
    if ! util/docker_shell openroad -python \
            /work/ml/congestion/data_collection/extract_labels.py \
            --odb "$grt_odb" --out "$labels_out" --grid "$GRID"; then
        echo "  FAIL — label extraction"
        (( fail++ )) || true
        continue
    fi

    echo "  OK"
    (( ok++ )) || true
done

echo ""
echo "Done: $ok succeeded, $fail failed"
echo "Data in: $OUT_DIR"
