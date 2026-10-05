"""Global placement: cell density and wire demand (RUDY) on the die, and
how the placer converged."""

import re

from stage_art import (
    Frame,
    indent,
    mean,
    panel,
    side_by_side,
    si,
    sparkline,
)

GPL_ROW_RE = re.compile(r"^\s*(\d+) \|\s+([0-9.]+) \|\s+([0-9.e+]+) \|", re.MULTILINE)


@panel(stems=["3_3_place_gp"], tools=["GPL"])
def panel_global_place(doc, st):
    """Global placement: where the cells ended up (density) and how much
    wire they ask for there (RUDY), plus how the placer converged."""
    die = st.probe("die")
    density = st.probe("density")
    rudy = st.probe("rudy")
    rows = GPL_ROW_RE.findall(st.log)
    overflow = [float(r[1]) for r in rows]
    hpwl = [float(r[2]) for r in rows]
    if not die or not density:
        return None, None

    left = Frame(die["die"], doc.rich, max_w=30, max_h=14)
    left.heat(density, 1.0, mean)
    for m in st.probe("macros") or []:
        left.outline(m["box"], "outline")
    frames = [left.lines()]
    titles = [("cell density 0..100%", "bold")]
    rudy_max = max((max(r) for r in rudy), default=0.0) if rudy else 0.0
    if rudy and rudy_max > 0:
        right = Frame(die["die"], doc.rich, max_w=30, max_h=14)
        right.heat(rudy, rudy_max, mean)
        for m in st.probe("macros") or []:
            right.outline(m["box"], "outline")
        frames.append(right.lines())
        titles.append(("RUDY wire demand, relative", "bold"))
    head = [titles[0]]
    if len(titles) > 1:
        pad = sum(len(t) for t, _ in frames[0][0]) + 2 - len(titles[0][0])
        head += [(" " * pad, None), titles[1]]
    doc.add(" ", *head)
    body = frames[0] if len(frames) == 1 else side_by_side(frames[0], frames[1])
    doc.extend(indent(body))

    reasons = []
    if overflow:
        doc.add(
            " overflow %.2f " % overflow[0],
            (sparkline(overflow, doc.rich, lo=0.0), "cyan"),
            " %.3f after %d iterations" % (overflow[-1], int(rows[-1][0])),
        )
    if hpwl:
        doc.add(
            " HPWL     %s " % si(hpwl[0]),
            (sparkline(hpwl, doc.rich), "cyan"),
            " %sum" % si(hpwl[-1]),
        )
    target = re.findall(r"^global_placement .*-density (\S+)", st.log, re.MULTILINE)
    infl = st.metrics.get("gpl__area__routability_inflation__percent")
    td = st.metrics.get("gpl__area__timing_delta__percent")
    facts = []
    if target:
        facts.append("target density %s" % target[-1])
    if isinstance(td, (int, float)):
        facts.append("timing-driven area %+.1f%%" % td)
    if isinstance(infl, (int, float)):
        facts.append("routability inflation %+.1f%%" % infl)
    if facts:
        doc.add((" " + ", ".join(facts), None))
    if "GPL-0302" in st.log:
        reasons.append(
            "target density %s is below the design's minimum"
            % (target[-1] if target else "?")
        )
    if isinstance(infl, (int, float)) and infl > 20:
        reasons.append("routability inflated cell area %.0f%%" % infl)
    if overflow and overflow[-1] > 0.15 and not st.failed:
        reasons.append("ended at overflow %.2f, cells still overlap" % overflow[-1])
    gui = None
    if reasons or st.failed:
        target = "gui_3_3_place_gp-failed" if st.failed else "gui_3_3_place_gp"
        gui = "make %s; Heat Maps > Placement Density and RUDY" % target
    return (reasons[0] if reasons else None), gui
