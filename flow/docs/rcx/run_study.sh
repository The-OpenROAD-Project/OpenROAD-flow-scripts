#!/usr/bin/env bash
# Run the RCX-vs-GRT fan-out sweep for one PDK through the full flow and collect,
# per variant, the per-stage WNS (reports/.../metadata.json) and the per-net
# GRT-vs-RCX parasitics (results/.../6_net_rc.csv).
#
# Usage:  flow/docs/rcx/run_study.sh [PDK]        (default: asap7)
# Tiny designs -> a full sweep is a few minutes. Designs are independent; this
# runs them sequentially (the native flow is one design per make invocation).
set -u
cd "$(dirname "$0")/../.."          # -> flow/
# shellcheck disable=SC1091
source ../env.sh >/dev/null 2>&1

PDK="${1:-asap7}"
FANOUTS=(1 2 4 8 16 32 64 128)

for n in "${FANOUTS[@]}"; do
  cfg="./designs/${PDK}/rcx-fanout-${n}/config.mk"
  if [[ ! -f "$cfg" ]]; then
    echo "SKIP ${PDK} fanout ${n}: no $cfg (run docs/rcx/gen_study.py)"; continue
  fi
  echo "=== ${PDK} fanout ${n}: flow ==="
  if ! make DESIGN_CONFIG="$cfg" >/dev/null 2>&1; then
    echo "  FLOW FAILED for ${PDK} fanout ${n}"; continue
  fi
  make DESIGN_CONFIG="$cfg" metadata-generate >/dev/null 2>&1
  make DESIGN_CONFIG="$cfg" write_net_rc       >/dev/null 2>&1
  m="reports/${PDK}/rcx-fanout-${n}/base/metadata.json"
  if [[ -f "$m" ]]; then
    python3 - "$m" "$n" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); n = sys.argv[2]
g = d.get("globalroute__timing__setup__ws"); f = d.get("finish__timing__setup__ws")
print(f"  fanout {n:>3}: grt_ws={g}  finish_ws={f}")
PY
  fi
done
echo "Done. Aggregate + plot with: python3 docs/rcx/plot_rcx_study.py"
