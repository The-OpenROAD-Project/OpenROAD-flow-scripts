#!/usr/bin/env python3
"""Aggregate the RCX-vs-GRT fan-out sweep and render the study plots + data table.

Reads, for every PDK/fanout that has been run (see docs/rcx/run_study.sh):
  reports/<pdk>/rcx-fanout-<N>/base/metadata.json   per-stage WNS
  results/<pdk>/rcx-fanout-<N>/base/6_net_rc.csv     per-net GRT & RCX R/C
  designs/<pdk>/rcx-fanout-<N>/constraint.sdc        clk_period (normalizer)

Writes into docs/rcx/plots/:
  wns_vs_fanout_<pdk>.png   normalized WNS per stage vs fan-out (one panel/PDK)
  wns_surprise.png          cross-PDK (RCX - GRT) WNS surprise vs fan-out
  cap_divergence_<pdk>.png  per-net (RCX-GRT)/GRT cap divergence vs fan-out
  study_data.csv            the aggregated table

We do NOT care about absolute WNS, only the SHAPE of the curves across PDKs, so
every WNS is normalized by that design's SDC clock period (a unitless fraction
of the period). See docs/rcx/README.md.

Run via:  bazelisk run //flow/docs/rcx:update      (or)  python3 docs/rcx/plot_rcx_study.py
"""

import csv
import json
import os
import re
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

FANOUTS = [1, 2, 4, 8, 16, 32, 64, 128]

# Literature-backed "sane RTL" fan-out regions (see README references). Fan-out
# is a proxy for the real driver (coupling-blind lumped RC + many-sink HPWL
# underestimate); the bands mark where the pre-route estimate is expected to
# stop tracking RCX.
SANE_MAX = 16     # <= ~FO4 / set_max_fanout floor: GRT should track RCX
TRANSITION_MAX = 64  # buffer trees inserted, divergence grows
# >64: outside the estimation envelope

# Stages to plot as "estimate" curves leading up to the RCX sign-off, in flow
# order. Keys are metadata.json prefixes; finish = post-RCX extraction.
STAGES = [
    ("floorplan", "floorplan"),
    ("cts", "cts"),
    ("globalroute", "global route (GRT est.)"),
    ("finish", "finish (RCX extract)"),
]


def flow_dir():
    """Locate the flow/ directory whether run directly or via `bazel run`."""
    wd = os.environ.get("BUILD_WORKING_DIRECTORY")
    if wd:
        # invoked from within the repo via bazel run
        for cand in (wd, os.path.join(wd, "flow")):
            if os.path.isdir(os.path.join(cand, "designs")):
                return cand
    here = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(here, "..", ".."))


FLOW = flow_dir()
PLOTS = os.path.join(FLOW, "docs", "rcx", "plots")


def clk_period(pdk, n):
    sdc = os.path.join(FLOW, "designs", pdk, f"rcx-fanout-{n}", "constraint.sdc")
    with open(sdc) as f:
        m = re.search(r"set\s+clk_period\s+(\d+(?:\.\d+)?)", f.read())
    return float(m.group(1)) if m else None


def discover_pdks():
    base = os.path.join(FLOW, "reports")
    pdks = []
    if os.path.isdir(base):
        for pdk in sorted(os.listdir(base)):
            if any(
                os.path.isfile(
                    os.path.join(base, pdk, f"rcx-fanout-{n}", "base", "metadata.json")
                )
                for n in FANOUTS
            ):
                pdks.append(pdk)
    return pdks


def load_wns(pdk):
    """Return {stage: {fanout: normalized_ws}} for one PDK."""
    out = {s: {} for s, _ in STAGES}
    for n in FANOUTS:
        meta = os.path.join(
            FLOW, "reports", pdk, f"rcx-fanout-{n}", "base", "metadata.json"
        )
        if not os.path.isfile(meta):
            continue
        d = json.load(open(meta))
        period = clk_period(pdk, n)
        if not period:
            continue
        for stage, _ in STAGES:
            ws = d.get(f"{stage}__timing__setup__ws")
            if ws is not None:
                out[stage][n] = ws / period
    return out


