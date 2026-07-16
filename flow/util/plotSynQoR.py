#!/usr/bin/env python3
"""Plot synthesis QoR of OpenROAD-SYN vs yosys across designs.

Consumes per-design qor.json pairs produced by bazel-orfs's best-effort
orfs_synth_qor targets (<design>_syn_qor / <design>_yosys_qor): each file
is either a synthesis-only metadata.json or a failure marker
{"orfs_qor_failed": true, ...}. Designs whose synthesis failed are drawn
as hatched FAIL columns rather than omitted, so the output is a status
report of OpenROAD-SYN across the design suite.

Usage:
  plotSynQoR.py --output qor.png \\
      --design gcd --syn gcd_syn.json --base gcd_yosys.json \\
      --design aes --syn aes_syn.json --base aes_yosys.json ...

The output is deterministic (Agg backend, fixed geometry, no timestamps)
so the PNG can be checked in and diffed meaningfully.
"""

import argparse
import json
import sys

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.ticker import ScalarFormatter  # noqa: E402
from matplotlib.transforms import blended_transform_factory  # noqa: E402

# Palette: diverging pair and A/B categorical pair (validated for CVD
# separation and contrast on a light surface), neutral grays for small
# deltas and failure states.
BETTER = "#2a78d6"
WORSE = "#c44536"
SERIES_YOSYS = "#2a78d6"
SERIES_SYN = "#eb6834"
NEUTRAL = "#6a6965"
FAIL_FACE = "#e8e7e3"
FAIL_EDGE = "#52514e"
TEXT_PRIMARY = "#0b0b0b"
TEXT_SECONDARY = "#52514e"
SURFACE = "#fcfcfb"

# Deltas within this band (percent or ps) are drawn neutral: they carry
# no better/worse verdict at this resolution.
NEUTRAL_BAND = 1.0


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="Output PNG path")
    parser.add_argument(
        "--runtime-output",
        default=None,
        help="Optional second PNG: absolute synthesis runtime A/B "
        "(yosys vs OpenROAD-SYN) per design",
    )
    parser.add_argument(
        "--title",
        default="OpenROAD-SYN vs yosys: synthesis QoR (asap7)",
        help="Figure title",
    )
    parser.add_argument(
        "--design", action="append", default=[], help="Design name (repeat)"
    )
    parser.add_argument(
        "--syn",
        action="append",
        default=[],
        help="qor.json from the OpenROAD-SYN run (repeat, pairs with --design)",
    )
    parser.add_argument(
        "--base",
        action="append",
        default=[],
        help="qor.json from the yosys baseline run (repeat, pairs with --design)",
    )
    args = parser.parse_args()
    if not (len(args.design) == len(args.syn) == len(args.base)):
        parser.error("--design/--syn/--base must be given the same number of times")
    if not args.design:
        parser.error("at least one --design/--syn/--base triple is required")
    return args


def load_qor(path):
    """Load a qor.json; returns (metrics_dict, failed)."""
    try:
        with open(path) as f:
            data = json.load(f)
    except (OSError, json.JSONDecodeError) as e:
        print(f"[WARN] treating {path} as failed: {e}", file=sys.stderr)
        return {}, True
    return data, bool(data.get("orfs_qor_failed"))


def get_number(metrics, key):
    value = metrics.get(key)
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return float(value)
    return None


def percent_delta(syn, base):
    if syn is None or base is None or base == 0:
        return None
    return 100.0 * (syn - base) / abs(base)


# Panel definitions: (title, y-axis label, function(syn_metrics,
# base_metrics) -> value or None). Percent panels: negative = SYN smaller.
def _area_delta(syn, base):
    return percent_delta(
        get_number(syn, "synth__design__instance__area__stdcell"),
        get_number(base, "synth__design__instance__area__stdcell"),
    )


def _count_delta(syn, base):
    return percent_delta(
        get_number(syn, "synth__design__instance__count__stdcell"),
        get_number(base, "synth__design__instance__count__stdcell"),
    )


def runtime_seconds(metrics):
    """Synthesis runtime in seconds: synth__elapsed_seconds when numeric,
    else gnu-time's synth__runtime__total ("[H:]M:SS.frac")."""
    value = get_number(metrics, "synth__elapsed_seconds")
    if value is not None:
        return value
    total = metrics.get("synth__runtime__total")
    if not isinstance(total, str):
        return None
    parts = total.split(":")
    try:
        seconds = float(parts[-1])
        if len(parts) > 1:
            seconds += 60 * int(parts[-2])
        if len(parts) > 2:
            seconds += 3600 * int(parts[-3])
    except ValueError:
        return None
    return seconds


