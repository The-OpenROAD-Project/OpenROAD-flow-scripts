#!/usr/bin/env bash
# Extract features and labels from ODB files that already exist in flow/results/.
# Skips designs where either ODB is missing.
# Run from the flow/ directory.
set -euo pipefail

GRID=${1:-64}
OUT_DIR="ml/congestion/data"
mkdir -p "$OUT_DIR"

ok=0
skip=0
fail=0

# List of platform/nickname pairs to try
DESIGNS=(
    "asap7 aes"
    "nangate45 aes"
    "nangate45 adder4"
    "nangate45 dynamic_node"
    "nangate45 gcd"
    "nangate45 ibex"
    "nangate45 jpeg"
    "nangate45 swerv"
    "nangate45 tinyRocket"
    "sky130hd aes"
    "sky130hd ibex"
    "sky130hd jpeg"
    "sky130hd riscv32i"
)

for entry in "${DESIGNS[@]}"; do
    platform=$(echo "$entry" | cut -d' ' -f1)
    nickname=$(echo "$entry" | cut -d' ' -f2)
    tag="${platform}_${nickname}"

    dp_odb="results/${platform}/${nickname}/base/3_5_place_dp.odb"
    grt_odb="results/${platform}/${nickname}/base/5_1_grt.odb"

    if [[ ! -f "$dp_odb" || ! -f "$grt_odb" ]]; then
        echo "SKIP $tag — missing ODB files"
        (( skip++ )) || true
        continue
    fi

    feat_out="${OUT_DIR}/${tag}_features.npz"
    label_out="${OUT_DIR}/${tag}_labels.npz"

    echo "=== $tag ==="

    echo "  Extracting features..."
    if ! util/docker_shell openroad -python \
            /work/ml/congestion/data_collection/extract_features.py \
            --odb "/work/${dp_odb}" \
            --out "/work/${feat_out}" \
            --grid "$GRID" < /dev/null 2>&1 | sed 's/^/    /'; then
        echo "  FAIL — feature extraction"
        (( fail++ )) || true
        continue
    fi

    echo "  Extracting labels..."
    if ! util/docker_shell openroad -python \
            /work/ml/congestion/data_collection/extract_labels.py \
            --odb "/work/${grt_odb}" \
            --out "/work/${label_out}" \
            --grid "$GRID" < /dev/null 2>&1 | sed 's/^/    /'; then
        echo "  FAIL — label extraction"
        (( fail++ )) || true
        continue
    fi

    echo "  OK"
    (( ok++ )) || true
done

echo ""
echo "Done: $ok extracted, $skip skipped, $fail failed"
echo "Data written to: $OUT_DIR"
