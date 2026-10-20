#!/usr/bin/env python3
"""Compare endpoint slack across flow steps.

Snapshots are written at the end of every flow step (e.g. 3_3_place_gp) when
REPORT_ENDPOINT_SLACK=1, as $REPORTS_DIR/<step>_endpoint_slack.json, with the
setup and hold slack of every timing endpoint.

Examples:
  endpointSlack.py list reports/nangate45/gcd/base
  endpointSlack.py track reports/nangate45/gcd/base
  endpointSlack.py compare A_endpoint_slack.json B_endpoint_slack.json -o cmp.html
  endpointSlack.py export reports/nangate45/gcd/base -o slack.csv
"""

import argparse
import csv
import glob
import html
import json
import os
import statistics
import sys

CHECKS = ("setup", "hold")
UNITS = {"s": 1.0, "ns": 1e9, "ps": 1e12}
SUFFIX = "_endpoint_slack.json"


def load_snapshot(path):
    """Load a snapshot file.

    Returns a dict with metadata, "endpoints" (all endpoint names) and per
    check a dict endpoint -> slack in seconds for constrained endpoints.
    """
    with open(path) as f:
        data = json.load(f)
    unit = data.get("time_unit", 1.0)
    name = os.path.basename(path)
    if name.endswith(SUFFIX):
        name = name[: -len(SUFFIX)]
    snapshot = {
        "file": path,
        "name": name,
        "design": data.get("design", ""),
        "step": data.get("step", name),
        "parasitics": data.get("parasitics", ""),
        "endpoints": set(data["endpoints"]),
    }
    for i, check in enumerate(CHECKS):
        snapshot[check] = {
            ep: slacks[i] * unit
            for ep, slacks in data["endpoints"].items()
            if slacks[i] is not None
        }
    return snapshot


def find_snapshots(reports_dir):
    """Snapshot files in execution (modification time) order."""
    files = glob.glob(os.path.join(reports_dir, "*" + SUFFIX))
    return sorted(files, key=lambda f: (os.path.getmtime(f), f))


def load_dir(reports_dir):
    return [load_snapshot(f) for f in find_snapshots(reports_dir)]


def summary(slacks):
    """WNS, TNS and number of violating endpoints of a slack dict."""
    values = list(slacks.values())
    negative = [s for s in values if s < 0]
    return {
        "count": len(values),
        "wns": min(values) if values else None,
        "tns": sum(negative),
        "violations": len(negative),
    }


def worst_endpoints(slacks, n):
    return set(sorted(slacks, key=slacks.get)[:n])


def _ranks(values):
    """Ranks starting at 1, with tied values given their average rank."""
    order = sorted(range(len(values)), key=values.__getitem__)
    ranks = [0.0] * len(values)
    i = 0
    while i < len(order):
        j = i
        while j + 1 < len(order) and values[order[j + 1]] == values[order[i]]:
            j += 1
        for k in range(i, j + 1):
            ranks[order[k]] = (i + j) / 2 + 1
        i = j + 1
    return ranks


def spearman(x, y):
    """Spearman rank correlation, None if undefined (n < 2 or constant)."""
    if len(x) < 2:
        return None
    try:
        return statistics.correlation(_ranks(x), _ranks(y))
    except statistics.StatisticsError:
        return None


def _ratio(num, den):
    return num / den if den else None


def metrics(sa, sb, critical=1000):
    """Agreement between the slacks of two steps for one check.

    sa, sb: endpoint -> slack of the endpoints constrained in both steps.
    The critical set is the union of the worst `critical` endpoints of A and
    of B, excluding endpoints with positive slack in both steps, which are
    not being optimized. Correlation and error are measured on it.
    """
    top_a = worst_endpoints(sa, critical)
    top_b = worst_endpoints(sb, critical)
    crit = [ep for ep in top_a | top_b if sa[ep] <= 0 or sb[ep] <= 0]
    x = [sa[ep] for ep in crit]
    y = [sb[ep] for ep in crit]
    deltas = [b - a for a, b in zip(x, y)]
    viol_a = {ep for ep, s in sa.items() if s < 0}
    viol_b = {ep for ep, s in sb.items() if s < 0}
    return {
        "critical": critical,
        "n": len(crit),
        "spearman": spearman(x, y),
        "bias": statistics.mean(deltas) if deltas else None,
        "mae": statistics.mean(abs(d) for d in deltas) if deltas else None,
        "rmse": (statistics.mean(d * d for d in deltas) ** 0.5 if deltas else None),
        "max_abs": max(abs(d) for d in deltas) if deltas else None,
        # Fraction of the critical set in the worst `critical` of both steps
        "top_agreement": _ratio(
            sum(ep in top_a and ep in top_b for ep in crit), len(crit)
        ),
        # Of B's violators, the fraction already violating in A
        "violator_recall": _ratio(len(viol_a & viol_b), len(viol_b)),
        # Of A's violators, the fraction still violating in B
        "violator_precision": _ratio(len(viol_a & viol_b), len(viol_a)),
    }


