#!/usr/bin/env python3
"""Draw a short picture of what a flow stage did at the end of its log.

The goal is a mental model: what the stage did, whether that is a
problem, and where to look in the GUI. A healthy stage gets a few lines;
a failed or troubled stage gets a picture that makes the cause visible,
e.g. macros drawn to scale against a core they cannot fit in.

Inputs, all written by the stage itself:
  $LOG_DIR/<stage>.log         errors, elapsed time, peak memory
  $LOG_DIR/<stage>.json        metrics (and earlier stages' for deltas)
  $REPORTS_DIR/<stage>.art.json  snapshot from scripts/stage_art.tcl

The log file always gets plain 7-bit ASCII so it greps, diffs and reads
the same in CI. An interactive terminal gets colour through `rich` when
it is installed; colour never carries information the ASCII lacks.
"""

import argparse
import glob
import importlib
import json
import math
import os
import re
import sys

WIDTH = 80

# Order of stages in the flow; log stems sort in flow order, e.g.
# 2_1_floorplan < 2_2_floorplan_macro < 3_1_place_gp_skip_io.
STAGE_WHAT = {
    "1_synth": "netlist into OpenROAD; cell mix and logic depth bound timing",
    "2_1_floorplan": "size die and core from utilization; leave room to buffer",
    "2_2_floorplan_macro": "place macros in the core, leaving room for std cells",
    "2_3_floorplan_tapcell": "insert tap and endcap cells in every row",
    "2_4_floorplan_pdn": "build the power grid; every row and macro connected",
    "3_1_place_gp_skip_io": "rough placement ignoring IO, to seed pin placement",
    "3_2_place_iop": "place IO pins on the die edge close to their logic",
    "3_3_place_gp": "spread cells to cut wirelength at PLACE_DENSITY",
    "3_4_place_resized": "fix slew/cap/fanout by resizing and buffering",
    "3_5_place_dp": "legalize cells onto rows with small displacement",
    "4_1_cts": "build clock trees and repair hold; low skew, few buffers",
    "5_1_grt": "route nets over gcells; demand must stay under capacity",
    "5_2_route": "route on tracks and fix DRCs until none are left",
    "5_3_fillcell": "fill empty row sites with filler cells",
    "6_1_fill": "insert metal fill",
    "6_report": "final timing, power and area",
}

# variables.yaml stage for each log stem, to list the design's settings
# that affect this stage.
YAML_STAGE = [
    ("1_", "synth"),
    ("2_", "floorplan"),
    ("3_", "place"),
    ("4_", "cts"),
    ("5_1", "grt"),
    ("5_", "route"),
    ("6_", "final"),
]

# Leading metric name components that name the stage, per METRICS2.1.
METRIC_STAGES = {
    "run",
    "init",
    "synth",
    "floorplan",
    "globalplace",
    "placeopt",
    "detailedplace",
    "cts",
    "globalroute",
    "detailedroute",
    "finish",
}

PLAIN_RAMP = " .:-=+*#%@"

# viridis, sampled; perceptually uniform and readable with colour
# vision deficiency.
VIRIDIS = [
    (0x44, 0x01, 0x54),
    (0x48, 0x28, 0x78),
    (0x3E, 0x49, 0x89),
    (0x31, 0x68, 0x8E),
    (0x26, 0x82, 0x8E),
    (0x1F, 0x9E, 0x89),
    (0x35, 0xB7, 0x79),
    (0x6E, 0xCE, 0x58),
    (0xB5, 0xDE, 0x2B),
    (0xFD, 0xE7, 0x25),
]
OVER = (0xFF, 0x30, 0x30)

# ---------------------------------------------------------------------------
# Output document: lines of (text, style) segments. Plain rendering drops
# the styles; rich rendering maps them to colour.


