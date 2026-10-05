"""Final report: the signoff numbers, how the key metrics moved through
the flow and which stage moved each the wrong way, and where the time
went."""

import glob
import os

from stage_art import ELAPSED_RE, bar, panel, read_text, si, sparkline, time_unit

# (label, metric, scale, unit, higher is better)
TREND = [
    ("inst -fill", "design__instance__count", 1, "", None),
    ("util", "design__instance__utilization", 100, "%", None),
    ("setup ws", "timing__setup__ws", 1, "", True),
    ("setup tns", "timing__setup__tns", 1, "", True),
    ("hold ws", "timing__hold__ws", 1, "", True),
]


def value(metrics, key):
    """A metric, with instance counts net of filler cells: fill is added
    at the end and would swamp how the design itself grew."""
    v = metrics[key]
    fill = metrics.get("design__instance__count__class:fill_cell")
    if key == "design__instance__count" and isinstance(fill, (int, float)):
        v -= fill
    return v


def watts(w):
    for div, prefix in ((1, ""), (1e-3, "m"), (1e-6, "u"), (1e-9, "n")):
        if abs(w) >= div:
            return "%.3g%sW" % (w / div, prefix)
    return "%.3gW" % w


def seconds(elapsed):
    """Seconds from run_command.py's [H:]MM:SS.ff."""
    total = 0.0
    for part in elapsed.split(":"):
        total = total * 60 + float(part)
    return total


@panel(stems=["6_report"], always=True)
def panel_final(doc, st):
    m = st.metrics
    unit = time_unit(st)
    signoff = []
    for kind in ("setup", "hold"):
        ws = m.get("timing__%s__ws" % kind)
        if isinstance(ws, (int, float)):
            signoff.append(("%s ws %s" % (kind, si(ws)), "red" if ws < 0 else "green"))
            signoff.append(("  ", None))
    fmax = m.get("timing__fmax")
    if isinstance(fmax, (int, float)):
        signoff.append(("fmax %sHz  " % si(fmax), None))
    power = m.get("power__total")
    if isinstance(power, (int, float)):
        signoff.append(("power %s  " % watts(power), None))
    drc, _ = st.latest("route__drc_errors")
    if drc is not None:
        signoff.append(("DRC %d" % drc, "red" if drc else "green"))
    if signoff:
        doc.add((" signoff: ", "bold"), *signoff)

    # The flow's history, one column per stage that reported the metric.
    history = st.history + [(st.stem, m)]
    doc.add((" through the flow", "bold"), ("  first > last, worst step", "dim"))
    for label, key, scale, munit, better in TREND:
        points = [
            (stem, value(metrics, key) * scale)
            for stem, metrics in history
            if isinstance(metrics.get(key), (int, float))
        ]
        if len(points) < 2:
            continue
        values = [v for _, v in points]
        line = [
            ("  %-11s" % label, None),
            ("%-10s" % sparkline(values, doc.rich, width=10), "cyan"),
            (" %s > %s%s" % (si(values[0]), si(values[-1]), munit), None),
        ]
        if better is not None:
            steps = [
                (points[i][0], points[i][1] - points[i - 1][1])
                for i in range(1, len(points))
            ]
            stem, step = min(steps, key=lambda s: s[1] if better else -s[1])
            if (step < 0) == better and step:
                line.append(("  %s %s%s" % (stem, si(step), unit), "yellow"))
        doc.add(*line)

    # Where the time went: elapsed per stage from every stage log.
    times = []
    for path in sorted(glob.glob(os.path.join(st.log_dir, "[0-9]_*.log"))):
        found = ELAPSED_RE.findall(read_text(path))
        if found:
            stem = os.path.basename(path)[: -len(".log")]
            times.append((stem, seconds(found[-1][0])))
    if times:
        total = sum(t for _, t in times)
        doc.add((" runtime %s, longest stages" % elapsed_text(total), "bold"))
        longest = sorted(times, key=lambda t: -t[1])[:4]
        for stem, t in longest:
            doc.add(
                "  %-22s" % stem,
                (bar(t / longest[0][1], 20), "cyan"),
                " %s %3.0f%%" % (elapsed_text(t), 100 * t / total),
            )
    return None, None


def elapsed_text(t):
    if t >= 3600:
        return "%dh%02dm" % (t // 3600, t % 3600 // 60)
    if t >= 60:
        return "%dm%02ds" % (t // 60, t % 60)
    return "%.0fs" % t
