#!/usr/bin/env python3

"""Write the floorplan values AUTO_FLOORPLAN derived into a design's config.mk.

The config.mk DSL is where a design's values live, so that is where these
land -- as ordinary variables, indistinguishable from hand-written ones.
Somebody reading a config.mk to understand a design should not have to
care which numbers were typed and which were measured; the provenance
belongs in the commit that this run produces, not in the file.

So: no generated block, no markers, no "do not edit" banner. An existing
assignment is updated in place, keeping its position, spacing and
assignment operator. A variable the design does not set yet is appended
next to the ones it does.

That makes bringing up a new design a two-step job: wire up the strictly
necessary variables in config.mk -- the sources, the SDC, the platform --
and let this fill in the floorplan.

Usage (via the generated bazel target):
    bazelisk run //flow/designs/<platform>/<design>:<name>_auto_floorplan_pin
"""

import argparse
import json
import os
import re
import sys

# The outline, in the two forms a config.mk can state it. Which one gets
# written is decided by the design: whichever it already uses, and the
# utilization form for a design that states neither yet.
RECT_VARS = ["DIE_AREA", "CORE_AREA"]
UTIL_VARS = ["CORE_UTILIZATION", "CORE_ASPECT_RATIO", "CORE_MARGIN"]

# Density, in the two forms it can be stated -- and exactly ONE of them is
# written.
#
# They are not additive: place_density_with_lb_addon() returns the addon
# form whenever PLACE_DENSITY_LB_ADDON is set and non-empty, and only
# falls back to PLACE_DENSITY otherwise. Writing both leaves a dead
# PLACE_DENSITY in the file and, worse, hands the flow an addon that gets
# re-resolved against a lower bound computed at run time -- which need not
# reproduce the absolute density that was actually measured.
#
# A design that already states an addon keeps stating one. Anything else,
# including a design that states neither, gets the absolute density: a pin
# should reproduce a measurement, not re-derive it.
ADDON_VAR = "PLACE_DENSITY_LB_ADDON"
DENSITY_VAR = "PLACE_DENSITY"

# evidence key for each variable
KEYS = {
    "DIE_AREA": "die_rect",
    "CORE_AREA": "core_rect",
    "CORE_UTILIZATION": "util",
    "CORE_ASPECT_RATIO": "aspect",
    "CORE_MARGIN": "margin",
    "PLACE_DENSITY_LB_ADDON": "addon",
    "PLACE_DENSITY": "density",
}


def assignment_re(var):
    """Match `export VAR = value`, `VAR ?= value`, and the spacing variants.

    Captures the text up to and including the operator so it can be put
    back verbatim -- a pin should change a value, not reformat the file.
    """
    return re.compile(
        r"(?m)^(\s*(?:export\s+)?" + re.escape(var) + r"\s*(?::=|\?=|\+=|=))([^\n]*)$"
    )


def find_assignment(text, var):
    m = assignment_re(var).search(text)
    return m if m else None


def format_value(val):
    if isinstance(val, float):
        # 6 significant digits: enough to reproduce the geometry, short
        # enough to read. Trailing zeros are noise in a config.mk.
        return f"{val:.6g}"
    return str(val)


def set_variable(text, var, value):
    """Update an existing assignment in place, or return None if absent."""
    m = find_assignment(text, var)
    if not m:
        return None
    # Preserve the original spacing after the operator where there was any.
    lead = " " if m.group(2).startswith(" ") else " "
    return text[: m.start(2)] + lead + format_value(value) + text[m.end(2) :]


def append_variables(text, pairs, anchor_vars):
    """Append assignments after the last floorplan variable the design sets.

    Keeps related settings together rather than scattering them at the end
    of the file, which is what a person would do by hand.
    """
    if not pairs:
        return text
    end = None
    for var in anchor_vars:
        m = find_assignment(text, var)
        if m and (end is None or m.end() > end):
            end = m.end()
    block = "".join(f"export {v} = {format_value(val)}\n" for v, val in pairs)
    if end is None:
        sep = "" if text.endswith("\n") else "\n"
        return text + sep + block
    return text[: end + 1] + block + text[end + 1 :]


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


def plan(config_text, winner):
    """Which variables to write, in which form.

    A design that states an explicit rectangle keeps stating one; anything
    else gets the utilization form, which is also what a design stating
    neither yet is given -- it adapts as the netlist grows, where a
    rectangle would silently change the utilization instead.
    """
    uses_rect = all(find_assignment(config_text, v) for v in RECT_VARS)
    outline = RECT_VARS if uses_rect else UTIL_VARS
    density = [ADDON_VAR] if find_assignment(config_text, ADDON_VAR) else [DENSITY_VAR]
    out = []
    for var in outline + density:
        val = winner.get(KEYS[var])
        if val is None or val == -1:
            continue
        out.append((var, val))
    return out, uses_rect


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
    winner = ev.get("winner")
    if not winner:
        sys.exit(
            "[ERROR] this run selected no winner (every candidate was "
            "eliminated, or the ladder did not resolve). There is nothing "
            "to pin; the design is already using its config.mk values."
        )

    with open(config_path) as f:
        before = f.read()

    pairs, uses_rect = plan(before, winner)
    text = before
    appended = []
    for var, val in pairs:
        updated = set_variable(text, var, val)
        if updated is None:
            appended.append((var, val))
        else:
            text = updated
    text = append_variables(
        text, appended, RECT_VARS + UTIL_VARS + [ADDON_VAR, DENSITY_VAR]
    )

    if text == before:
        print(f"[INFO] {args.config} already holds these values")
        return

    with open(config_path, "w") as f:
        f.write(text)

    # Provenance goes here, for the commit message -- not into the file.
    inc = ev.get("incumbent", {})
    period = ev.get("period", {})
    dt = ev.get("delta_tie")
    print(f"[INFO] {args.config}: wrote {', '.join(v for v, _ in pairs)}")
    print(f"[INFO]   form: {'DIE_AREA/CORE_AREA' if uses_rect else 'CORE_UTILIZATION'}")
    for var, val in pairs:
        mark = " (new)" if any(var == v for v, _ in appended) else ""
        print(f"[INFO]   {var} = {format_value(val)}{mark}")
    if isinstance(dt, (int, float)):
        print(f"[INFO]   measured noise floor (delta_tie): {dt:.4g}")
    tgt, ach = period.get("sdc_target"), period.get("achieved")
    if isinstance(tgt, (int, float)) and isinstance(ach, (int, float)):
        print(f"[INFO]   achieved {ach:.4g} against an SDC target of {tgt:.4g}")
    if inc.get("util") is not None:
        print(f"[INFO]   utilization was {inc['util']}")


if __name__ == "__main__":
    main()
