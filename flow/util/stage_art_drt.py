"""Detailed route: does the DRC count converge to zero, and what and where
are the violations that are left."""

import math
import re

from stage_art import (
    Frame,
    indent,
    panel,
    si,
)


@panel(stems=["5_2_route"], tools=["DRT"])
def panel_detail_route(doc, st):
    """Detailed routing: does the DRC count converge to zero, and where
    and what are the ones that are left."""
    iters = []
    for k, v in st.metrics.items():
        m = re.match(r"route__drc_errors__iter:(\d+)$", k)
        if m and isinstance(v, (int, float)):
            iters.append((int(m.group(1)), int(v)))
    iters.sort()
    final = st.metrics.get("route__drc_errors")
    if not iters and final is None:
        return None, None
    peak = max([n for _, n in iters] + [1])
    shown = iters if len(iters) <= 12 else iters[:6] + [None] + iters[-5:]
    width = 30
    doc.add((" DRC violations per iteration (log scale)", "bold"))
    for item in shown:
        if item is None:
            doc.add(("   ...", "dim"))
            continue
        it, n = item
        frac = math.log10(n + 1) / math.log10(peak + 1)
        doc.add(
            "  it%-3d " % it,
            ("#" * int(round(frac * width)), "red" if n else "green"),
            " %d" % n,
        )
    wl = st.metrics.get("route__wirelength")
    vias = st.metrics.get("route__vias")
    doc.add(" wirelength %sum  vias %s" % (si(wl), si(vias)))
    reason, gui = None, None
    drc = st.probe("drc") or []
    if final:
        reason = "%d DRC violations left after %d iterations" % (final, len(iters))
        top = sorted(drc, key=lambda c: -c["count"])[:4]
        if top:
            doc.add(
                (" by type: ", "bold"),
                ", ".join("%s x%d" % (c["name"], c["count"]) for c in top),
            )
        die = st.probe("die")
        cong, _ = st.earlier_probe("congestion")
        points = [p for c in drc for p in c.get("at", [])]
        if die and points:
            frame = Frame(die["die"], doc.rich, max_w=40, max_h=12)
            if cong and cong.get("map"):
                frame.heat(cong["map"], 1.0)
            for x, y in points:
                frame.mark(x, y, "x", "marker")
            doc.add((" x = DRC, over global route congestion", "dim"))
            doc.extend(indent(frame.lines()))
        gui = "make gui_5_2_route; DRC Viewer; start with %s" % (
            top[0]["name"] if top else "the first marker"
        )
    elif len(iters) > 20:
        reason = "took %d iterations to reach 0 DRCs" % len(iters)
    return reason, gui