def _runtime_delta(syn, base):
    return percent_delta(runtime_seconds(syn), runtime_seconds(base))


def _syn_ws(syn, base):
    return get_number(syn, "synth__timing__setup__ws")


PANELS = [
    (
        "Std-cell area, SYN vs yosys",
        "Δ area (%)",
        _area_delta,
        "delta",
        False,
    ),
    (
        "Std-cell instance count, SYN vs yosys",
        "Δ instances (%)",
        _count_delta,
        "delta",
        False,
    ),
    (
        "Synthesis runtime, SYN vs yosys",
        "Δ runtime (%)",
        _runtime_delta,
        "delta",
        False,
    ),
    (
        "OpenROAD-SYN setup worst slack after synthesis "
        "(no yosys equivalent metric)",
        "WS (ps)",
        _syn_ws,
        "absolute",
        True,
    ),
]


def bar_color(value, kind, higher_is_better):
    if kind == "absolute":
        return NEUTRAL
    if abs(value) <= NEUTRAL_BAND:
        return NEUTRAL
    improved = value > 0 if higher_is_better else value < 0
    return BETTER if improved else WORSE


def render_runtime_ab(path, title, loaded):
    """Absolute synthesis runtime A/B: yosys vs OpenROAD-SYN per design.

    Grouped bars on a log axis (runtimes span seconds to hours across the
    suite). A failed side renders as a hatched marker column instead of a
    bar. Note the yosys number is the main yosys step (canonicalization
    excluded), the SYN number is the whole synth_syn.tcl run.
    """
    designs = [entry[0] for entry in loaded]
    n = len(designs)
    fig, ax = plt.subplots(figsize=(max(8.0, 0.75 * n + 2.0), 5.0), dpi=120)
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)

    width = 0.38
    finite = []
    for _, syn, syn_failed, base, base_failed in loaded:
        for metrics, failed in [(base, base_failed), (syn, syn_failed)]:
            value = None if failed else runtime_seconds(metrics)
            if value:
                finite.append(value)
    for i, (name, syn, syn_failed, base, base_failed) in enumerate(loaded):
        for offset, metrics, failed, color in [
            (-width / 2, base, base_failed, SERIES_YOSYS),
            (width / 2, syn, syn_failed, SERIES_SYN),
        ]:
            value = None if failed else runtime_seconds(metrics)
            if value is None:
                ax.text(
                    i + offset,
                    0.5,
                    "FAIL" if failed else "n/a",
                    transform=blended_transform_factory(ax.transData, ax.transAxes),
                    rotation=90,
                    ha="center",
                    va="center",
                    fontsize=7,
                    color=FAIL_EDGE,
                    zorder=3,
                )
            else:
                ax.bar(i + offset, value, width=width, color=color, zorder=2)
                ax.text(
                    i + offset,
                    value * 1.08,
                    f"{value:.0f}" if value >= 10 else f"{value:.1f}",
                    ha="center",
                    va="bottom",
                    fontsize=7,
                    color=TEXT_PRIMARY,
                    zorder=3,
                )

    ax.set_yscale("log")
    if finite:
        # Explicit headroom so on-bar value labels stay inside the axes;
        # ax.margins is additive and misbehaves on a log scale.
        ax.set_ylim(min(finite) / 1.6, max(finite) * 1.6)
    for set_formatter in [ax.yaxis.set_major_formatter, ax.yaxis.set_minor_formatter]:
        formatter = ScalarFormatter()
        formatter.set_scientific(False)
        set_formatter(formatter)
    ax.set_ylabel(
        "synthesis runtime (s, log) — yosys main step vs whole SYN run",
        fontsize=9,
        color=TEXT_SECONDARY,
    )
    ax.set_xticks(range(n))
    ax.set_xticklabels(designs, rotation=45, ha="right", fontsize=8)
    ax.grid(axis="y", which="both", color="#e5e4e0", linewidth=0.6, zorder=0)
    ax.tick_params(colors=TEXT_SECONDARY, labelsize=8)
    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.set_title(title, fontsize=11, color=TEXT_PRIMARY, loc="left")
    ax.legend(
        [
            plt.Rectangle((0, 0), 1, 1, color=SERIES_YOSYS),
            plt.Rectangle((0, 0), 1, 1, color=SERIES_SYN),
        ],
        ["yosys", "OpenROAD-SYN"],
        loc="upper left",
        fontsize=8,
        frameon=False,
    )
    fig.tight_layout()
    fig.savefig(path, facecolor=fig.get_facecolor())
    print(f"Wrote {path}")


