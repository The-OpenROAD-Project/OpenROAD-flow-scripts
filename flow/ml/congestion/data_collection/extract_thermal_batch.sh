#!/usr/bin/env bash
# Batch thermal (and placement feature) extraction from existing ORFS result dirs.
#
# Iterates every 3_place.odb already on disk and runs:
#   1. extract_features.py      → ml/congestion/data/<label>_features.npz
#   2. extract_thermal_labels.py → ml/congestion/data/<label>_thermal_labels.npz
#
# Both extractors run inside Docker. Thermal requires openroad/orfs-ml:latest
# (has HotSpot). Features work with the base image but we use the same image
# for consistency.
#
# Usage (from flow/):
#   export OR_IMAGE=openroad/orfs-ml:latest
#   bash ml/congestion/data_collection/extract_thermal_batch.sh [--timeout 600] [--force]
#
# --force  : re-extract thermal labels even if they already exist (use after
#            changing extract_thermal_labels.py, e.g. power model fix)
#
# Already-extracted files are skipped (idempotent).
# Each design is given TIMEOUT_S seconds per extractor (default 600).
# Very large designs (ariane133, ariane136, tinyRocket, swerv) can take
# 10+ minutes for ODB loading alone; raise the timeout if needed.

set -euo pipefail
cd "$(dirname "$0")/../../.."   # → flow/

# Per-extractor timeout in seconds (override with --timeout N).
# Large designs (ariane133/136, swerv, tinyRocket) can take 40+ min just
# for ODB loading; the default gives them headroom.
TIMEOUT_S=3600
FORCE=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --timeout) TIMEOUT_S="$2"; shift 2 ;;
        --force)   FORCE=1; shift ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

DATA_DIR="/work/ml/congestion/data"
FEAT_SCRIPT="/work/ml/congestion/data_collection/extract_features.py"
THERM_SCRIPT="/work/ml/congestion/data_collection/extract_thermal_labels.py"

pass=0; fail=0; skip=0

while IFS= read -r HOST_ODB; do
    # HOST_ODB is a relative path from flow/: results/<platform>/<design>/<tag>/3_place.odb
    # Strip the leading "results/" and trailing "/3_place.odb" to get platform/design/tag
    rel="${HOST_ODB#results/}"                 # platform/design/tag/3_place.odb
    rel="${rel%/3_place.odb}"                  # platform/design/tag
    label="$(echo "$rel" | tr '/' '_')"        # platform_design_tag

    # Container path for the ODB (/work mounts to flow/)
    cont_odb="/work/results/${rel}/3_place.odb"

    feat_out="${DATA_DIR}/${label}_features.npz"
    therm_out="${DATA_DIR}/${label}_thermal_labels.npz"

    # Host-side skip checks (relative to flow/ where the script runs)
    feat_host="ml/congestion/data/${label}_features.npz"
    therm_host="ml/congestion/data/${label}_thermal_labels.npz"

    echo "========================================="
    echo "Design: ${label}"

    # ── Features ──────────────────────────────────────────────────────────
    # Redirect stdin to /dev/null for every docker_shell call so that
    # docker run -i does not consume the remaining lines from the find pipe.
    # timeout kills the docker call if it runs longer than TIMEOUT_S seconds.
    if [ -f "$feat_host" ]; then
        echo "  [SKIP] features already extracted"
        ((skip++)) || true
    else
        echo "  [RUN]  extract_features.py (timeout ${TIMEOUT_S}s)"
        if timeout "$TIMEOUT_S" util/docker_shell openroad -python "$FEAT_SCRIPT" \
               --odb "$cont_odb" --out "$feat_out" </dev/null; then
            echo "  [OK]   ${label}_features.npz"
            ((pass++)) || true
        else
            ec=$?
            if [ $ec -eq 124 ]; then
                echo "  [TIMEOUT] features extraction exceeded ${TIMEOUT_S}s — skipping"
            else
                echo "  [FAIL]   features extraction failed (exit $ec)"
            fi
            ((fail++)) || true
        fi
    fi

    # ── Thermal labels ─────────────────────────────────────────────────────
    if [ -f "$therm_host" ] && [ "$FORCE" -eq 0 ]; then
        echo "  [SKIP] thermal labels already extracted"
        ((skip++)) || true
    else
        echo "  [RUN]  extract_thermal_labels.py (timeout ${TIMEOUT_S}s)"
        if timeout "$TIMEOUT_S" util/docker_shell openroad -python "$THERM_SCRIPT" \
               --odb "$cont_odb" --out "$therm_out" </dev/null; then
            echo "  [OK]   ${label}_thermal_labels.npz"
            ((pass++)) || true
        else
            ec=$?
            if [ $ec -eq 124 ]; then
                echo "  [TIMEOUT] thermal extraction exceeded ${TIMEOUT_S}s — skipping"
            else
                echo "  [FAIL]   thermal extraction failed (exit $ec; HotSpot installed?)"
            fi
            ((fail++)) || true
        fi
    fi

done < <(find results -name "3_place.odb" | sort)

echo ""
echo "========================================="
echo "Done.  passed=${pass}  failed=${fail}  skipped=${skip}"
