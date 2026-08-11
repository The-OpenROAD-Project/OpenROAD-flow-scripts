#!/usr/bin/env bash
# Generate utilization and aspect-ratio variants of existing ORFS designs
# to expand the thermal training dataset.
#
# Runs each design through the ORFS flow up to the `place` target only — the
# minimum needed for thermal label extraction.  Full routing is not needed.
#
# Usage (from flow/):
#   bash ml/congestion/data_collection/generate_variants.sh [--dry-run]
#
# --dry-run  Print the make commands without executing them.
#
# After this script completes, re-run the batch thermal extractor:
#   bash ml/congestion/data_collection/extract_thermal_batch.sh
#
# Target designs (chosen for real ΔT and structural diversity):
#   nangate45: ibex, jpeg, swerv, ariane133, riscv32i (sky130hd)
#
# Variant axes:
#   Option 1 — CORE_UTILIZATION: 60, 70, 90  (base is ~50–80 already)
#   Option 3 — CORE_ASPECT_RATIO: 0.5 (wide), 1.5 (tall), 2.0 (very tall)

set -euo pipefail
cd "$(dirname "$0")/../../.."   # → flow/

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

run_make() {
    local platform="$1" design="$2" variant="$3"
    shift 3
    local extra_vars=("$@")

    local config="designs/${platform}/${design}/config.mk"
    if [ ! -f "$config" ]; then
        echo "  [SKIP] $config not found"
        return
    fi

    local result_odb="results/${platform}/${design}/${variant}/3_place.odb"
    if [ -f "$result_odb" ]; then
        echo "  [SKIP] $result_odb already exists"
        return
    fi

    # Build the inner make command (runs inside Docker where tools are installed).
    # docker_shell sets WORK_HOME=/work (mounted to host flow/) so results are
    # written to host results/<platform>/<design>/<variant>/ and persist after
    # the container exits.
    local inner="make DESIGN_CONFIG=${config} FLOW_VARIANT=${variant}"
    for v in "${extra_vars[@]}"; do
        inner+=" $v"
    done
    inner+=" place"

    echo ""
    echo ">>> ${platform}/${design}/${variant}"
    echo "    util/docker_shell -- \"${inner}\""

    if [ "$DRY_RUN" -eq 0 ]; then
        # </dev/null prevents docker -i from consuming the surrounding loop's stdin.
        # || true: log failure and continue — one bad design shouldn't abort the batch.
        if ! util/docker_shell -- "$inner" </dev/null; then
            echo "  [FAIL] ${platform}/${design}/${variant} — continuing"
        fi
    fi
}

echo "========================================================"
echo " Variant generation  (dry-run=${DRY_RUN})"
echo " Option 1: utilization variants  (60, 70, 90)"
echo " Option 3: aspect-ratio variants (0.5, 1.5, 2.0)"
echo "========================================================"

# ── Option 1: utilization variants ───────────────────────────────────────────
# Target designs with interesting ΔT — small/uniform designs (adder4, gcd)
# are intentionally excluded as their thermal maps are near-flat regardless.

echo ""
echo "--- Option 1: utilization variants ---"

for util in 60 70 90; do
    variant="util_${util}"

    run_make nangate45 ibex      "$variant" "CORE_UTILIZATION=${util}"
    run_make nangate45 jpeg      "$variant" "CORE_UTILIZATION=${util}"
    run_make nangate45 swerv     "$variant" "CORE_UTILIZATION=${util}"
    # ariane133 excluded: 132 SRAM macros make RTLMP infeasible at ≥70% util (MPL-0040)
    run_make sky130hd  riscv32i  "$variant" "CORE_UTILIZATION=${util}"
done

# ── Option 3: aspect-ratio variants ──────────────────────────────────────────
# A tall die concentrates heat in a narrow column; a wide die spreads it
# horizontally. Same design, different spatial thermal pattern.

echo ""
echo "--- Option 3: aspect-ratio variants ---"

for ar_raw in 05 15 20; do
    # Convert 05 → 0.5, 15 → 1.5, 20 → 2.0
    ar="${ar_raw:0:1}.${ar_raw:1:1}"
    variant="ar_${ar_raw}"

    run_make nangate45 ibex      "$variant" "CORE_ASPECT_RATIO=${ar}"
    run_make nangate45 jpeg      "$variant" "CORE_ASPECT_RATIO=${ar}"
    run_make nangate45 swerv     "$variant" "CORE_ASPECT_RATIO=${ar}"
    run_make sky130hd  riscv32i  "$variant" "CORE_ASPECT_RATIO=${ar}"
done

echo ""
echo "========================================================"
echo " Done. Next step:"
echo "   bash ml/congestion/data_collection/extract_thermal_batch.sh"
echo "========================================================"