def load_net_rc(pdk):
    """Return {design_fanout: {"all": [(fo, grt_cap, rcx_cap)], "hub": (fo, grt_cap, rcx_cap)}}.

    The "hub" of each design is its highest-fan-out net (the net under study);
    its fan-out is ~N. Tracking the hub net per design gives a clean
    estimate-error-vs-fan-out curve (the all-nets scatter is dominated by the
    many incidental fan-out-1 nets present in every design)."""
    out = {}
    for n in FANOUTS:
        csvf = os.path.join(
            FLOW, "results", pdk, f"rcx-fanout-{n}", "base", "6_net_rc.csv"
        )
        if not os.path.isfile(csvf):
            continue
        rows = []
        with open(csvf) as f:
            for line in f:
                if line.startswith("#") or not line.strip():
                    continue
                t = [x.strip() for x in line.split(",")]
                # name,type,fanout,grt_res,grt_cap,rcx_res,rcx_cap,<lengths>
                try:
                    rows.append((int(t[2]), float(t[4]), float(t[6])))
                except (ValueError, IndexError):
                    continue
        rows = [r for r in rows if r[2] > 0]  # need extracted cap
        if not rows:
            continue
        out[n] = {"all": rows, "hub": max(rows, key=lambda r: r[0])}
    return out


def shade_regions(ax, xmax):
    ax.axvspan(0.9, SANE_MAX, color="tab:green", alpha=0.08, zorder=0)
    ax.axvspan(SANE_MAX, TRANSITION_MAX, color="tab:orange", alpha=0.08, zorder=0)
    ax.axvspan(TRANSITION_MAX, xmax, color="tab:red", alpha=0.08, zorder=0)
    ax.text(np.sqrt(0.9 * SANE_MAX), 0.02, "sane RTL", color="tab:green",
            ha="center", va="bottom", transform=ax.get_xaxis_transform(), fontsize=8)
    ax.text(np.sqrt(SANE_MAX * TRANSITION_MAX), 0.02, "transition", color="tab:orange",
            ha="center", va="bottom", transform=ax.get_xaxis_transform(), fontsize=8)
    ax.text(np.sqrt(TRANSITION_MAX * xmax), 0.02, "out of envelope", color="tab:red",
            ha="center", va="bottom", transform=ax.get_xaxis_transform(), fontsize=8)


def plot_wns_per_pdk(pdk, wns):
    fig, ax = plt.subplots(figsize=(8, 5))
    xmax = FANOUTS[-1] * 1.3
    shade_regions(ax, xmax)
    for stage, label in STAGES:
        pts = sorted(wns[stage].items())
        if not pts:
            continue
        xs, ys = zip(*pts)
        ax.plot(xs, ys, marker="o", label=label)
    ax.set_xscale("log", base=2)
    ax.set_xticks(FANOUTS)
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xlabel("net fan-out (number of sinks)")
    ax.set_ylabel("normalized WNS  (worst slack / clock period)")
    ax.axhline(0.0, color="k", lw=0.8, ls="--")
    ax.set_title(f"{pdk}: normalized WNS per flow stage vs fan-out")
    ax.legend()
    ax.grid(True, which="both", alpha=0.3)
    out = os.path.join(PLOTS, f"wns_vs_fanout_{pdk}.png")
    fig.savefig(out, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.relpath(out, FLOW))


