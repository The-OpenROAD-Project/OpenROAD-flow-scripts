"""Macro placement: macros drawn to scale in the core, and, when placement
fails, an area budget that shows whether they can fit at all."""

import math
import re

from stage_art import (
    LOOKS,
    Frame,
    bar,
    indent,
    panel,
    side_by_side,
    si,
)


def macro_letters(macros):
    """One letter per macro master, biggest first, for compact labels."""
    masters = {}
    for m in macros:
        masters.setdefault(m["master"], m)
    order = sorted(masters, key=lambda k: -masters[k]["w"] * masters[k]["h"])
    letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return {name: letters[i % 26] for i, name in enumerate(order)}


def placer_arg(st, flag):
    """The value of a flag on the last logged rtl_macro_placer command:
    what the placer actually ran with."""
    m = re.findall(
        r"^rtl_macro_placer .*?%s (\"[^\"]*\"|\S+)" % re.escape(flag),
        st.log,
        re.MULTILINE,
    )
    return m[-1].strip('"') if m else None


def channel_keepout(st):
    """(left, bottom, right, top) keep-out around each macro in um: half
    of the channel the macro placer keeps between macros."""
    value = placer_arg(st, "-min_channel_size")
    ch = [float(v) for v in value.split()] if value else []
    if len(ch) == 1:
        ch = ch * 2
    if len(ch) == 2:
        return (ch[0] / 2, ch[1] / 2, ch[0] / 2, ch[1] / 2)
    return (0.0, 0.0, 0.0, 0.0)


def macro_halo(m, keepout):
    """The instance's own halo if it has one, else the channel keep-out."""
    return m["halo"] or keepout


def halo_box(m, keepout):
    """Macro footprint including its keep-out, as (w, h)."""
    left, bottom, right, top = macro_halo(m, keepout)
    return m["w"] + left + right, m["h"] + bottom + top


def draw_macro(frame, m, rect, letter, keepout):
    """Draw the keep-out (rect) and the macro inside it."""
    left, bottom, right, top = macro_halo(m, keepout)
    inner = [rect[0] + left, rect[1] + bottom, rect[2] - right, rect[3] - top]
    if inner != list(rect):
        frame.box(rect, style="halo", fill=".", solid=True)
    frame.box(inner, letter, "macro", solid=True)


def spill_std_cells(frame, core, area_frac):
    """Pour the std cell area (as a fraction of the core) into the free
    core cells from the bottom up; what does not fit spills outside the
    core."""
    c0 = int(math.floor(frame.col(core[0]))) + 1
    c1 = int(math.ceil(frame.col(core[2]))) - 2
    r0 = int(math.floor(frame.row(core[3]))) + 1
    r1 = int(math.ceil(frame.row(core[1]))) - 2
    inside = [(r, c) for r in range(r0, r1 + 1) for c in range(c0, c1 + 1)]
    need = int(round(area_frac * len(inside)))
    free = [rc for rc in reversed(inside) if not frame.solid[rc[0]][rc[1]]]
    for r, c in free[:need]:
        frame.put(c, r, ":", "std")
    spill = need - min(need, len(free))
    # Spill into the die margin below the core: enough to read as
    # "overflowing", without hiding the floorplan.
    outside = [(r, c) for r in range(r1 + 2, frame.h) for c in range(frame.w)]
    for r, c in outside[:spill]:
        frame.put(c, r, "X", "over")


def shelf_pack(macros, core, keepout):
    """Pack macro footprints (with halos) into the core shelf by shelf,
    tallest first. Returns ([(macro, rect)], [unplaced macros]).

    Not what the macro placer does; it shows whether area alone can work,
    which is the first question when it fails.
    """
    cx0, cy0, cx1, cy1 = core
    placed, unplaced = [], []
    x, y_top, shelf_h = cx0, cy1, 0.0
    for m in sorted(macros, key=lambda m: -halo_box(m, keepout)[1]):
        w, h = halo_box(m, keepout)
        if x + w > cx1 and x > cx0:
            x, y_top, shelf_h = cx0, y_top - shelf_h, 0.0
        if x + w > cx1 or y_top - h < cy0:
            unplaced.append(m)
            continue
        placed.append((m, [x, y_top - h, x + w, y_top]))
        x += w
        shelf_h = max(shelf_h, h)
    return placed, unplaced