def compare(a, b, check, worst=None, critical=1000):
    """Compare one check (setup or hold) of two snapshots.

    Unconstrained endpoints (e.g. outputs of CTS dummy loads) are ignored.
    Returns a dict with:
      only_a / only_b: constrained endpoints in only one netlist,
        [(endpoint, slack)]
      constrained_only_a / constrained_only_b: endpoints in both netlists
        but constrained in only one, [(endpoint, slack)]
      both: [(endpoint, slack_a, slack_b)], restricted to the union of the
        worst `worst` endpoints of A and of B if `worst` is given
      metrics: metrics() of all endpoints constrained in both
    """
    sa, sb = a[check], b[check]
    both = [ep for ep in sa if ep in sb]
    m = metrics({ep: sa[ep] for ep in both}, {ep: sb[ep] for ep in both}, critical)
    if worst:
        keep = worst_endpoints(sa, worst) | worst_endpoints(sb, worst)
        both = [ep for ep in both if ep in keep]
    return {
        "only_a": [(ep, sa[ep]) for ep in sa if ep not in b["endpoints"]],
        "only_b": [(ep, sb[ep]) for ep in sb if ep not in a["endpoints"]],
        "constrained_only_a": [
            (ep, sa[ep]) for ep in sa if ep not in sb and ep in b["endpoints"]
        ],
        "constrained_only_b": [
            (ep, sb[ep]) for ep in sb if ep not in sa and ep in a["endpoints"]
        ],
        "both": [(ep, sa[ep], sb[ep]) for ep in both],
        "metrics": m,
    }


def movement(both, tolerance=0.0):
    """Counts of how endpoint slack changed between A and B.

    improved/degraded/unchanged exclude endpoints with positive slack in
    both steps, which are not being optimized. Changes of at most
    `tolerance` (seconds) count as unchanged.
    """
    crit = [(s_a, s_b) for _, s_a, s_b in both if s_a <= 0 or s_b <= 0]
    return {
        "improved": sum(s_b - s_a > tolerance for s_a, s_b in crit),
        "degraded": sum(s_a - s_b > tolerance for s_a, s_b in crit),
        "unchanged": sum(abs(s_b - s_a) <= tolerance for s_a, s_b in crit),
        "newly_failing": sum(s_a >= 0 > s_b for _, s_a, s_b in both),
        "newly_passing": sum(s_b >= 0 > s_a for _, s_a, s_b in both),
    }


# Digits after the decimal point for each time unit
DIGITS = {"s": 12, "ns": 3, "ps": 1}


def _fmt(value, scale, digits):
    return "-" if value is None else f"{value * scale:.{digits}f}"


def _num(value, scale):
    return None if value is None else float(f"{value * scale:.6g}")


def _label(snapshot):
    """Step name, with the parasitics model the step was timed with."""
    if snapshot["parasitics"]:
        return f"{snapshot['name']} ({snapshot['parasitics']} parasitics)"
    return snapshot["name"]


def _summary_lines(cmp, check, scale, unit, digits, tolerance=0.0):
    m = movement(cmp["both"], tolerance)
    lines = [
        f"{check:5s} both={len(cmp['both'])} onlyA={len(cmp['only_a'])}"
        f" onlyB={len(cmp['only_b'])}"
        f" constrained only in A={len(cmp['constrained_only_a'])}"
        f" only in B={len(cmp['constrained_only_b'])}",
        f"      not positive in both: improved={m['improved']}"
        f" degraded={m['degraded']} unchanged={m['unchanged']}"
        f" newly failing={m['newly_failing']}"
        f" newly passing={m['newly_passing']}",
    ]
    if cmp["both"]:
        deltas = [(s_b - s_a) * scale for _, s_a, s_b in cmp["both"]]
        lines.append(
            f"      slack delta (B-A) {unit}:"
            f" mean={statistics.mean(deltas):.{digits}f}"
            f" median={statistics.median(deltas):.{digits}f}"
            f" min={min(deltas):.{digits}f} max={max(deltas):.{digits}f}"
        )
    mt = cmp["metrics"]
    lines.append(
        f"      critical (worst {mt['critical']} of A or B, not positive in"
        f" both): n={mt['n']} spearman={_fmt_num(mt['spearman'])}"
        f" top agreement={_fmt_num(mt['top_agreement'])}"
    )
    lines.append(
        f"        {unit}: bias={_fmt(mt['bias'], scale, digits)}"
        f" MAE={_fmt(mt['mae'], scale, digits)}"
        f" RMSE={_fmt(mt['rmse'], scale, digits)}"
        f" max|delta|={_fmt(mt['max_abs'], scale, digits)}"
    )
    lines.append(
        f"      violators: recall={_fmt_num(mt['violator_recall'])}"
        f" precision={_fmt_num(mt['violator_precision'])}"
    )
    return lines


