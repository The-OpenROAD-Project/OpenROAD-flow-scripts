#!/usr/bin/env python3

"""Pin the values AUTO_FLOORPLAN raced into a design's config.mk.

AUTO_FLOORPLAN measures the floorplan shape on every run, which is what
you want while the RTL is moving. It is not what you want at a tapeout:
sign-off needs a decision, not a measurement, and a decision is a number
written down and reviewed.

This turns the measurement into that decision. It reads the evidence a
floorplan run emitted, writes the winning coordinates into the design's
config.mk between generated markers, and sets AUTO_FLOORPLAN = 0 so the
flow uses them verbatim from then on. Re-running it updates the block in
place rather than appending a second one.

From there the usual last-ditch tools apply to a frozen netlist -- the
design's autotuner.json search space, a seed sweep -- because the values
are now ordinary config.mk entries with no machinery behind them.

Usage (via the generated bazel target):
    bazelisk run //flow/designs/<platform>/<design>:<name>_auto_floorplan_pin
"""

import argparse
import json
import os
import re
import sys

BEGIN = "# BEGIN AUTO_FLOORPLAN -- generated, do not edit by hand"
END = "# END AUTO_FLOORPLAN"

# Emitted in this order. CORE_UTILIZATION/CORE_ASPECT_RATIO/CORE_MARGIN
# describe the outline; PLACE_DENSITY_LB_ADDON and PLACE_DENSITY are the
# two forms of the density answer, and both are written so the block
# reads the same way whichever form the design used before.
FIELDS = [
    ("CORE_UTILIZATION", "util"),
    ("CORE_ASPECT_RATIO", "aspect"),
    ("CORE_MARGIN", "margin"),
    ("PLACE_DENSITY_LB_ADDON", "addon"),
    ("PLACE_DENSITY", "density"),
]


def extract_evidence(path):
    """Pull the evidence JSON out of a floorplan log, or read it directly.

    The floorplan stage echoes its evidence into the stage log between
    markers, because files written to REPORTS_DIR are not declared build
    outputs and a sandboxed build discards them. The log is a declared
    output, so it is the reliable source.
    """
    with open(path, errors="replace") as f:
        text = f.read()

    if "AUTO_FLOORPLAN-EVIDENCE-BEGIN" in text:
        blk = text.split("AUTO_FLOORPLAN-EVIDENCE-BEGIN")[-1]
        blk = blk.split("AUTO_FLOORPLAN-EVIDENCE-END")[0]
    else:
        blk = text

    try:
        return json.loads(blk)
    except json.JSONDecodeError as e:
        sys.exit(f"[ERROR] could not parse AUTO_FLOORPLAN evidence in {path}: {e}")


def uses_rectangle(config_text):
    """Does this config.mk state its floorplan as an explicit rectangle?

    AUTO_FLOORPLAN answers in whichever form the question was asked, so
    the pinned block has to match: rewriting a DIE_AREA design as a
    utilization silently re-derives its die, which is a change to the
    design rather than a record of a measurement.
    """
    return bool(
        re.search(r"(?m)^\s*export\s+DIE_AREA\s*=", config_text)
        and re.search(r"(?m)^\s*export\s+CORE_AREA\s*=", config_text)
    )


def render_block(ev, rectangle=False):
    winner = ev.get("winner")
    if not winner:
        sys.exit(
            "[ERROR] this run selected no winner (every candidate was "
            "eliminated, or the ladder did not resolve). There is nothing "
            "to pin; the design is already using its config.mk values."
        )

    period = ev.get("period", {})
    dt = ev.get("delta_tie")
    lines = [
        BEGIN,
        "#",
        "# Written by: bazelisk run //flow/designs/<platform>/<design>:"
        "<name>_auto_floorplan_pin",
        "# Regenerate by setting AUTO_FLOORPLAN = 1 and running it again.",
        "#",
        f"# Raced against a measured noise floor (delta_tie) of {dt:.4g}"
        if isinstance(dt, (int, float))
        else "#",
    ]
    tgt, ach = period.get("sdc_target"), period.get("achieved")
    if isinstance(tgt, (int, float)) and isinstance(ach, (int, float)) and tgt:
        gap = period.get("gap_in_delta_tie", -1)
        lines.append(
            f"# at the time of pinning: achieved {ach:.4g} against an SDC "
            f"target of {tgt:.4g}"
        )
        if isinstance(gap, (int, float)) and gap > 0:
            lines.append(
                f"# ({gap:.0f} noise floors short -- these values were "
                "explored, not signed off)"
            )
    lines.append("#")

    # The measured geometry, recorded either way: as the pinned values for
    # a rectangle design, and as a comment for a utilization one so a
    # reviewer can see the die the utilization implies without deriving it.
    die, core = winner.get("die_rect"), winner.get("core_rect")
    if die and core:
        lines.append(f"# measured die area  {die}")
        lines.append(f"# measured core area {core}")
        lines.append("#")

    if rectangle and die and core:
        lines.append(f"export DIE_AREA  = {die}")
        lines.append(f"export CORE_AREA = {core}")
        skip = {"CORE_UTILIZATION", "CORE_ASPECT_RATIO", "CORE_MARGIN"}
    else:
        skip = set()

    for var, key in FIELDS:
        if var in skip:
            continue
        val = winner.get(key)
        if val is None or val == -1:
            continue
        if isinstance(val, float):
            val = f"{val:.6g}"
        lines.append(f"export {var} = {val}")

    lines += [
        "",
        "# The values above are now ordinary config.mk entries. Turn the",
        "# measurement off so they are used verbatim.",
        "export AUTO_FLOORPLAN = 0",
        END,
    ]
    return "\n".join(lines) + "\n"


def splice(config_text, block):
    """Replace an existing generated block, or append a new one."""
    pattern = re.compile(
        re.escape(BEGIN) + r".*?" + re.escape(END) + r"\n?",
        re.DOTALL,
    )
    if pattern.search(config_text):
        return pattern.sub(block, config_text, count=1)
    sep = "" if config_text.endswith("\n") else "\n"
    return config_text + sep + "\n" + block


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("evidence", help="floorplan stage log, or evidence JSON")
    ap.add_argument("config", help="config.mk path, relative to the workspace")
    args = ap.parse_args()

    root = os.environ.get("BUILD_WORKSPACE_DIRECTORY")
    config_path = os.path.join(root, args.config) if root else args.config
    if not os.path.isfile(config_path):
        sys.exit(f"[ERROR] no config.mk at {config_path}")

    ev = extract_evidence(args.evidence)

    with open(config_path) as f:
        before = f.read()
    block = render_block(ev, rectangle=uses_rectangle(before))
    after = splice(before, block)

    if before == after:
        print(f"[INFO] {args.config} already pinned to these values")
        return

    with open(config_path, "w") as f:
        f.write(after)

    w = ev["winner"]
    inc = ev.get("incumbent", {})
    print(f"[INFO] pinned {args.config}")
    print(
        f"[INFO]   utilization {inc.get('util')} -> {w.get('util')}, "
        f"aspect {inc.get('aspect')} -> {w.get('aspect')}, "
        f"density -> {w.get('density'):.4g}"
    )
    print("[INFO] AUTO_FLOORPLAN = 0 was set: the flow now uses these verbatim.")


if __name__ == "__main__":
    main()
