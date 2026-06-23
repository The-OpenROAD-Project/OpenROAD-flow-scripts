#!/usr/bin/env python3
"""Actionable per-net GRT-estimate vs RCX-extracted parasitics divergence report.

Consumes the per-net CSV already produced by `make write_net_rc`
(results/<pdk>/<design>/base/6_net_rc.csv -- see flow/util/write_net_rc.tcl,
which this study extended with a `fanout` column) and emits a ranked, annotated
report of the nets where the global-route parasitic *estimate* diverges most
from the post-route OpenRCX *extraction*.

This is the report the study argues global_route should emit natively (as DRC
markers on the offending nets); see docs/rcx/README.md. Until then this script
produces the same information from existing flow data.

Usage:
  python3 docs/rcx/rcx_divergence_report.py results/asap7/rcx-fanout-128/base/6_net_rc.csv
  python3 docs/rcx/rcx_divergence_report.py <csv> [--top N] [--sane-fanout 16]
"""

import argparse
import sys

# fF per Farad, for human-readable output.
FF = 1e15


def parse_csv(path):
    """Yield dicts per net from a 6_net_rc.csv (with the fanout column)."""
    stack = []
    with open(path) as f:
        for line in f:
            if line.startswith("# stack:"):
                for layer in line.removeprefix("# stack:").strip().split():
                    name = layer.split("(")[0]
                    routing = "(routing)" in layer
                    stack.append((name, routing))
                continue
            if line.startswith("#") or not line.strip():
                continue
            t = [x.strip() for x in line.split(",")]
            try:
                lengths = [float(x) for x in t[7:]]
            except ValueError:
                continue
            wl = sum(
                ln for i, ln in enumerate(lengths)
                if i < len(stack) and stack[i][1]
            )
            yield {
                "net": t[0],
                "type": t[1],
                "fanout": int(t[2]),
                "grt_res": float(t[3]),
                "grt_cap": float(t[4]),
                "rcx_res": float(t[5]),
                "rcx_cap": float(t[6]),
                "wire_length": wl,
            }


def pct(new, ref):
    return (new - ref) / ref * 100.0 if ref else 0.0


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("csv", help="6_net_rc.csv from `make write_net_rc`")
    ap.add_argument("--top", type=int, default=20, help="rows to print")
    ap.add_argument("--sane-fanout", type=int, default=16,
                    help="fan-out at/below which GRT is expected to track RCX")
    args = ap.parse_args()

    nets = [n for n in parse_csv(args.csv) if n["rcx_cap"] > 0]
    if not nets:
        print("no nets with extracted parasitics in", args.csv, file=sys.stderr)
        return 1

    for n in nets:
        n["cap_div"] = pct(n["grt_cap"], n["rcx_cap"])  # GRT relative to RCX truth
        n["res_div"] = pct(n["grt_res"], n["rcx_res"]) if n["rcx_res"] else 0.0
    # Rank by absolute capacitance divergence weighted by the RCX cap itself, so
    # big, badly-estimated nets (the ones that actually move timing) float up.
    nets.sort(key=lambda n: abs(n["grt_cap"] - n["rcx_cap"]), reverse=True)

    n_out = sum(1 for n in nets if n["fanout"] > args.sane_fanout)
    print(f"# GRT-estimate vs RCX-extracted parasitic divergence")
    print(f"# source: {args.csv}")
    print(f"# nets: {len(nets)}   fan-out > {args.sane_fanout}: {n_out}")
    print(f"# cap divergence = (GRT_cap - RCX_cap) / RCX_cap   "
          f"(negative => GRT under-estimates)")
    print()
    hdr = (f"{'net':<22} {'fanout':>6} {'len_um':>8} "
           f"{'GRT_cap_fF':>10} {'RCX_cap_fF':>10} {'cap_div%':>8} "
           f"{'res_div%':>8}  verdict")
    print(hdr)
    print("-" * len(hdr))
    for n in nets[: args.top]:
        verdict = ""
        if n["fanout"] > args.sane_fanout:
            verdict = "OUT-OF-ENVELOPE (high fan-out: split / pipeline / buffer)"
        elif abs(n["cap_div"]) > 25:
            verdict = "estimate off > 25%"
        # GRT only populates net resistance for 2-pin nets; show n/a otherwise.
        res = f"{n['res_div']:>8.1f}" if n["grt_res"] > 0 else f"{'n/a':>8}"
        print(f"{n['net']:<22} {n['fanout']:>6d} {n['wire_length']:>8.2f} "
              f"{n['grt_cap'] * FF:>10.2f} {n['rcx_cap'] * FF:>10.2f} "
              f"{n['cap_div']:>8.1f} {res}  {verdict}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