class Doc:
    def __init__(self, rich):
        self.rich = rich
        self.lines = []

    def add(self, *segments):
        """Add a line from str or (text, style) segments."""
        line = []
        for seg in segments:
            if isinstance(seg, str):
                seg = (seg, None)
            line.append(seg)
        self.lines.append(line)

    def extend(self, lines):
        """Add lines of (text, style) segments, as panels build them."""
        for line in lines:
            for seg in line:
                if not (isinstance(seg, tuple) and len(seg) == 2):
                    raise TypeError("segment %r is not (text, style)" % (seg,))
        self.lines.extend(lines)

    def plain(self):
        return "\n".join(
            "".join(text for text, _ in line).rstrip() for line in self.lines
        )


def hexcolor(rgb):
    return "#%02x%02x%02x" % rgb


def ramp_color(t):
    """viridis at t in [0, 1]; red above 1 (over capacity)."""
    if t > 1.0:
        return OVER
    t = max(0.0, t) * (len(VIRIDIS) - 1)
    i = min(int(t), len(VIRIDIS) - 2)
    f = t - i
    a, b = VIRIDIS[i], VIRIDIS[i + 1]
    return tuple(int(a[k] + (b[k] - a[k]) * f) for k in range(3))


def plain_char(t):
    if t is None:
        return " "
    if t > 1.0:
        return "X"
    return PLAIN_RAMP[min(len(PLAIN_RAMP) - 1, max(0, int(t * len(PLAIN_RAMP))))]


# ---------------------------------------------------------------------------
# Inputs


def strip_metric(key):
    head, _, rest = key.partition("__")
    return rest if head in METRIC_STAGES and rest else key


