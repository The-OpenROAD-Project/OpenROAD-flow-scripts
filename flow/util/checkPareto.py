#!/usr/bin/env python3

"""Check whether a run moved the QoR Pareto front in a good direction.

`checkMetadata.py` answers a different question, and answers it well:
"did anything get worse than a bound we set". Its bounds carry generous
margin -- 15% on area, 5% of the clock period on worst slack -- so it
tolerates drift, which is what a regression guard should do.

What it cannot express is a *trade*. A change that shrinks the core 8%
and gives up 1% of worst slack fails the slack rule and says nothing at
all about the area rule it just improved. Read literally it reports a
regression; read honestly it is a point that moved along the front. The
two are not distinguishable from `rules-base.json` alone, because the
file records padded thresholds rather than measurements.

So this reads the `golden` values that `genRuleFile.py` now records
next to those thresholds -- the unpadded numbers actually measured --
treats them as a point in KPI space, and asks where the new point sits
relative to it:

  * a **hard constraint** regression (DRC, placement violations, antenna)
    fails outright, no tie band, no trade. These are not axes you are
    allowed to spend.
  * **losing timing closure** -- crossing from meeting the constraint to
    missing it -- fails outright. That is a change in kind, not a Pareto
    cost, and no amount of area buys it back.
  * otherwise the new point fails only if it is **dominated**: every
    axis worse-or-tied and at least one worse beyond its tie band. A
    genuine trade -- better on one axis, worse on another -- passes, and
    the trade is printed.

`--require-improvement` additionally demands at least one axis improve
beyond its tie band, which is what you want when gating a change that is
*supposed* to move the front rather than merely not wreck it.

Tie bands come from the `tie` field when present, and otherwise from
conservative defaults below. A band that came from a real noise
measurement is worth far more than these defaults; where one exists,
record it in the rules file so the verdict is measured rather than
assumed.
"""

import argparse
import json
import sys

# axis -> (metric, direction, default fractional tie band); "down" means
# smaller is better. The defaults are deliberately not tight: an
# unmeasured band should not manufacture confident verdicts.
#
# The period axis is the ACHIEVED PERIOD (clock - WNS), never WNS itself.
#
# WNS is a signed quantity that lives near zero, so a fractional change in
# it is meaningless: a design at +5.8 ps that moves to +0.9 ps has "lost
# 85%" of nothing, while one at -274 ps that moves to -280 ps has "lost
# 2%" of a great deal. Both readings are noise dressed as precision, and
# a tie band expressed as a fraction of WNS is correspondingly absurd --
# tight where WNS is small, loose where it is large, for no reason
# connected to the design.
#
# clock - WNS is a stable positive quantity of order the clock period, so
# a fractional change in it means what it appears to mean, and a tie band
# expressed as a fraction of it is a fraction of the clock. This is the
# same convention genRuleFile.py already uses for its timing rules
# ("period_padding": pad by a percentage of the clock, not of the slack).
#
# TNS is deliberately NOT an axis. It is unbounded below, frequently
# exactly zero, and its scale depends on the endpoint count, so it has
# the same pathology as WNS and worse. It stays a diagnostic.
AXES = [
    ("period", None, "down", 0.005),  # synthesised: clock - WNS
    ("core_area", "finish__design__core__area", "down", 0.015),
    ("cell_area", "finish__design__instance__area", "down", 0.015),
    ("power", "finish__power__total", "down", 0.05),
]

WNS = "finish__timing__setup__ws"

# Regressions here are never a trade.
HARD = [
    "detailedroute__route__drc_errors",
    "detailedplace__design__violations",
    "detailedroute__antenna__violating__nets",
]

# Reported next to the verdict, never gated: these are how a flow buys
# timing when you are not looking (more repair, more runtime, more wire).
DIAGNOSTIC = [
    "finish__timing__setup__tns",
    "detailedroute__route__wirelength",
    "cts__design__instance__count__setup_buffer",
    "cts__design__instance__count__hold_buffer",
]

# Closure is judged on WNS, and on WNS alone: "does this design meet its
# constraint" is a discrete fact about the sign, not a magnitude, and it
# is the one question the achieved period cannot answer.
CLOSURE = WNS


def clock_period(meta):
    """The first clock's period, as genRuleFile.py reads it."""
    details = meta.get("constraints__clocks__details")
    if isinstance(details, list) and details:
        first = details[0]
        if isinstance(first, (int, float)):
            return float(first)
        if isinstance(first, str):
            for tok in first.split():
                try:
                    return float(tok)
                except ValueError:
                    continue
    return None


def num(v):
    if isinstance(v, bool) or not isinstance(v, (int, float)):
        return None
    return float(v)