def main():
    args = parse_args()

    designs = args.design
    loaded = []
    for name, syn_path, base_path in zip(designs, args.syn, args.base):
        syn, syn_failed = load_qor(syn_path)
        base, base_failed = load_qor(base_path)
        loaded.append((name, syn, syn_failed, base, base_failed))

    n = len(designs)
    x = range(n)
    fig, axes = plt.subplots(
        len(PANELS),
        1,
        figsize=(max(8.0, 0.75 * n + 2.0), 3.0 * len(PANELS)),
        sharex=True,
        dpi=120,
    )
    fig.patch.set_facecolor(SURFACE)

    for ax, (title, ylabel, fn, kind, higher_is_better) in zip(axes, PANELS):
        ax.set_facecolor(SURFACE)
        values = []
        for name, syn, syn_failed, base, base_failed in loaded:
            values.append(None if (syn_failed or base_failed) else fn(syn, base))

        finite = [v for v in values if v is not None]
        span = max((abs(v) for v in finite), default=1.0) or 1.0

        for i, ((name, syn, syn_failed, base, base_failed), value) in enumerate(
            zip(loaded, values)
        ):
            if syn_failed or base_failed:
                # Hatched full-height FAIL column: the point of this graph
                # is to show failures, not hide them.
                ax.axvspan(
                    i - 0.4,
                    i + 0.4,
                    facecolor=FAIL_FACE,
                    edgecolor=FAIL_EDGE,
                    hatch="//",
                    linewidth=0.6,
                    zorder=1,
                )
                which = "SYN" if syn_failed else "yosys"
                if syn_failed and base_failed:
                    which = "both"
                # x in data coords, y centered in the panel regardless of
                # the y-range, so the label never clips at a panel edge.
                ax.text(
                    i,
                    0.5,
                    f"{which} FAIL",
                    transform=blended_transform_factory(ax.transData, ax.transAxes),
                    rotation=90,
                    ha="center",
                    va="center",
                    fontsize=7,
                    color=FAIL_EDGE,
                    zorder=3,
                )
            elif value is None:
                ax.text(
                    i,
                    0.5,
                    "n/a",
                    transform=blended_transform_factory(ax.transData, ax.transAxes),
                    rotation=90,
                    ha="center",
                    va="center",
                    fontsize=7,
                    color=TEXT_SECONDARY,
                    zorder=3,
                )
            else:
                ax.bar(
                    i,
                    value,
                    width=0.66,
                    color=bar_color(value, kind, higher_is_better),
                    zorder=2,
                )
                offset = 0.04 * span
                ax.text(
                    i,
                    value + (offset if value >= 0 else -offset),
                    f"{value:+.1f}" if kind == "delta" else f"{value:.0f}",
                    ha="center",
                    va="bottom" if value >= 0 else "top",
                    fontsize=7,
                    color=TEXT_PRIMARY,
                    zorder=3,
                )

        ax.axhline(0, color=TEXT_SECONDARY, linewidth=0.8, zorder=2)
        ax.set_title(title, fontsize=10, color=TEXT_PRIMARY, loc="left")
        ax.set_ylabel(ylabel, fontsize=9, color=TEXT_SECONDARY)
        ax.margins(y=0.18)
        ax.grid(axis="y", color="#e5e4e0", linewidth=0.6, zorder=0)
        ax.tick_params(colors=TEXT_SECONDARY, labelsize=8)
        for spine in ax.spines.values():
            spine.set_visible(False)

    axes[-1].set_xticks(list(x))
    axes[-1].set_xticklabels(designs, rotation=45, ha="right", fontsize=8)

    fig.suptitle(args.title, fontsize=12, color=TEXT_PRIMARY)
    handles = [
        plt.Rectangle((0, 0), 1, 1, color=BETTER),
        plt.Rectangle((0, 0), 1, 1, color=WORSE),
        plt.Rectangle((0, 0), 1, 1, color=NEUTRAL),
        plt.Rectangle(
            (0, 0),
            1,
            1,
            facecolor=FAIL_FACE,
            edgecolor=FAIL_EDGE,
            hatch="//",
        ),
    ]
    fig.legend(
        handles,
        [
            "SYN better",
            "SYN worse",
            f"within ±{NEUTRAL_BAND:g}% / absolute",
            "synthesis failed",
        ],
        loc="upper right",
        fontsize=8,
        frameon=False,
    )
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    fig.savefig(args.output, facecolor=fig.get_facecolor())
    print(f"Wrote {args.output}")

    if args.runtime_output:
        render_runtime_ab(
            args.runtime_output,
            "Synthesis runtime A/B: yosys vs OpenROAD-SYN (asap7)",
            loaded,
        )


if __name__ == "__main__":
    main()