def _fmt_num(value):
    return "-" if value is None else f"{value:.3f}"


def cmd_list(args):
    scale = UNITS[args.unit]
    header = f"{'step':32s} {'parasitics':14s} {'endpoints':>9s}"
    for check in CHECKS:
        header += f" {check + ' WNS':>10s} {check + ' TNS':>10s} {'#viol':>6s}"
    print(header + f"  ({args.unit})")
    for s in load_dir(args.reports_dir):
        line = f"{s['name']:32s} {s['parasitics']:14s} {len(s['endpoints']):9d}"
        for check in CHECKS:
            sm = summary(s[check])
            line += (
                f" {_fmt(sm['wns'], scale, args.digits):>10s}"
                f" {_fmt(sm['tns'], scale, args.digits):>10s}"
                f" {sm['violations']:6d}"
            )
        print(line)


def _pair_file(a, b):
    return f"{a['name']}__{b['name']}.html"


def cmd_track(args):
    scale = UNITS[args.unit]
    snaps = load_dir(args.reports_dir)
    pairs = list(zip(snaps, snaps[1:]))
    if args.html:
        os.makedirs(args.html, exist_ok=True)
    rows = []
    for i, (a, b) in enumerate(pairs):
        print(f"{_label(a)} -> {_label(b)}")
        cmps = {
            check: compare(a, b, check, args.worst, args.critical) for check in CHECKS
        }
        for check in CHECKS:
            for line in _summary_lines(
                cmps[check], check, scale, args.unit, args.digits, args.tolerance
            ):
                print("  " + line)
        rows.append((a, b, cmps))
        if args.html:
            links = [("index", "index.html")]
            if i > 0:
                links.insert(0, ("previous", _pair_file(*pairs[i - 1])))
            if i + 1 < len(pairs):
                links.append(("next", _pair_file(*pairs[i + 1])))
            page = compare_html(
                a,
                b,
                cmps,
                scale,
                args.unit,
                args.worst,
                links,
                args.digits,
                args.tolerance,
            )
            with open(os.path.join(args.html, _pair_file(a, b)), "w") as f:
                f.write(page)
    if args.html:
        index = os.path.join(args.html, "index.html")
        with open(index, "w") as f:
            f.write(
                track_index_html(
                    rows,
                    scale,
                    args.unit,
                    args.worst,
                    args.critical,
                    args.digits,
                    args.tolerance,
                )
            )
        print(f"Wrote {len(pairs)} comparisons to {args.html}, see {index}")


def track_index_html(rows, scale, unit, worst, critical=1000, digits=3, tolerance=0.0):
    """Index of step-to-step comparisons with a summary of each."""
    design = rows[0][0]["design"] if rows else ""

    # Cells are strings, or (before, after) pairs shown as "before -> after"
    table = []
    for a, b, cmps in rows:
        # Endpoints with positive slack in both steps are not considered
        changed = considered = improved = 0
        cells = []
        for check in CHECKS:
            cmp = cmps[check]
            m = movement(cmp["both"], tolerance)
            sa, sb = summary(a[check]), summary(b[check])
            added_removed = sum(
                s <= 0
                for key in (
                    "only_a",
                    "only_b",
                    "constrained_only_a",
                    "constrained_only_b",
                )
                for _, s in cmp[key]
            )
            changed += m["improved"] + m["degraded"] + added_removed
            considered += m["improved"] + m["degraded"] + m["unchanged"]
            considered += added_removed
            improved += m["improved"]
            cells += [
                (_fmt(sa["wns"], scale, digits), _fmt(sb["wns"], scale, digits)),
                (_fmt(sa["tns"], scale, digits), _fmt(sb["tns"], scale, digits)),
                str(m["improved"]),
                str(m["degraded"]),
                str(m["newly_failing"]),
                str(m["newly_passing"]),
                _fmt_num(cmp["metrics"]["spearman"]),
                _fmt_num(cmp["metrics"]["top_agreement"]),
                _fmt(cmp["metrics"]["mae"], scale, digits),
            ]
        if not changed:
            row_class = "same"
        elif improved == considered:
            row_class = "better"
        else:
            row_class = ""
        table.append((a, b, row_class, cells))

    # Pad both sides of the pairs to the column width so they line up
    widths = {}
    for _, _, _, cells in table:
        for i, c in enumerate(cells):
            if isinstance(c, tuple):
                w = widths.get(i, (0, 0))
                widths[i] = (max(w[0], len(c[0])), max(w[1], len(c[1])))

    def cell(i, c):
        if isinstance(c, tuple):
            wa, wb = widths[i]
            c = (
                f"<span class='v' style='min-width:{wa}ch'>{html.escape(c[0])}</span>"
                f" &rarr; <span class='v' style='min-width:{wb}ch'>"
                f"{html.escape(c[1])}</span>"
            )
        else:
            c = html.escape(c)
        return f"<td class='num'>{c}</td>"

    body = ""
    for a, b, row_class, cells in table:
        link = (
            f"<a href='{html.escape(_pair_file(a, b))}'>"
            f"{html.escape(a['name'])} &rarr; {html.escape(b['name'])}</a>"
        )
        parasitics = a["parasitics"]
        if b["parasitics"] != a["parasitics"]:
            parasitics += " &rarr; " + b["parasitics"]
        cls = f" class='{row_class}'" if row_class else ""
        tds = "".join(cell(i, c) for i, c in enumerate(cells))
        body += f"<tr{cls}><td>{link}</td><td>{parasitics}</td>{tds}</tr>\n"
    head = "".join(f"<th colspan='9'>{check}</th>" for check in CHECKS)
    sub = "".join(
        "<th>WNS</th><th>TNS</th><th>improved</th><th>degraded</th>"
        "<th>newly failing</th><th>newly passing</th>"
        "<th>Spearman</th><th>top agreement</th><th>MAE</th>"
        for _ in CHECKS
    )
    note = (
        f" Only the worst {worst} endpoints of each pair are compared." if worst else ""
    )
    return (
        TRACK_INDEX_TEMPLATE.replace(
            "__TITLE__", html.escape(f"{design} endpoint slack by step")
        )
        .replace("__UNIT__", unit)
        .replace("__NOTE__", html.escape(note))
        .replace("__CRITICAL__", str(critical))
        .replace("__TOL__", f"{tolerance * scale:g} {unit}")
        .replace("__HEAD__", head)
        .replace("__SUB__", sub)
        .replace("__BODY__", body)
    )