def classify(base, new, direction, tie):
    """improved / tied / regressed, plus the fractional delta."""
    if base == 0:
        delta = 0.0 if new == base else (1.0 if new > base else -1.0)
    else:
        delta = (new - base) / abs(base)
    better = (new > base) if direction == "up" else (new < base)
    if abs(delta) <= tie:
        return "tied", delta
    return ("improved" if better else "regressed"), delta


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--metadata", "-m", required=True)
    src = ap.add_mutually_exclusive_group(required=True)
    src.add_argument(
        "--baseline",
        "-b",
        help="metadata.json measured on the unmodified design. Preferred: "
        "both arms are then measured on the same toolchain on the same "
        "day, which is the only comparison that isolates the change.",
    )
    src.add_argument(
        "--rules",
        "-r",
        help="rules-base.json, using its 'golden' values as the baseline. "
        "Only sound if the file was regenerated on the current toolchain: "
        "checked-in rules lag the flow by however long since the last "
        "'update rules', and that drift lands in the same diff as the "
        "change under test. On asap7 the drift has been observed at 9 ps "
        "of setup slack over six weeks, the same size as the effects "
        "being measured.",
    )
    ap.add_argument(
        "--require-improvement",
        action="store_true",
        help="also fail unless at least one axis improves beyond its tie band",
    )
    args = ap.parse_args()

    with open(args.metadata) as f:
        meta = json.load(f)

    # Both sources are reduced to the same two lookups, so the checks below
    # do not care which one is in play: base_of() gives the baseline value
    # for a metric, tie_of() its noise band and where that band came from.
    if args.baseline:
        with open(args.baseline) as f:
            base_meta = json.load(f)
        source = f"measured baseline {args.baseline}"

        def base_of(field):
            return num(base_meta.get(field))

        def tie_of(field, default_tie):
            return default_tie, "default"

    else:
        with open(args.rules) as f:
            rules = json.load(f)
        source = f"golden values in {args.rules}"

        def base_of(field):
            rule = rules.get(field)
            if not rule or "golden" not in rule:
                return None
            return num(rule["golden"])

        def tie_of(field, default_tie):
            rule = rules.get(field) or {}
            if "tie" in rule:
                return rule["tie"], "measured"
            return default_tie, "default"

    errors = []
    notes = []

    # --- hard constraints ------------------------------------------------
    for field in HARD:
        b, n = base_of(field), num(meta.get(field))
        if b is None or n is None:
            continue
        if n > b:
            errors.append(f"{field}: {b:g} -> {n:g} (hard constraint, never a trade)")
        else:
            notes.append(f"[ok]   {field:52s} {b:g} -> {n:g}")

    # --- timing closure --------------------------------------------------
    b, n = base_of(CLOSURE), num(meta.get(CLOSURE))
    if b is not None and n is not None and b >= 0 > n:
        errors.append(
            f"{CLOSURE}: {b:g} -> {n:g} (was meeting the constraint, now "
            "missing it; that is a change in kind, not a Pareto cost)"
        )

    # --- Pareto axes -----------------------------------------------------
    improved, regressed, tied, missing = [], [], [], []
    period = clock_period(meta)
    for name, field, direction, default_tie in AXES:
        if name == "period":
            # Synthesised from the clock and WNS rather than read directly.
            gb, gn = base_of(WNS), num(meta.get(WNS))
            if gb is None or gn is None or period is None:
                missing.append(name)
                continue
            b, n = period - gb, period - gn
            tie_field = WNS
            field = f"{WNS} -> achieved period (clock {period:g})"
        else:
            b, n = base_of(field), num(meta.get(field))
            if b is None or n is None:
                missing.append(name)
                continue
            tie_field = field
        tie, src = tie_of(tie_field, default_tie)
        verdict, delta = classify(b, n, direction, tie)
        line = (
            f"{name:11s} {field:44s} {b:12.6g} -> {n:12.6g} "
            f"{100 * delta:+7.2f}%  {verdict} (tie {100 * tie:.1f}% {src})"
        )
        notes.append("       " + line)
        {"improved": improved, "regressed": regressed, "tied": tied}[verdict].append(
            name
        )

    for field in DIAGNOSTIC:
        b, n = base_of(field), num(meta.get(field))
        if b is None or n is None or b == 0:
            continue
        notes.append(
            f"[diag] {field:52s} {b:12.6g} -> {n:12.6g} "
            f"{100 * (n - b) / abs(b):+7.2f}%"
        )

    print(f"Pareto check against {source}")
    print("-" * 78)
    for line in notes:
        print(line)
    print("-" * 78)

    if missing:
        print(
            f"[WARN] no baseline value for: {', '.join(missing)} — "
            "run <design>_update to record them, or pass --baseline"
        )

    # Dominated: nothing improved, something regressed.
    dominated = bool(regressed) and not improved
    if dominated:
        errors.append(
            "point is dominated: "
            f"{', '.join(regressed)} regressed and no axis improved"
        )

    if improved and regressed:
        print(
            f"[INFO] trade: {', '.join(improved)} improved, "
            f"{', '.join(regressed)} regressed — this is a move along the "
            "front, not a regression"
        )
    elif improved:
        print(f"[INFO] strict improvement on: {', '.join(improved)}")
    elif not regressed:
        print("[INFO] every axis within its tie band — no measurable movement")

    if args.require_improvement and not improved and not errors:
        errors.append(
            "--require-improvement: no axis improved beyond its tie band"
        )

    for e in errors:
        print(f"[ERROR] {e}")

    if errors:
        print("Pareto check FAILED")
        sys.exit(1)
    print("Pareto check passed")


if __name__ == "__main__":
    main()
