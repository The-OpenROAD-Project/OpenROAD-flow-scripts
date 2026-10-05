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


# ---------------------------------------------------------------------------
# Panels: one per stage concern, each in its own stage_art_*.py module.
# A panel draws into doc and returns (reason, gui hint): a reason marks
# the stage WARN, or explains a FAIL; the hint says where to look.

PANELS = {}  # log stem -> panels drawn when the stage ran
FAILURE_PANELS = {}  # tool, e.g. "MPL" -> panels that explain its errors

PANEL_MODULES = []


def panel(stems=(), tools=()):
    """Register a panel for stages (log stems) and for failures raised by
    tools (message ID prefixes)."""

    def register(fn):
        for stem in stems:
            PANELS.setdefault(stem, []).append(fn)
        for tool in tools:
            FAILURE_PANELS.setdefault(tool, []).append(fn)
        return fn

    return register


def load_panels():
    for name in PANEL_MODULES:
        importlib.import_module(name)


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
    if st.failed or reasons or full:
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