TRACK_INDEX_TEMPLATE = """<!doctype html>
<html><head><meta charset="utf-8"><title>__TITLE__</title>
<style>
:root { --bg:#fff; --fg:#222; --muted:#888; --grid:#ddd; --link:#2a7ab9;
        --better:#e3f4e1; }
@media (prefers-color-scheme: dark) {
  :root { --bg:#1b1b1b; --fg:#ddd; --muted:#888; --grid:#444; --link:#5aa9e6;
          --better:#1f3a22; }
}
body { background:var(--bg); color:var(--fg); margin:0;
       font:14px system-ui, sans-serif; padding:16px; }
h1 { font-size:18px; margin:0 0 4px; }
.muted { color:var(--muted); }
.wrap { overflow-x:auto; margin-top:12px; }
table { border-collapse:collapse; font-size:13px; }
th, td { padding:3px 8px; border-bottom:1px solid var(--grid); text-align:left;
         white-space:nowrap; }
td.num { text-align:right; white-space:pre;
         font-family:ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.v { display:inline-block; text-align:right; }
a { color:var(--link); }
tr.same td { color:var(--muted); }
tr.better td { background:var(--better); }
</style></head><body>
<h1>__TITLE__</h1>
<div class="muted">Each row compares a step with the next one (__UNIT__).
Endpoints with positive slack in both steps are not considered, and slack
changes of at most __TOL__ count as unchanged. Grey rows:
no considered endpoint changed. Green rows: every considered endpoint
improved (setup and hold). Spearman, top agreement and MAE are
measured on the critical set: the worst __CRITICAL__ endpoints of either step,
excluding those with positive slack in both.__NOTE__</div>
<div class="wrap"><table>
<tr><th rowspan="2">steps</th><th rowspan="2">parasitics</th>__HEAD__</tr>
<tr>__SUB__</tr>
__BODY__</table></div>
</body></html>
"""


def cmd_compare(args):
    scale = UNITS[args.unit]
    a = load_snapshot(args.a)
    b = load_snapshot(args.b)
    print(f"A: {_label(a)}\nB: {_label(b)}")
    if args.worst:
        print(f"Endpoints in both restricted to the worst {args.worst} of A or B")
    cmps = {check: compare(a, b, check, args.worst, args.critical) for check in CHECKS}
    for check in CHECKS:
        for line in _summary_lines(
            cmps[check], check, scale, args.unit, args.digits, args.tolerance
        ):
            print(line)
    if args.output:
        with open(args.output, "w") as f:
            f.write(
                compare_html(
                    a,
                    b,
                    cmps,
                    scale,
                    args.unit,
                    args.worst,
                    digits=args.digits,
                    tolerance=args.tolerance,
                )
            )
        print(f"Wrote {args.output}")


def cmd_export(args):
    scale = UNITS[args.unit]
    out = open(args.output, "w", newline="") if args.output else sys.stdout
    writer = csv.writer(out)
    writer.writerow(
        [
            "order",
            "step",
            "parasitics",
            "endpoint",
            f"setup_{args.unit}",
            f"hold_{args.unit}",
        ]
    )
    for order, s in enumerate(load_dir(args.reports_dir)):
        for ep in sorted(s["endpoints"]):
            writer.writerow(
                [
                    order,
                    s["step"],
                    s["parasitics"],
                    ep,
                    _num(s["setup"].get(ep), scale),
                    _num(s["hold"].get(ep), scale),
                ]
            )
    if args.output:
        out.close()