@panel(stems=["2_2_floorplan_macro"], tools=["MPL"])
def panel_macros(doc, st):
    """Macros against the core: where the placer put them, or, when it
    failed, whether they fit at all next to the std cells."""
    die = st.probe("die")
    macros = st.probe("macros")
    if not die or not macros:
        return None, None
    core = die["core"]
    core_w, core_h = core[2] - core[0], core[3] - core[1]
    core_area = core_w * core_h
    letters = macro_letters(macros)
    frame = Frame(die["die"], doc.rich)
    frame.box(core, style="dim")

    # Placed macros as the placer put them, with their area as it is. On
    # failure, pack them with half a channel around each to show what
    # area alone allows: a model that overstates the need, so it only
    # explains a failure.
    all_placed = all(m["placed"] for m in macros) and not st.failed
    keepout = (0.0, 0.0, 0.0, 0.0) if all_placed else channel_keepout(st)
    unplaced = []
    if all_placed:
        for m in macros:
            frame.box(m["box"], letters[m["master"]], "macro", solid=True)
    else:
        packed, unplaced = shelf_pack(macros, core, keepout)
        for m, rect in packed:
            draw_macro(frame, m, rect, letters[m["master"]], keepout)

    macro_area = sum(m["w"] * m["h"] for m in macros)
    halo_area = sum(halo_box(m, keepout)[0] * halo_box(m, keepout)[1] for m in macros)
    std_area, _ = st.latest("design__instance__area__stdcell")
    # The density the macro placer was given, as logged; it is
    # PLACE_DENSITY plus PLACE_DENSITY_LB_ADDON's lift.
    density = placer_arg(st, "-target_util")
    density = float(density) if density else None
    need_std = (std_area or 0.0) / (density or 1.0)
    total = halo_area + need_std
    if not all_placed and std_area:
        spill_std_cells(frame, core, need_std / core_area)

    right = []
    right.append(
        [("core %.0fx%.0fum = %s um^2" % (core_w, core_h, si(core_area)), None)]
    )
    right.append(
        [
            (
                "macros %d, %.0f%% of core"
                % (len(macros), 100 * macro_area / core_area),
                None,
            )
        ]
    )
    scale = max(1.0, total / core_area)
    bw = 24

    def budget(label, area, style=None):
        frac = area / core_area / scale
        return [
            ("%-11s" % label, None),
            (bar(frac, bw), style),
            (" %3.0f%%" % (100 * area / core_area), None),
        ]

    right.append(
        budget(
            "macros+ch" if halo_area > macro_area else "macros", halo_area, "magenta"
        )
    )
    if std_area:
        right.append(budget("std/dens" if density else "std cells", need_std, "cyan"))
    tot_style = "bold red" if total > core_area else "green"
    right.append(budget("total", total, tot_style))
    if scale > 1.0:
        mark = int(round(bw / scale))
        right.append([(" " * 11 + " " * mark + "^ core full", "red")])

    reason = None
    # Macros too big for the core in both orientations; the area budget
    # is a model, so it explains a failure but does not flag a success.
    too_big = [
        m
        for m in macros
        if (halo_box(m, keepout)[0] > core_w or halo_box(m, keepout)[1] > core_h)
        and (halo_box(m, keepout)[1] > core_w or halo_box(m, keepout)[0] > core_h)
    ]
    if too_big and st.failed:
        m = max(too_big, key=lambda m: m["w"] * m["h"])
        right.append(
            [
                (
                    "%s %.0fx%.0fum > core" % (m["name"][:18], *halo_box(m, keepout)),
                    "bold red",
                )
            ]
        )
        reason = "macro bigger than core"
    elif total > core_area and st.failed:
        reason = "macros+std cells need %.0f%% of core" % (100 * total / core_area)
    elif unplaced and st.failed:
        reason = "%d macros do not pack" % len(unplaced)
    if unplaced:
        right.append(
            [
                (
                    "%d macro%s left over:"
                    % (len(unplaced), "" if len(unplaced) == 1 else "s"),
                    "bold red",
                )
            ]
        )
        for name in sorted({m["master"] for m in unplaced})[:2]:
            n = sum(1 for m in unplaced if m["master"] == name)
            right.append([("  %s x%d" % (name[:28], n), "red")])

    right.append([])
    for name, letter in sorted(letters.items(), key=lambda kv: kv[1])[:5]:
        sample = next(m for m in macros if m["master"] == name)
        n = sum(1 for m in macros if m["master"] == name)
        right.append(
            [
                (letter, "bold magenta"),
                (" %s x%d %.0fx%.0f" % (name[:24], n, sample["w"], sample["h"]), None),
            ]
        )

    doc.extend(indent(side_by_side(frame.lines(), right)))
    if not all_placed:
        legend = [(" packed by area, what fits?  ", "dim")]
        if std_area:
            legend += [
                LOOKS["std"](":", doc.rich),
                (
                    " std cells at density %.2f" % density if density else " std cells",
                    "dim",
                ),
            ]
        if total > core_area:
            legend += [
                ("  ", None),
                LOOKS["over"]("X", doc.rich),
                (
                    " %.0f%% of core over" % (100 * (total - core_area) / core_area),
                    "dim",
                ),
            ]
        doc.add(*legend)
    if too_big and st.failed:
        gui = "Inspector: find %s; core is %.0fx%.0fum" % (
            too_big[0]["name"],
            core_w,
            core_h,
        )
    elif reason:
        gui = (
            "make gui_2_1_floorplan; lower CORE_UTILIZATION or PLACE_DENSITY, "
            "or RTLMP_MIN_CHANNEL_SIZE"
        )
    else:
        gui = None
    return reason, gui
