"""Timing: endpoint slack histograms for setup and hold, and the stage
that cost the slack."""

from stage_art import indent, panel, side_by_side, si

# Stages that update timing; each shows its histograms when it matters.
TIMING_STAGES = [
    "2_1_floorplan",
    "3_3_place_gp",
    "3_4_place_resized",
    "3_5_place_dp",
    "4_1_cts",
    "5_1_grt",
    "6_report",
]

HEIGHT = 6


def histogram(doc, kind, bins, unit):
    """A vertical bar chart of endpoint slack: violating bins red, the
    rest green, with zero marked on the axis."""
    if not bins:
        return [[("%s: no constrained endpoints" % kind, "dim")]]
    counts = [n for _, _, n in bins]
    peak = max(counts) or 1
    width = 2 if len(bins) <= 16 else 1
    out = []
    total = sum(counts)
    violators = sum(n for lo, hi, n in bins if hi <= 0)
    title = "%s slack, %d endpoints" % (kind, total)
    if violators:
        title += ", %d < 0" % violators
    out.append([(title, "bold")])
    for level in range(HEIGHT, 0, -1):
        line = []
        for lo, hi, n in bins:
            filled = n * HEIGHT >= level * peak - peak / 2 and n > 0
            # A non-empty bin always shows, however small.
            if level == 1 and n > 0:
                filled = True
            line.append(
                ("#" * width if filled else " " * width, "red" if hi <= 0 else "green")
            )
        out.append(line)
    axis = []
    for lo, hi, n in bins:
        axis.append(("|" if lo == 0 else "-") + "-" * (width - 1))
    out.append([("".join(axis), "dim")])
    span = len(bins) * width
    left = si(bins[0][0])
    right = si(bins[-1][1]) + unit
    out.append([(left + " " * max(1, span - len(left) - len(right)) + right, "dim")])
    return out


@panel(stems=TIMING_STAGES)
def panel_timing(doc, st):
    timing = st.probe("timing")
    if not timing:
        return None, None
    unit = timing.get("time_unit", "")
    setup = timing.get("setup") or {}
    hold = timing.get("hold") or {}
    # A snapshot without histograms (not recorded) draws none, rather
    # than claiming there are no endpoints.
    if setup.get("histogram") is not None or hold.get("histogram") is not None:
        left = histogram(doc, "setup", setup.get("histogram"), unit)
        right = histogram(doc, "hold", hold.get("histogram"), unit)
        doc.extend(indent(side_by_side(left, right, gap=4)))

    reasons = []
    period = timing.get("period")
    ws = st.metrics.get("timing__setup__ws")
    prev = st.previous("timing__setup__ws")
    if period and isinstance(ws, (int, float)) and isinstance(prev, (int, float)):
        cost = prev - ws
        if cost > 0.1 * period:
            reasons.append(
                "this stage cost %s%s setup slack, %.0f%% of the %s%s clock"
                % (si(cost), unit, 100 * cost / period, si(period), unit)
            )
    if st.stem >= "4_1_cts" and hold.get("violators"):
        reasons.append("%d hold violations after CTS" % hold["violators"])
    if not reasons:
        return None, None
    return reasons[0], "make gui_%s; Timing Report, Charts > Endpoint Slack" % st.stem