def load_metrics(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except (OSError, ValueError):
        return {}
    return {strip_metric(k): v for k, v in data.items()}


def load_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except OSError:
        return None


def read_text(path):
    try:
        with open(path, errors="replace") as f:
            return f.read()
    except OSError:
        return ""


ELAPSED_RE = re.compile(
    r"Elapsed time: (\S+)\[h:\]min:sec\..*Peak memory: (\d+)KB", re.MULTILINE
)
ERROR_RE = re.compile(r"\[ERROR ([A-Z]{3}-\d{4})\]\s*(.*)")
WARNING_RE = re.compile(r"\[WARNING ([A-Z]{3}-\d{4})\]")


class Stage:
    """Everything known about one stage run."""

    def __init__(self, stem, status, log_dir, reports_dir):
        self.stem = stem
        self.status = status
        self.script = None
        self.log_dir = log_dir
        self.log = read_text(os.path.join(log_dir, stem + ".log"))
        self.metrics = load_metrics(os.path.join(log_dir, stem + ".json"))
        self.reports_dir = reports_dir
        self.snapshot = load_json(os.path.join(reports_dir, stem + ".art.json"))
        if not isinstance(self.snapshot, dict):
            self.snapshot = {}
        # Metrics of the stages before this one, oldest first.
        self.history = []
        for path in sorted(glob.glob(os.path.join(log_dir, "[0-9]_*.json"))):
            prev = os.path.basename(path)[: -len(".json")]
            if prev < stem:
                self.history.append((prev, load_metrics(path)))

        m = ELAPSED_RE.findall(self.log)
        self.elapsed, self.peak_kb = (m[-1][0], int(m[-1][1])) if m else (None, None)

        self.error_id, self.error_msg = None, None
        errors = ERROR_RE.findall(self.log)
        if errors:
            self.error_id, self.error_msg = errors[-1]
        elif self.snapshot.get("error"):
            self.error_msg = self.snapshot["error"].strip().splitlines()[0]
        elif status != 0:
            # No [ERROR] line: a Tcl error, a crash or a kill; the last
            # non-blank lines before the timing line say which.
            tail = [l for l in self.log.splitlines() if l.strip()]
            tail = [l for l in tail if not l.startswith("Elapsed time")]
            self.error_msg = tail[-1] if tail else "no output"

    @property
    def failed(self):
        return self.status != 0

    def probe(self, name):
        """A snapshot probe's data, or None if absent or it failed."""
        value = self.snapshot.get(name)
        if isinstance(value, dict) and "probe_error" in value:
            return None
        return value

    def earlier_probe(self, name):
        """(probe data, stem) from the most recent earlier stage snapshot
        that has it, e.g. placement density when explaining congestion."""
        for stem, _ in reversed(self.history):
            snap = load_json(os.path.join(self.reports_dir, stem + ".art.json"))
            if isinstance(snap, dict):
                value = snap.get(name)
                if value and not (isinstance(value, dict) and "probe_error" in value):
                    return value, stem
        return None, None

    def latest(self, key):
        """(value, stem) of the most recent stage that reported key."""
        if key in self.metrics:
            return self.metrics[key], self.stem
        for stem, metrics in reversed(self.history):
            if key in metrics:
                return metrics[key], stem
        return None, None

    def previous(self, key):
        for _, metrics in reversed(self.history):
            if key in metrics:
                return metrics[key]
        return None


# ---------------------------------------------------------------------------
# Formatting helpers


def si(v, digits=3):
    """Compact number: 18522 -> 18.5k."""
    if v is None:
        return "-"
    a = abs(v)
    for div, suffix in ((1e9, "G"), (1e6, "M"), (1e3, "k")):
        if a >= div:
            return "%.*g%s" % (digits, v / div, suffix)
    if isinstance(v, int) or float(v).is_integer():
        return "%d" % v
    return "%.*g" % (digits, v)


def signed(v, digits=3):
    if v is None:
        return "-"
    return ("+" if v >= 0 else "") + si(v, digits)


def kb(v):
    if v is None:
        return "-"
    return "%.1fGB" % (v / 1048576) if v >= 1048576 else "%dMB" % (v / 1024)


def bar(frac, width):
    n = max(0, min(width, int(round(frac * width))))
    return "#" * n + "." * (width - n)


def time_unit(st):
    """The platform's time unit as metrics report it, "1ps" -> "ps"."""
    unit = st.latest("flow__platform__time_units")[0] or ""
    return re.sub(r"^1(?=[a-z])", "", unit)


def yaml_stage(stem):
    for prefix, stage in YAML_STAGE:
        if stem.startswith(prefix):
            return stage
    return None


# ---------------------------------------------------------------------------
# Header, key metrics, footer: on every stage.


def header(doc, st, verdict, reason):
    def name(key, env, default):
        return st.snapshot.get(key) or os.environ.get(env) or default

    where = "%s/%s" % (
        name("design", "DESIGN_NICKNAME", "?"),
        name("platform", "PLATFORM", "?"),
    )
    variant = name("variant", "FLOW_VARIANT", "base")
    if variant != "base":
        where += "/" + variant
    style = {"FAIL": "bold white on red", "WARN": "bold black on yellow"}.get(
        verdict, "bold black on green"
    )
    left = [("== ORFS ", "bold"), (st.stem, "bold cyan"), (" ", None), (verdict, style)]
    if reason and verdict == "FAIL":
        left.append((" " + reason, "bold"))
    left.append(("  " + where, None))
    right = " %s %s %sthr" % (
        st.elapsed or "-",
        kb(st.peak_kb),
        st.snapshot.get("threads", "?"),
    )
    version = st.snapshot.get("openroad")
    if version:
        right = " OR " + version + right
    used = sum(len(t) for t, _ in left)
    fill = max(1, WIDTH - used - len(right) - 1)
    doc.add(*left, " " + "-" * fill, (right, "dim"))
    what = STAGE_WHAT.get(st.stem)
    if what:
        doc.add((" what: " + what, "dim"))


def key_metrics(doc, st):
    """The same few metrics on every stage, with the change this stage
    made, so reading down the log shows where a number started to go."""

    def delta(key, v, stem, scale=1.0):
        """The change this stage made, if it measured key and moved it by
        more than rounding noise."""
        prev = st.previous(key)
        if stem != st.stem or not isinstance(prev, (int, float)):
            return []
        d = v - prev
        if abs(d) <= 0.005 * max(abs(v), abs(prev)):
            return []
        return [("(%s)" % signed(d * scale), "yellow")]

    def value(key, scale=1.0, unit=""):
        v, stem = st.latest(key)
        if v is None or not isinstance(v, (int, float)):
            return [("-", "dim")]
        out = [(si(v * scale) + unit, None if stem == st.stem else "dim")]
        return out + delta(key, v, stem, scale)

    def slack(kind):
        key = "timing__%s__ws" % kind
        ws, ws_stem = st.latest(key)
        tns, _ = st.latest("timing__%s__tns" % kind)
        timing = st.probe("timing") or {}
        viol = (timing.get(kind) or {}).get("violators")
        if ws is None:
            return [(kind + " -", "dim")]
        style = "red" if ws < 0 else "green"
        if ws_stem != st.stem:
            style = "dim"
        out = [(kind + " ws ", None), (si(ws), style)] + delta(key, ws, ws_stem)
        out.append((" tns %s" % si(tns), None))
        if viol is not None:
            out.append((" #%d" % viol, "red" if viol else None))
        return out

    line = [" inst "] + value("design__instance__count")
    line += ["  util "] + value("design__instance__utilization", 100.0, "%")
    line += ["  macros "] + value("design__instance__count__macros")
    line += ["  "] + slack("setup")
    doc.add(*line)
    unit = time_unit(st)
    line = [" area "] + value("design__instance__area", unit="um^2")
    line += ["  "] + slack("hold")
    if unit:
        line.append(("  (time in %s)" % unit, "dim"))
    doc.add(*line)


def command_line_variables():
    """NAME=value pairs given on the make command line, which make passes
    down in MAKEFLAGS after " -- " with spaces escaped."""
    flags = os.environ.get("MAKEFLAGS", "")
    if " -- " not in flags:
        return []
    out = []
    for word in re.findall(r"(?:\\.|[^ ])+", flags.split(" -- ", 1)[1]):
        name, eq, value = re.sub(r"\\(.)", r"\1", word).partition("=")
        if eq and re.match(r"[A-Z][A-Z0-9_]*$", name):
            out.append((name, value))
    return out


def design_variables(st):
    """Settings this stage reads that the user chose: (name, value, from
    command line) for variables the design config or make command line
    sets, which is what a maintainer asks for first."""
    stage = yaml_stage(st.stem)
    scripts = os.environ.get("SCRIPTS_DIR")
    if not stage or not scripts:
        return []
    variables = load_json(os.path.join(scripts, "variables.json")) or {}

    def reads(name):
        info = variables.get(name)
        return info and stage in info.get("stages", [])

    out = []
    seen = set()
    for name, value in command_line_variables():
        if reads(name) and name not in seen:
            seen.add(name)
            out.append((name, value, True))
    config = os.environ.get("DESIGN_CONFIG")
    for line in read_text(config).splitlines() if config else []:
        m = re.match(r"\s*export\s+([A-Z][A-Z0-9_]*)\s*[:?+]?=", line)
        if not m or m.group(1) in seen or not reads(m.group(1)):
            continue
        name = m.group(1)
        seen.add(name)
        value = os.environ.get(name, "")
        # Paths say little in a summary and run long.
        if value and "/" not in value:
            out.append((name, value, False))
    return out


def variables_line(doc, st):
    settings = design_variables(st)
    if not settings:
        return
    text = " vars: "
    for name, value, cmdline in settings:
        word = "%s=%s%s" % (name, value.replace(" ", ","), "*" if cmdline else "")
        if len(text) + len(word) + 1 > WIDTH:
            doc.add((text.rstrip(), "dim"))
            text = "       "
        text += word + " "
    if any(cmdline for _, _, cmdline in settings):
        if len(text) + 14 > WIDTH:
            doc.add((text.rstrip(), "dim"))
            text = "       "
        text += "(*make cmdline)"
    doc.add((text.rstrip(), "dim"))


def wrap(text, first, rest, width=WIDTH, lines=3):
    """Split text into at most `lines` lines with the given prefixes."""
    out, line = [], first
    for word in text.split():
        if len(line) + len(word) > width and line.strip():
            out.append(line.rstrip())
            line = rest
            if len(out) == lines:
                out[-1] = out[-1][: width - 3] + "..."
                return out
        line += word + " "
    out.append(line.rstrip())
    return out


def footer(doc, st, gui):
    warns = {
        k.split(":", 1)[1]: v
        for k, v in st.metrics.items()
        if k.startswith("flow__warnings__count:") and isinstance(v, int)
    }
    if not warns:
        for wid in WARNING_RE.findall(st.log):
            warns[wid] = warns.get(wid, 0) + 1
    top = sorted(warns.items(), key=lambda kv: (-kv[1], kv[0]))[:3]
    text = " warn %d" % sum(warns.values())
    if top:
        text += " (" + ", ".join("%s x%d" % kv for kv in top) + ")"
    errors = st.metrics.get("flow__errors__count")
    if errors is None:
        errors = 1 if st.failed else 0
    line = [(text, "yellow" if warns else "dim"), "  err "]
    line.append(("%d" % errors, "bold red" if errors else "dim"))
    doc.add(*line)
    if st.failed and st.script:
        doc.add(
            (
                " issue: make %s_issue  (packages this stage to reproduce)" % st.script,
                "dim",
            )
        )
    if gui:
        text = " GUI: "
        for word in gui.split(" "):
            if len(text) + len(word) > WIDTH:
                doc.add((text.rstrip(), "bold cyan"))
                text = "      "
            text += word + " "
        doc.add((text.rstrip(), "bold cyan"))


# ---------------------------------------------------------------------------
# Die frame: the same outline in every stage, so the reader watches one
# floorplan fill up with macros, cells, congestion and DRCs.


class Frame:
    """Maps die coordinates (um) onto a character grid.

    Character cells are about twice as tall as wide, so the grid keeps the
    die's aspect ratio with half as many rows as columns per um.
    """

    def __init__(self, die, rich, max_w=46, max_h=16):
        # rich draws half-blocks: two map rows per character row.
        self.sub = 2 if rich else 1
        self.values = None
        self.x0, self.y0, self.x1, self.y1 = die
        dw = max(self.x1 - self.x0, 1e-9)
        dh = max(self.y1 - self.y0, 1e-9)
        w = max_w
        h = int(round(w * dh / dw / 2.0))
        if h > max_h:
            h = max_h
            w = max(4, int(round(h * 2.0 * dw / dh)))
        self.w, self.h = w, max(2, h)
        self.cells = [[(" ", None)] * self.w for _ in range(self.h)]
        # Cells covered by something solid (a macro), not free for cells.
        self.solid = [[False] * self.w for _ in range(self.h)]

    def col(self, x):
        return (x - self.x0) / (self.x1 - self.x0) * self.w

    def row(self, y):
        # Row 0 is the top of the die.
        return (self.y1 - y) / (self.y1 - self.y0) * self.h

    def put(self, c, r, ch, style=None):
        if 0 <= r < self.h and 0 <= c < self.w:
            self.cells[r][c] = (ch, style)

    def box(self, rect, label="", style=None, fill=" ", solid=False):
        """Draw a rectangle (um); tiny ones collapse to a filled block."""
        c0 = int(math.floor(self.col(rect[0])))
        c1 = int(math.ceil(self.col(rect[2]))) - 1
        r0 = int(math.floor(self.row(rect[3])))
        r1 = int(math.ceil(self.row(rect[1]))) - 1
        c1, r1 = max(c0, c1), max(r0, r1)
        for r in range(r0, r1 + 1):
            for c in range(c0, c1 + 1):
                edge_c = c in (c0, c1) and c1 > c0
                edge_r = r in (r0, r1) and r1 > r0
                if c1 - c0 < 2 or r1 == r0 and c1 - c0 < 2:
                    ch = "#"
                elif edge_c and edge_r:
                    ch = "+"
                elif edge_r:
                    ch = "-"
                elif edge_c:
                    ch = "|"
                else:
                    ch = fill
                self.put(c, r, ch, style)
                if solid and 0 <= r < self.h and 0 <= c < self.w:
                    self.solid[r][c] = True
        if label and c1 - c0 >= 2:
            r = r0 + 1 if r1 > r0 + 1 else r0
            for k, ch in enumerate(label[: c1 - c0 - 1]):
                self.put(c0 + 1 + k, r, ch, style)

    def outline(self, rect, style=None):
        """Draw only the edges of a rectangle (um), e.g. a macro over a map."""
        c0 = int(math.floor(self.col(rect[0])))
        c1 = max(c0, int(math.ceil(self.col(rect[2]))) - 1)
        r0 = int(math.floor(self.row(rect[3])))
        r1 = max(r0, int(math.ceil(self.row(rect[1]))) - 1)
        for c in range(c0, c1 + 1):
            for r in (r0, r1):
                self.put(c, r, "+" if c in (c0, c1) else "-", style)
        for r in range(r0 + 1, r1):
            for c in (c0, c1):
                self.put(c, r, "|", style)

    def mark(self, x, y, ch, style):
        """Put a marker at a die coordinate (um)."""
        self.put(
            min(self.w - 1, int(self.col(x))),
            min(self.h - 1, int(self.row(y))),
            ch,
            style,
        )

    def heat(self, grid, scale, pool=max):
        """Shade the frame from a die-binned grid (row 0 = top).

        Several grid bins can fall in one character; `pool` combines them:
        max for congestion, so a hot spot is never averaged away, mean for
        density, which is an average by nature. Returns per-cell values for
        the rich renderer's half-blocks.
        """
        rows, cols = len(grid), len(grid[0]) if grid else 0
        if not rows or not cols:
            return
        sub = self.sub
        values = []
        for r in range(self.h * sub):
            g0 = r * rows // (self.h * sub)
            g1 = max(g0 + 1, (r + 1) * rows // (self.h * sub))
            row = []
            for c in range(self.w):
                k0 = c * cols // self.w
                k1 = max(k0 + 1, (c + 1) * cols // self.w)
                cell = [grid[g][k] for g in range(g0, g1) for k in range(k0, k1)]
                v = pool(cell)
                row.append(v / scale if scale else 0.0)
            values.append(row)
        self.values = values
        for r in range(self.h):
            for c in range(self.w):
                v = max(values[r * sub + s][c] for s in range(sub))
                self.cells[r][c] = (plain_char(v), ("heat", r, c))

    def lines(self):
        """Framed rows as segment lists."""
        out = [[("+" + "-" * self.w + "+", "dim")]]
        sub, values = self.sub, self.values
        for r, row in enumerate(self.cells):
            line = [("|", "dim")]
            for c, (ch, style) in enumerate(row):
                if isinstance(style, tuple) and style[0] == "heat":
                    if sub == 2:
                        top = hexcolor(ramp_color(values[r * sub][c]))
                        bot = hexcolor(ramp_color(values[r * sub + sub - 1][c]))
                        line.append(("\u2580", "%s on %s" % (top, bot)))
                    else:
                        line.append((ch, None))
                elif style in LOOKS:
                    line.append(LOOKS[style](ch, sub == 2))
                else:
                    line.append((ch, style))
            line.append(("|", "dim"))
            out.append(line)
        out.append([("+" + "-" * self.w + "+", "dim")])
        return out


# Frame cell kinds: plain keeps the ASCII glyph, rich draws blocks.
LOOKS = {
    "macro": lambda ch, rich: (
        (ch if ch.isalnum() else " ", "bold white on #7b3fa0") if rich else (ch, None)
    ),
    "halo": lambda ch, rich: (" ", "on #3a2350") if rich else (ch, None),
    "std": lambda ch, rich: ("\u2592", "#3fb5c9") if rich else (ch, None),
    "over": lambda ch, rich: ("\u2588", "#ff3030") if rich else (ch, None),
    "outline": lambda ch, rich: (ch, "bold white") if rich else (ch, None),
    "marker": lambda ch, rich: (ch, "bold white on #c00000") if rich else (ch, None),
}


def mean(values):
    return sum(values) / len(values)


def side_by_side(left, right, gap=2):
    """Join two segment-line lists into columns."""
    lw = max((sum(len(t) for t, _ in l) for l in left), default=0)
    out = []
    for i in range(max(len(left), len(right))):
        line = list(left[i]) if i < len(left) else []
        pad = lw - sum(len(t) for t, _ in line)
        line.append((" " * (pad + gap), None))
        if i < len(right):
            line.extend(right[i])
        out.append(line)
    return out


def indent(lines, n=1):
    return [[(" " * n, None)] + list(l) for l in lines]


# ---------------------------------------------------------------------------
# Panels: one per stage concern, each in its own stage_art_*.py module.
# A panel draws into doc and returns (reason, gui hint): a reason marks
# the stage WARN, or explains a FAIL; the hint says where to look.

PANELS = {}  # log stem -> panels drawn when the stage ran
FAILURE_PANELS = {}  # tool, e.g. "MPL" -> panels that explain its errors

PANEL_MODULES = [
    "stage_art_macros",
    "stage_art_gpl",
    "stage_art_grt",
    "stage_art_drt",
    "stage_art_timing",
    "stage_art_cts",
    "stage_art_final",
]


def panel(stems=(), tools=(), always=False):
    """Register a panel for stages (log stems) and for failures raised by
    tools (message ID prefixes). A panel is drawn when the stage failed or
    a panel gave a reason, or always, for a summary like the final one."""

    def register(fn):
        fn.always = always
        for stem in stems:
            PANELS.setdefault(stem, []).append(fn)
        for tool in tools:
            FAILURE_PANELS.setdefault(tool, []).append(fn)
        return fn

    return register


def load_panels():
    for name in PANEL_MODULES:
        importlib.import_module(name)


def heat_legend(doc, what, unit_max):
    """One line explaining the map shading."""
    if doc.rich:
        ramp = [(" ", "on " + hexcolor(ramp_color(i / 7.0))) for i in range(8)]
        return (
            [(" %s 0 " % what, "dim")]
            + ramp
            + [
                (" %s " % unit_max, "dim"),
                ("\u2580", "#ff3030"),
                (" over", "dim"),
            ]
        )
    return [(" %s '%s' 0..%s, X over" % (what, PLAIN_RAMP, unit_max), "dim")]


SPARK_PLAIN = "_.-=*#"
SPARK_RICH = "\u2581\u2582\u2583\u2584\u2585\u2586\u2587\u2588"


def sparkline(values, rich, width=32, lo=None, hi=None):
    """values resampled to width characters, scaled lo..hi."""
    if not values:
        return ""
    if len(values) > width:
        values = [values[i * len(values) // width] for i in range(width - 1)] + [
            values[-1]
        ]
    lo = min(values) if lo is None else lo
    hi = max(values) if hi is None else hi
    glyphs = SPARK_RICH if rich else SPARK_PLAIN
    span = (hi - lo) or 1.0
    return "".join(
        glyphs[min(len(glyphs) - 1, max(0, int((v - lo) / span * len(glyphs))))]
        for v in values
    )


# ---------------------------------------------------------------------------


def render(st, rich, full=False):
    load_panels()
    doc = Doc(rich)
    body = Doc(rich)
    reasons, gui = [], None

    panels = []
    if st.failed:
        tool = (st.error_id or "").split("-")[0]
        panels = FAILURE_PANELS.get(tool) or PANELS.get(st.stem, [])
    else:
        panels = PANELS.get(st.stem, [])
    always = any(p.always for p in panels)
    for panel in panels:
        reason, hint = panel(body, st)
        if reason:
            reasons.append(reason)
        gui = gui or hint

    if st.failed:
        verdict = "FAIL"
        reason = st.error_id or "exit %d" % st.status
    elif reasons:
        verdict, reason = "WARN", reasons[0]
    else:
        verdict, reason = "OK", None
    header(doc, st, verdict, reason)
    key_metrics(doc, st)
    if st.failed or reasons:
        variables_line(doc, st)
    if st.failed:
        for k, line in enumerate(wrap(st.error_msg or "", "", "", WIDTH - 8)):
            doc.add((" error: " if k == 0 else "        ", "bold red"), (line, "red"))
        if reasons:
            doc.add((" why: ", "bold"), reasons[0])
    elif reasons:
        doc.add((" why: ", "bold"), "; ".join(reasons))
    if st.failed or reasons or full or always:
        doc.extend(body.lines)
    footer(doc, st, gui)
    return doc


def make_console():
    """A rich console for an interactive terminal, else None."""
    if not sys.stdout.isatty() and not os.environ.get("FORCE_COLOR"):
        return None
    if os.environ.get("TERM") == "dumb":
        return None
    try:
        from rich.console import Console
    except ImportError:
        print("(pip install rich for colour stage summaries)")
        return None
    return Console(highlight=False, soft_wrap=True)


def print_rich(console, doc):
    from rich.text import Text

    for line in doc.lines:
        text = Text()
        for seg, style in line:
            text.append(seg, style=style if isinstance(style, str) else None)
        console.print(text)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--stage", required=True, help="log stem, e.g. 3_3_place_gp")
    parser.add_argument("--status", type=int, default=0, help="stage exit status")
    parser.add_argument("--script", help="stage script name, for make <script>_issue")
    parser.add_argument("--log-dir", default=os.environ.get("LOG_DIR", "."))
    parser.add_argument("--reports-dir", default=os.environ.get("REPORTS_DIR", "."))
    parser.add_argument(
        "--no-log", action="store_true", help="print only, do not append to the log"
    )
    parser.add_argument("--svg", help="also save the colour rendering as SVG")
    parser.add_argument(
        "--full", action="store_true", help="draw the picture even when all is well"
    )
    args = parser.parse_args(argv)

    st = Stage(args.stage, args.status, args.log_dir, args.reports_dir)
    st.script = args.script
    plain = render(st, rich=False, full=args.full).plain()
    if not args.no_log:
        with open(os.path.join(args.log_dir, args.stage + ".log"), "a") as f:
            f.write(plain + "\n")
    if args.svg:
        from rich.console import Console

        recorder = Console(record=True, width=WIDTH + 20, file=open(os.devnull, "w"))
        print_rich(recorder, render(st, rich=True, full=args.full))
        # rsvg and other renderers collapse runs of spaces without this.
        svg = recorder.export_svg(title=args.stage)
        with open(args.svg, "w") as f:
            f.write(svg.replace("<svg ", '<svg xml:space="preserve" ', 1))
    console = make_console()
    if console is None:
        print(plain)
    else:
        print_rich(console, render(st, rich=True, full=args.full))
    return 0


if __name__ == "__main__":
    # Panels register with the module named stage_art that they import;
    # run main() there rather than in this __main__ copy of it.
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import stage_art

    sys.exit(stage_art.main())
