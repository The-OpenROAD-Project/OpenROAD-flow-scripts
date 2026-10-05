"""Global route: routing demand against capacity on the die and per layer,
the worst hotspots, and what placement left there."""

from stage_art import (
    Frame,
    bar,
    heat_legend,
    indent,
    panel,
    side_by_side,
)


def distinct_hotspots(hotspots, die, n=3):
    """The worst hotspots, skipping ones next to a worse one already
    listed: three gcells of one hot spot say less than three spots."""
    near = 0.05 * max(die[2] - die[0], die[3] - die[1])
    out = []
    for h in hotspots:
        if all(abs(h["x"] - o["x"]) > near or abs(h["y"] - o["y"]) > near for o in out):
            out.append(h)
    return out[:n]


@panel(stems=["5_1_grt"], tools=["GRT"])
def panel_congestion(doc, st):
    """Global route congestion: where demand meets capacity, per layer
    and on the die, and what earlier stage put it there."""
    cong = st.probe("congestion")
    die = st.probe("die")
    if not cong or not die or not cong.get("layers"):
        return None, None
    layers = cong["layers"]
    frame = Frame(die["die"], doc.rich)
    frame.heat(cong["map"], 1.0)
    for m in st.probe("macros") or []:
        if m["placed"]:
            frame.outline(m["box"], "outline")
    over_map = cong.get("overflow_map") or []
    for r, row in enumerate(over_map):
        for c, n in enumerate(row):
            if n:
                x0, y0, x1, y1 = die["die"]
                frame.mark(
                    x0 + (c + 0.5) * (x1 - x0) / len(row),
                    y1 - (r + 0.5) * (y1 - y0) / len(over_map),
                    "X",
                    "over",
                )
    hotspots = distinct_hotspots(cong.get("hotspots", []), die["die"])
    for k, h in enumerate(hotspots):
        frame.mark(h["x"], h["y"], str(k + 1), "marker")

    right = [[("layer dir  use  %-12s over   >80%%" % "", "bold")]]
    for layer in layers:
        use = layer["usage"] / layer["capacity"] if layer["capacity"] else 0.0
        style = "bold red" if layer["overflow_gcells"] else None
        right.append(
            [
                ("%-6s%s " % (layer["name"][:6], layer["dir"][:1]), None),
                ("%3.0f%% " % (100 * use), style),
                (bar(min(use, 1.0), 12), "cyan"),
                (" %5d %6d" % (layer["overflow_gcells"], layer["hot_gcells"]), style),
            ]
        )
    total = sum(l["gcells"] for l in layers) or 1
    over = sum(l["overflow_gcells"] for l in layers)
    hot = sum(l["hot_gcells"] for l in layers)
    for d in ("HORIZONTAL", "VERTICAL"):
        dl = [l for l in layers if l["dir"] == d]
        if dl:
            n = sum(l["gcells"] for l in dl) or 1
            o = sum(l["overflow_gcells"] for l in dl)
            right.append(
                [
                    ("%s overflow %.2f%% of gcells" % (d[0], 100.0 * o / n), None),
                ]
            )
    right.append([("hot (>80%%) %.1f%% of gcells" % (100.0 * hot / total), None)])
    for k, h in enumerate(hotspots):
        right.append(
            [
                ("%d" % (k + 1), "bold white on #c00000" if doc.rich else None),
                (
                    " %s %.0f%% at (%.0f, %.0f)um"
                    % (h["layer"], 100 * h["ratio"], h["x"], h["y"]),
                    None,
                ),
            ]
        )
    if cong.get("stride", 1) > 1:
        right.append([("(sampled every %d gcells)" % cong["stride"], "dim")])

    doc.extend(indent(side_by_side(frame.lines(), right)))
    doc.add(*heat_legend(doc, "use/capacity, all layers", "100%"))

    reason = None
    if over:
        worst = max(layers, key=lambda l: l["worst"])
        reason = "%d gcells overflow, worst %.0f%% on %s" % (
            over,
            100 * worst["worst"],
            worst["name"],
        )
    if not reason and not st.failed:
        return None, None

    # Where did it start? Placement density under the worst hotspot.
    density, stem = st.earlier_probe("density")
    if hotspots and density:
        h = hotspots[0]
        x0, y0, x1, y1 = die["die"]
        rows, cols = len(density), len(density[0])
        c = min(cols - 1, int((h["x"] - x0) / (x1 - x0) * cols))
        r = min(rows - 1, int((y1 - h["y"]) / (y1 - y0) * rows))
        near = [
            density[rr][cc]
            for rr in range(max(0, r - 1), min(rows, r + 2))
            for cc in range(max(0, c - 1), min(cols, c + 2))
        ]
        local = sum(near) / len(near)
        core = die["core"]
        inside = [
            density[rr][cc]
            for rr in range(rows)
            for cc in range(cols)
            if core[0] <= x0 + (cc + 0.5) * (x1 - x0) / cols <= core[2]
            and core[1] <= y1 - (rr + 0.5) * (y1 - y0) / rows <= core[3]
        ]
        mean = sum(inside) / len(inside) if inside else 0.0
        doc.add(
            (" cause? ", "bold"),
            "cell density at hotspot 1 %.0f%%, core average %.0f%% (%s)"
            % (100 * local, 100 * mean, stem),
        )
        if local > 1.2 * mean:
            doc.add(
                ("        ", None),
                "local: cells piled up there; spread them (lower PLACE_DENSITY)",
            )
        elif over > 0.05 * total:
            doc.add(
                ("        ", None),
                "widespread, not one spot: demand exceeds capacity design-wide;",
            )
            doc.add(
                ("        ", None),
                "fewer cells per area, more routing layers, less layer adjustment",
            )
    target = "gui_5_1_grt-failed" if st.failed else "gui_5_1_grt"
    gui = "make %s; Heat Maps > Routing Congestion" % target
    if hotspots:
        gui += "; zoom to (%.0f, %.0f)um on %s" % (
            hotspots[0]["x"],
            hotspots[0]["y"],
            hotspots[0]["layer"],
        )
    return reason, gui