def compare_html(a, b, cmps, scale, unit, worst, links=(), digits=3, tolerance=0.0):
    """Self-contained interactive HTML for a two-snapshot comparison.

    links: optional (label, href) navigation links shown above the title.
    """
    data = {}
    for check, cmp in cmps.items():
        data[check] = {
            "both": [
                [ep, _num(s_a, scale), _num(s_b, scale)] for ep, s_a, s_b in cmp["both"]
            ],
            "only_a": sorted(
                ([ep, _num(s, scale)] for ep, s in cmp["only_a"]), key=lambda r: r[0]
            ),
            "only_b": sorted(
                ([ep, _num(s, scale)] for ep, s in cmp["only_b"]), key=lambda r: r[0]
            ),
            "constrained_only_a": len(cmp["constrained_only_a"]),
            "constrained_only_b": len(cmp["constrained_only_b"]),
            "summary_a": {
                k: _num(v, scale) if k in ("wns", "tns") else v
                for k, v in summary(a[check]).items()
            },
            "summary_b": {
                k: _num(v, scale) if k in ("wns", "tns") else v
                for k, v in summary(b[check]).items()
            },
            "metrics": {
                k: _num(v, scale) if k in ("bias", "mae", "rmse", "max_abs") else v
                for k, v in cmp["metrics"].items()
            },
        }
    title = f"{a['design']} {a['name']} vs {b['name']}"
    note = f" Only the worst {worst} endpoints of A or B are plotted." if worst else ""
    return (
        HTML_TEMPLATE.replace("__TITLE__", html.escape(title))
        .replace("__A__", html.escape(a["name"]))
        .replace("__B__", html.escape(b["name"]))
        .replace("__PAR_A__", html.escape(a["parasitics"] or "unknown"))
        .replace("__PAR_B__", html.escape(b["parasitics"] or "unknown"))
        .replace("__NOTE__", html.escape(note))
        .replace(
            "__NAV__",
            " | ".join(
                f"<a href='{html.escape(href)}'>{html.escape(label)}</a>"
                for label, href in links
            ),
        )
        .replace("__UNIT__", unit)
        .replace("__DIGITS__", str(digits))
        .replace("__TOL__", repr(tolerance * scale))
        .replace("__DATA__", json.dumps(data).replace("</", "<\\/"))
    )


