#!/usr/bin/env python3
"""Plot effective clock period across flow stages from rules-*.json.

For every design, rules-base.json carries the QoR-gated setup worst
slack of the design's regular flow at the synth/cts/globalroute/finish
stages, and rules-syn.json carries the OpenROAD-SYN synthesis-only
gate. Effective period = clock period - worst slack, i.e. the period
the design would need to meet timing. One line per design (regular
flow), with the OpenROAD-SYN post-synthesis point overlaid as a diamond
so the two synthesis engines can be compared without running any flow.

The values are QoR gates (padded by genRuleFile.py), not measurements —
both engines are padded identically, so the comparison is fair, but the
absolute numbers include rule margin.

Usage:
  plotClockPeriod.py --output png \\
      --design gcd --rules-base .../rules-base.json --rules-syn .../rules-syn.json \\
      [--design ... --rules-base ... --rules-syn ...]

Deterministic output (Agg backend, fixed geometry, no timestamps).
"""

import argparse
import json
import sys

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.ticker import ScalarFormatter  # noqa: E402

STAGES = ["synth", "cts", "globalroute", "finish"]

TEXT_PRIMARY = "#0b0b0b"
TEXT_SECONDARY = "#52514e"
SURFACE = "#fcfcfb"
SYN_MARKER_EDGE = "#0b0b0b"


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="Output PNG path")
    parser.add_argument(
        "--title",
        default="Effective clock period across stages (rules-*.json gates, asap7)",
        help="Figure title",
    )
    parser.add_argument("--design", action="append", default=[], help="Design name")
    parser.add_argument(
        "--rules-base", action="append", default=[], help="rules-base.json path"
    )
    parser.add_argument(
        "--rules-syn", action="append", default=[], help="rules-syn.json path"
    )
    args = parser.parse_args()
    if not (len(args.design) == len(args.rules_base) == len(args.rules_syn)):
        parser.error(
            "--design/--rules-base/--rules-syn must be given the same number of times"
        )
    if not args.design:
        parser.error("at least one design is required")
    return args


def load_rules(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError) as e:
        print(f"[WARN] cannot read {path}: {e}", file=sys.stderr)
        return {}


def rule_number(rules, field):
    rule = rules.get(field)
    if not rule:
        return None
    value = rule.get("value")
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return float(value)
    return None


def main():
    args = parse_args()

    fig, ax = plt.subplots(figsize=(9.0, 7.0), dpi=120)
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)

    cmap = plt.get_cmap("tab20")
    x = range(len(STAGES))
    skipped = []
    plotted = 0

    for idx, (design, base_path, syn_path) in enumerate(
        zip(args.design, args.rules_base, args.rules_syn)
    ):
        base = load_rules(base_path)
        syn = load_rules(syn_path)
        period = rule_number(syn, "constraints__clocks__period") or rule_number(
            base, "constraints__clocks__period"
        )
        if period is None:
            skipped.append(design)
            continue

        color = cmap(idx % 20)
        ys = [
            (
                period - ws
                if (ws := rule_number(base, f"{stage}__timing__setup__ws")) is not None
                else None
            )
            for stage in STAGES
        ]
        xs = [i for i, y in zip(x, ys) if y is not None]
        vals = [y for y in ys if y is not None]
        if vals:
            ax.plot(
                xs,
                vals,
                marker="o",
                markersize=4,
                linewidth=1.6,
                color=color,
                zorder=2,
            )
            # Direct label at the line end; text in ink, mark carries color.
            ax.annotate(
                design,
                (xs[-1], vals[-1]),
                textcoords="offset points",
                xytext=(6, 0),
                fontsize=7,
                color=TEXT_PRIMARY,
                va="center",
                zorder=3,
            )
            plotted += 1

        syn_ws = rule_number(syn, "synth__timing__setup__ws")
        if syn_ws is not None:
            ax.plot(
                [0],
                [period - syn_ws],
                marker="D",
                markersize=7,
                linestyle="none",
                markerfacecolor=color,
                markeredgecolor=SYN_MARKER_EDGE,
                markeredgewidth=0.8,
                zorder=4,
            )

    ax.set_xticks(list(x))
    ax.set_xticklabels(STAGES, fontsize=9)
    ax.set_yscale("log")
    for set_formatter in [ax.yaxis.set_major_formatter, ax.yaxis.set_minor_formatter]:
        formatter = ScalarFormatter()
        formatter.set_scientific(False)
        set_formatter(formatter)
    ax.set_ylabel("effective clock period: target - worst slack (ps, log)", fontsize=9)
    ax.grid(axis="y", which="both", color="#e5e4e0", linewidth=0.6, zorder=0)
    ax.tick_params(colors=TEXT_SECONDARY, labelsize=8)
    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.margins(x=0.12)

    title = args.title
    if skipped:
        title += "\n(no period rule yet: {})".format(", ".join(skipped))
    ax.set_title(title, fontsize=11, color=TEXT_PRIMARY, loc="left")

    handles = [
        plt.Line2D([], [], marker="o", linewidth=1.6, color=TEXT_SECONDARY),
        plt.Line2D(
            [],
            [],
            marker="D",
            linestyle="none",
            markersize=7,
            markerfacecolor=SURFACE,
            markeredgecolor=SYN_MARKER_EDGE,
        ),
    ]
    ax.legend(
        handles,
        ["regular flow (rules-base.json)", "OpenROAD-SYN synth (rules-syn.json)"],
        loc="upper right",
        fontsize=8,
        frameon=False,
    )

    fig.tight_layout()
    fig.savefig(args.output, facecolor=fig.get_facecolor())
    print(f"Wrote {args.output} ({plotted} designs, {len(skipped)} skipped)")


if __name__ == "__main__":
    main()
