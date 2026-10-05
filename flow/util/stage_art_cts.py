"""Clock tree synthesis: each clock tree's shape (sinks, buffers, levels,
fanout), its skew, and how much hold repair it took."""

import re

from stage_art import bar, panel, si

NET_RE = re.compile(r'\[INFO CTS-0007\] Net "([^"]+)" found for clock "([^"]+)"')
TREE_RE = re.compile(
    r"\[INFO CTS-0027\] Generating H-Tree topology for net (\S+?)\.?$", re.M
)
BUILT_RE = re.compile(
    r"\[INFO CTS-0018\]\s+Created (\d+) clock buffers\.\s*\n"
    r"(?:.*\n)*?\[INFO CTS-0016\]\s+Fanout distribution for the current clock = (.*?)\.*\n"
    r"\[INFO CTS-0017\]\s+Max level of the clock tree: (\d+)"
)
SUMMARY_RE = re.compile(
    r'\[INFO CTS-0098\] Clock net "([^"]+)"\s*\n'
    r"\[INFO CTS-0099\]\s+Sinks (\d+)\s*\n"
    r"\[INFO CTS-0100\]\s+Leaf buffers (\d+)\s*\n"
    r"(?:.*\n)*?\[INFO CTS-0102\]\s+Path depth (\d+) - (\d+)"
)


def trees(log):
    """What CTS built per clock net: the summary it logs per net (sinks,
    leaf buffers, buffers from sink to root), plus the tree it built
    (buffers, fanout, levels). CTS generates every net's topology before
    building any, then builds them in the same order."""
    clocks = dict(NET_RE.findall(log))
    built = dict(zip(TREE_RE.findall(log), BUILT_RE.findall(log)))
    out = []
    for net, sinks, leaf, lo, hi in SUMMARY_RE.findall(log):
        tree = {
            "net": net,
            "clock": clocks.get(net),
            "sinks": int(sinks),
            "leaf_buffers": int(leaf),
            "depth": (int(lo), int(hi)),
            "buffers": None,
            "levels": None,
            "fanout": [],
        }
        if net in built:
            buffers, fanout, levels = built[net]
            tree["buffers"] = int(buffers)
            tree["levels"] = int(levels)
            tree["fanout"] = [
                tuple(int(x) for x in pair.split(":"))
                for pair in fanout.split(", ")
                if re.match(r"^\d+:\d+$", pair)
            ]
        out.append(tree)
    return out


@panel(stems=["4_1_cts"], tools=["CTS"])
def panel_cts(doc, st):
    built = trees(st.log)
    if not built:
        return None, None
    for t in built[:4]:
        depth = ""
        if t["depth"]:
            lo, hi = t["depth"]
            depth = (
                ", %d buffers sink to root" % lo
                if lo == hi
                else ", %d-%d buffers sink to root" % (lo, hi)
            )
        clock = " (clock %s)" % t["clock"] if t["clock"] else ""
        doc.add((" %s" % t["net"], "bold"), "%s: %d sinks" % (clock, t["sinks"]))
        doc.add(
            "   %s tree + %d leaf buffers, %s levels%s"
            % (si(t["buffers"]), t["leaf_buffers"], si(t["levels"]), depth)
        )
        if t["fanout"]:
            peak = max(n for _, n in t["fanout"])
            for fanout, n in t["fanout"][:5]:
                doc.add(
                    "   fanout %3d " % fanout, (bar(n / peak, 20), "cyan"), " x%d" % n
                )
    if len(built) > 4:
        doc.add(("   ... %d more clock nets" % (len(built) - 4), "dim"))

    timing = st.probe("timing") or {}
    period = timing.get("period")
    unit = timing.get("time_unit", "")
    skew = st.metrics.get("clock__skew__setup")
    hold_buffers = st.metrics.get("design__instance__count__hold_buffer")
    instances = st.metrics.get("design__instance__count")
    facts = []
    if isinstance(skew, (int, float)):
        facts.append("skew %s%s" % (si(skew), unit))
        if period:
            facts[-1] += " (%.0f%% of clock)" % (100 * skew / period)
    if isinstance(hold_buffers, (int, float)):
        facts.append("hold repair added %d buffers" % hold_buffers)
    if facts:
        doc.add(" " + ", ".join(facts))

    reasons = []
    if period and isinstance(skew, (int, float)) and skew > 0.1 * period:
        reasons.append(
            "clock skew is %.0f%% of the clock period" % (100 * skew / period)
        )
    if (
        isinstance(hold_buffers, (int, float))
        and instances
        and hold_buffers > 0.05 * instances
    ):
        reasons.append(
            "hold repair added %d buffers, %.0f%% of instances"
            % (hold_buffers, 100.0 * hold_buffers / instances)
        )
    for t in built:
        if t["depth"] and t["depth"][1] - t["depth"][0] > 2:
            reasons.append(
                "%s is unbalanced: %d-%d buffers sink to root" % (t["net"], *t["depth"])
            )
            break
    if not reasons:
        return None, None
    return reasons[0], "make gui_4_1_cts; Clock Tree Viewer"