HTML_TEMPLATE = """<!doctype html>
<html><head><meta charset="utf-8"><title>__TITLE__</title>
<style>
:root { --bg:#fff; --fg:#222; --muted:#777; --grid:#ddd; --better:#2a7ab9;
        --worse:#d9622b; --same:#999; --line:#999; }
@media (prefers-color-scheme: dark) {
  :root { --bg:#1b1b1b; --fg:#ddd; --muted:#999; --grid:#444;
          --better:#5aa9e6; --worse:#f08a4b; --same:#888; --line:#777; }
}
body { background:var(--bg); color:var(--fg); margin:0;
       font:14px system-ui, sans-serif; padding:16px; }
h1 { font-size:18px; margin:0 0 4px; }
h3 { margin:16px 0 6px; }
.muted { color:var(--muted); }
.tabs button { font:inherit; padding:4px 12px; margin-right:4px;
               border:1px solid var(--grid); background:var(--bg);
               color:var(--fg); border-radius:4px; cursor:pointer; }
.tabs button.on { border-color:var(--fg); font-weight:600; }
.stats { display:flex; flex-wrap:wrap; gap:16px; margin:12px 0; }
.stat b { display:block; font-size:20px; }
.stat b, td.num, .tip { font-family:ui-monospace, SFMono-Regular, Menlo,
                         Consolas, monospace; }
.plot { position:relative; max-width:680px; }
canvas { width:100%; height:auto; display:block; cursor:crosshair; }
.tip { position:fixed; pointer-events:none; background:var(--bg);
       border:1px solid var(--grid); padding:6px 8px; border-radius:4px;
       font-size:12px; max-width:600px; word-break:break-all; }
.tables { display:flex; flex-wrap:wrap; gap:16px; }
.tables > div { flex:1 1 400px; min-width:0; }
.scroll { max-height:360px; overflow:auto; border:1px solid var(--grid); }
table { border-collapse:collapse; width:100%; font-size:12px; }
th, td { text-align:left; padding:2px 6px; border-bottom:1px solid var(--grid);
         word-break:break-all; }
th { position:sticky; top:0; background:var(--bg); }
td.num { text-align:right; white-space:nowrap; }
nav { margin-bottom:8px; }
nav a { color:var(--better); }
</style></head><body>
<nav>__NAV__</nav>
<h1>__TITLE__</h1>
<div class="muted">Endpoint slack: x = A (__A__), y = B (__B__), __UNIT__.
Parasitics: A __PAR_A__, B __PAR_B__.__NOTE__
Drag to zoom, double-click to reset.</div>
<div class="tabs" style="margin-top:12px">
 <button data-t="setup">Setup</button><button data-t="hold">Hold</button>
</div>
<div class="stats" id="stats"></div>
<div class="muted">Improved and degraded exclude endpoints with positive
slack in both steps.</div>
<div class="muted" id="critnote"></div>
<div class="stats" id="crit"></div>
<div class="plot"><canvas id="plot" width="680" height="680"></canvas></div>
<div class="tables">
 <div><h3>Most degraded</h3>
  <div class="muted">Excluding endpoints with positive slack in both</div>
  <div class="scroll" id="worse"></div></div>
 <div><h3>Most improved</h3>
  <div class="muted">Excluding endpoints with positive slack in both</div>
  <div class="scroll" id="better"></div></div>
</div>
<div class="tables">
 <div><h3>Endpoints only in A (__A__)</h3><div class="scroll" id="onlyA"></div></div>
 <div><h3>Endpoints only in B (__B__)</h3><div class="scroll" id="onlyB"></div></div>
</div>
<div class="tip" id="tip" hidden></div>
<script>
const DATA = __DATA__;
const DIGITS = __DIGITS__;
// Slack changes of at most TOL count as unchanged
const TOL = __TOL__;
const LIMIT = 500;
const canvas = document.getElementById("plot");
const ctx = canvas.getContext("2d");
const tip = document.getElementById("tip");
const W = canvas.width, M = 64, P = 16;
let cur = null, view = null, drag = null, grid = null;

function css(v) {
  return getComputedStyle(document.documentElement).getPropertyValue(v).trim();
}
function esc(s) {
  return String(s).replace(/[&<>"]/g,
    c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
}
function fmt(v) { return v === null ? "unconstrained" : v.toFixed(DIGITS); }
function ticks(lo, hi, n) {
  const step0 = (hi - lo) / n, mag = Math.pow(10, Math.floor(Math.log10(step0)));
  const step = [1, 2, 5, 10].map(m => m * mag).find(s => s >= step0);
  const out = [];
  for (let i = Math.ceil(lo / step); i * step <= hi; i++)
    out.push(i === 0 ? 0 : +(i * step).toPrecision(6));
  return out;
}
function table(rows, cols) {
  if (!rows.length) return "<p class='muted'>none</p>";
  const more = rows.length > LIMIT ?
    "<p class='muted'>showing " + LIMIT + " of " + rows.length + "</p>" : "";
  return more + "<table><tr>" + cols.map(c => "<th>" + c + "</th>").join("") +
    "</tr>" + rows.slice(0, LIMIT).map(r => "<tr><td>" + esc(r[0]) + "</td>" +
    r.slice(1).map(v => "<td class='num'>" + fmt(v) + "</td>").join("") +
    "</tr>").join("") + "</table>";
}
function sx(v) { return M + (v - view.lo) / (view.hi - view.lo) * (W - M - P); }
function sy(v) { return W - M - (v - view.lo) / (view.hi - view.lo) * (W - M - P); }
function ux(px) { return view.lo + (px - M) / (W - M - P) * (view.hi - view.lo); }
function uy(py) { return view.lo + (W - M - py) / (W - M - P) * (view.hi - view.lo); }

function fullView(both) {
  let lo = Infinity, hi = -Infinity;
  for (const p of both) {
    lo = Math.min(lo, p[1], p[2]); hi = Math.max(hi, p[1], p[2]);
  }
  lo = Math.min(lo, 0); hi = Math.max(hi, 0);
  const pad = (hi - lo) * 0.05 || 1;
  return {lo: lo - pad, hi: hi + pad};
}

function draw() {
  const both = cur.both;
  ctx.clearRect(0, 0, W, W);
  ctx.font = "12px system-ui, sans-serif";
  ctx.fillStyle = css("--fg");
  if (!both.length) {
    ctx.textAlign = "center";
    ctx.fillText("No endpoints in both", W / 2, W / 2);
    return;
  }
  ctx.strokeStyle = css("--grid");
  ctx.lineWidth = 1;
  for (const v of ticks(view.lo, view.hi, 6)) {
    ctx.beginPath();
    ctx.moveTo(sx(v), sy(view.lo)); ctx.lineTo(sx(v), sy(view.hi));
    ctx.moveTo(sx(view.lo), sy(v)); ctx.lineTo(sx(view.hi), sy(v));
    ctx.stroke();
    ctx.textAlign = "center"; ctx.fillText(v, sx(v), W - M + 16);
    ctx.textAlign = "right"; ctx.fillText(v, M - 6, sy(v) + 4);
  }
  ctx.strokeStyle = css("--line");
  ctx.beginPath();
  ctx.moveTo(sx(0), sy(view.lo)); ctx.lineTo(sx(0), sy(view.hi));
  ctx.moveTo(sx(view.lo), sy(0)); ctx.lineTo(sx(view.hi), sy(0));
  ctx.stroke();
  ctx.setLineDash([4, 4]);
  ctx.beginPath();
  ctx.moveTo(sx(view.lo), sy(view.lo)); ctx.lineTo(sx(view.hi), sy(view.hi));
  ctx.stroke();
  ctx.setLineDash([]);
  ctx.textAlign = "center";
  ctx.fillText("slack A: __A__ (__UNIT__)", (M + W) / 2, W - 16);
  ctx.save();
  ctx.translate(16, (W - M) / 2); ctx.rotate(-Math.PI / 2);
  ctx.fillText("slack B: __B__ (__UNIT__)", 0, 0);
  ctx.restore();

  // Clip to the plot area and bucket visible points for hover lookup
  ctx.save();
  ctx.beginPath();
  ctx.rect(M, P, W - M - P, W - M - P);
  ctx.clip();
  const r = both.length > 20000 ? 1.5 : 3;
  ctx.globalAlpha = both.length > 20000 ? 0.4 : 0.7;
  const colors = {better: css("--better"), worse: css("--worse"),
                  same: css("--same")};
  grid = new Map();
  for (const p of both) {
    const x = sx(p[1]), y = sy(p[2]);
    if (x < M || x > W - P || y < P || y > W - M) continue;
    ctx.fillStyle = p[2] > p[1] ? colors.better
                  : p[2] < p[1] ? colors.worse : colors.same;
    ctx.fillRect(x - r, y - r, 2 * r, 2 * r);
    const key = Math.floor(x / 8) + "," + Math.floor(y / 8);
    if (!grid.has(key)) grid.set(key, []);
    grid.get(key).push(p);
  }
  ctx.restore();
  if (drag && drag.x1 !== undefined) {
    ctx.strokeStyle = css("--fg");
    ctx.strokeRect(drag.x0, drag.y0, drag.x1 - drag.x0, drag.y1 - drag.y0);
  }
}

function canvasXY(e) {
  const rect = canvas.getBoundingClientRect();
  return [(e.clientX - rect.left) * W / rect.width,
          (e.clientY - rect.top) * W / rect.height];
}
function nearest(x, y) {
  let best = null, bestD = 64;
  const gx = Math.floor(x / 8), gy = Math.floor(y / 8);
  for (let i = gx - 1; i <= gx + 1; i++)
    for (let j = gy - 1; j <= gy + 1; j++)
      for (const p of grid.get(i + "," + j) || []) {
        const d = (sx(p[1]) - x) ** 2 + (sy(p[2]) - y) ** 2;
        if (d < bestD) { bestD = d; best = p; }
      }
  return best;
}
canvas.addEventListener("mousedown", e => {
  const [x, y] = canvasXY(e);
  drag = {x0: x, y0: y};
});
canvas.addEventListener("mousemove", e => {
  const [x, y] = canvasXY(e);
  if (drag) {
    drag.x1 = x; drag.y1 = y; tip.hidden = true; draw(); return;
  }
  const p = grid && nearest(x, y);
  if (!p) { tip.hidden = true; return; }
  tip.hidden = false;
  tip.style.left = (e.clientX + 12) + "px";
  tip.style.top = (e.clientY + 12) + "px";
  tip.innerHTML = esc(p[0]) + "<br>A " + fmt(p[1]) + "  B " + fmt(p[2]) +
    "  (B-A " + fmt(p[2] - p[1]) + ")";
});
window.addEventListener("mouseup", () => {
  if (!drag) return;
  const d = drag; drag = null;
  if (d.x1 !== undefined && Math.abs(d.x1 - d.x0) > 5 &&
      Math.abs(d.y1 - d.y0) > 5) {
    // Keep the axes equal so the y = x line stays diagonal
    const xs = [ux(d.x0), ux(d.x1)], ys = [uy(d.y0), uy(d.y1)];
    view = {lo: Math.min(...xs, ...ys), hi: Math.max(...xs, ...ys)};
  }
  draw();
});
canvas.addEventListener("mouseleave", () => { tip.hidden = true; });
canvas.addEventListener("dblclick", () => {
  view = fullView(cur.both); draw();
});

function show(t) {
  document.querySelectorAll(".tabs button").forEach(
    b => b.classList.toggle("on", b.dataset.t === t));
  cur = DATA[t];
  const both = cur.both;
  let better = 0, worse = 0, nowFail = 0, nowPass = 0;
  for (const p of both) {
    // Endpoints with positive slack in both steps are not being optimized
    if (p[1] <= 0 || p[2] <= 0) {
      if (p[2] - p[1] > TOL) better++; else if (p[1] - p[2] > TOL) worse++;
    }
    if (p[1] >= 0 && p[2] < 0) nowFail++;
    if (p[1] < 0 && p[2] >= 0) nowPass++;
  }
  const a = cur.summary_a, b = cur.summary_b;
  document.getElementById("stats").innerHTML = [
    ["WNS A / B", fmt(a.wns) + " / " + fmt(b.wns)],
    ["TNS A / B", fmt(a.tns) + " / " + fmt(b.tns)],
    ["violations A / B", a.violations + " / " + b.violations],
    ["in both", both.length], ["improved", better], ["degraded", worse],
    ["newly failing", nowFail], ["newly passing", nowPass],
    ["only in A / B", cur.only_a.length + " / " + cur.only_b.length],
    ["constrained only in A / B",
     cur.constrained_only_a + " / " + cur.constrained_only_b]]
    .map(s => "<div class='stat'><b>" + s[1] + "</b>" + s[0] + "</div>").join("");
  const mt = cur.metrics;
  const ratio = v => v === null ? "–" : v.toFixed(3);
  const time = v => v === null ? "–" : v.toFixed(DIGITS);
  document.getElementById("critnote").textContent =
    "Critical set: worst " + mt.critical + " endpoints of A or B, excluding" +
    " those with positive slack in both (__UNIT__)";
  document.getElementById("crit").innerHTML = [
    ["critical endpoints", mt.n], ["Spearman", ratio(mt.spearman)],
    ["top agreement", ratio(mt.top_agreement)], ["bias", time(mt.bias)],
    ["MAE", time(mt.mae)], ["RMSE", time(mt.rmse)],
    ["max |B-A|", time(mt.max_abs)],
    ["violator recall", ratio(mt.violator_recall)],
    ["violator precision", ratio(mt.violator_precision)]]
    .map(s => "<div class='stat'><b>" + s[1] + "</b>" + s[0] + "</div>").join("");
  const cols = ["endpoint", "A", "B", "B-A"];
  // Endpoints with positive slack in both steps are not being optimized
  const moved = both.filter(p => p[1] <= 0 || p[2] <= 0)
    .map(p => [p[0], p[1], p[2], p[2] - p[1]]);
  document.getElementById("worse").innerHTML = table(
    moved.filter(p => p[3] < -TOL).sort((x, y) => x[3] - y[3]), cols);
  document.getElementById("better").innerHTML = table(
    moved.filter(p => p[3] > TOL).sort((x, y) => y[3] - x[3]), cols);
  document.getElementById("onlyA").innerHTML = table(cur.only_a, ["endpoint", "slack"]);
  document.getElementById("onlyB").innerHTML = table(cur.only_b, ["endpoint", "slack"]);
  view = fullView(both);
  draw();
}
document.querySelectorAll(".tabs button").forEach(
  b => b.addEventListener("click", () => show(b.dataset.t)));
show("setup");
</script></body></html>
"""