def plot_surprise(all_wns):
    """Cross-PDK: (RCX finish - GRT estimate) normalized WNS vs fan-out."""
    fig, ax = plt.subplots(figsize=(8, 5))
    xmax = FANOUTS[-1] * 1.3
    shade_regions(ax, xmax)
    for pdk, wns in all_wns.items():
        xs, ys = [], []
        for n in FANOUTS:
            if n in wns["finish"] and n in wns["globalroute"]:
                xs.append(n)
                ys.append(wns["finish"][n] - wns["globalroute"][n])
        if xs:
            # PDKs without an OpenRCX deck (e.g. gt2n) fall back to the GRT
            # estimate at finish, so finish == globalroute and there is nothing
            # to diverge -- flag that rather than implying a perfect estimate.
            label = pdk if max(abs(y) for y in ys) > 1e-6 else f"{pdk} (no RCX)"
            ax.plot(xs, ys, marker="o", label=label)
    ax.set_xscale("log", base=2)
    ax.set_xticks(FANOUTS)
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xlabel("net fan-out (number of sinks)")
    ax.set_ylabel("WNS surprise  (RCX - GRT) / clock period")
    ax.axhline(0.0, color="k", lw=0.8, ls="--")
    ax.set_title("The surprise: how much RCX moves WNS vs the GRT estimate")
    ax.legend()
    ax.grid(True, which="both", alpha=0.3)
    out = os.path.join(PLOTS, "wns_surprise.png")
    fig.savefig(out, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.relpath(out, FLOW))


def cap_err(grt, rcx):
    """GRT estimate error vs the RCX truth, in percent (+ => GRT over-estimates)."""
    return (grt - rcx) / rcx * 100.0


def plot_cap_divergence(pdk, net_rc):
    if not net_rc:
        return
    fig, ax = plt.subplots(figsize=(8, 5))
    xmax = FANOUTS[-1] * 1.3
    shade_regions(ax, xmax)
    # background: every net of every design, at its own fan-out
    sx, sy = [], []
    for d in net_rc.values():
        for fo, grt, rcx in d["all"]:
            if fo >= 1 and grt > 0:
                sx.append(fo)
                sy.append(cap_err(grt, rcx))
    if sx:
        jit = np.exp(np.random.uniform(-0.05, 0.05, size=len(sx)))
        ax.scatter(np.array(sx) * jit, sy, s=10, alpha=0.25,
                   color="tab:blue", label="all nets")
    # foreground: the hub net of each design (the net under study, fan-out ~= N)
    hx, hy = [], []
    for n in sorted(net_rc):
        fo, grt, rcx = net_rc[n]["hub"]
        if grt > 0:
            hx.append(fo)
            hy.append(cap_err(grt, rcx))
    ax.plot(hx, hy, marker="s", color="tab:red", label="hub net (under study)")
    ax.set_xscale("log", base=2)
    ax.set_xticks(FANOUTS)
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xlabel("net fan-out (number of sinks)")
    ax.set_ylabel("GRT wire-cap estimate error  (GRT - RCX) / RCX  [%]")
    ax.axhline(0.0, color="k", lw=0.8, ls="--")
    ax.set_title(f"{pdk}: GRT wire-capacitance estimate vs RCX extraction")
    ax.legend()
    ax.grid(True, which="both", alpha=0.3)
    out = os.path.join(PLOTS, f"cap_divergence_{pdk}.png")
    fig.savefig(out, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.relpath(out, FLOW))


def write_table(all_wns):
    out = os.path.join(PLOTS, "study_data.csv")
    with open(out, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["pdk", "fanout"] + [s for s, _ in STAGES] + ["surprise"])
        for pdk, wns in all_wns.items():
            for n in FANOUTS:
                row = [pdk, n] + [wns[s].get(n, "") for s, _ in STAGES]
                if n in wns["finish"] and n in wns["globalroute"]:
                    row.append(wns["finish"][n] - wns["globalroute"][n])
                else:
                    row.append("")
                w.writerow(row)
    print("wrote", os.path.relpath(out, FLOW))


def main():
    os.makedirs(PLOTS, exist_ok=True)
    np.random.seed(0)
    pdks = discover_pdks()
    if not pdks:
        print("No results found. Run docs/rcx/run_study.sh first.", file=sys.stderr)
        return 1
    print("PDKs:", ", ".join(pdks))
    all_wns = {}
    for pdk in pdks:
        wns = load_wns(pdk)
        all_wns[pdk] = wns
        plot_wns_per_pdk(pdk, wns)
        plot_cap_divergence(pdk, load_net_rc(pdk))
    plot_surprise(all_wns)
    write_table(all_wns)
    return 0


if __name__ == "__main__":
    sys.exit(main())