def main(argv=None):
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    def common(p, worst=True):
        p.add_argument("--unit", choices=UNITS, default="ns")
        p.add_argument(
            "--digits",
            type=int,
            help="digits after the decimal point for times"
            " (default: 3 for ns, 1 for ps)",
        )
        p.add_argument(
            "--tolerance",
            type=float,
            help="slack changes of at most this much (in --unit) count as"
            " unchanged (default: half the last displayed digit, so a change"
            " shown as 0 is unchanged)",
        )
        if worst:
            p.add_argument(
                "--worst",
                type=int,
                metavar="N",
                help="only compare the worst N endpoints of A or B",
            )
            p.add_argument(
                "--critical",
                type=int,
                default=1000,
                metavar="K",
                help="correlation and error are measured on the worst K"
                " endpoints of A or B, excluding those with positive slack in"
                " both (default 1000)",
            )

    p = sub.add_parser("list", help="list snapshots with WNS/TNS per step")
    p.add_argument("reports_dir")
    common(p, worst=False)
    p.set_defaults(func=cmd_list)

    p = sub.add_parser("track", help="compare consecutive snapshots")
    p.add_argument("reports_dir")
    p.add_argument(
        "--html",
        metavar="DIR",
        help="write an HTML scatter for every step vs. its successor and an"
        " index.html to DIR",
    )
    common(p)
    p.set_defaults(func=cmd_track)

    p = sub.add_parser("compare", help="compare two snapshots")
    p.add_argument("a", help="earlier snapshot (x axis)")
    p.add_argument("b", help="later snapshot (y axis)")
    p.add_argument("-o", "--output", help="write interactive HTML scatter")
    common(p)
    p.set_defaults(func=cmd_compare)

    p = sub.add_parser("export", help="flatten all snapshots to CSV")
    p.add_argument("reports_dir")
    p.add_argument("-o", "--output", help="CSV file (default stdout)")
    common(p, worst=False)
    p.set_defaults(func=cmd_export)

    args = parser.parse_args(argv)
    if args.digits is None:
        args.digits = DIGITS[args.unit]
    if args.tolerance is None:
        args.tolerance = 0.5 * 10**-args.digits
    # Internally slack is in seconds
    args.tolerance /= UNITS[args.unit]
    args.func(args)


if __name__ == "__main__":
    main()
