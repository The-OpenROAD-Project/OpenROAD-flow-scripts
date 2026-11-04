#!/usr/bin/env python3
"""
Generate reports from current logs
"""

import argparse
import os
import re
import textwrap
from collections import Counter

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

LOGS_FOLDER = "logs"
REPORTS_FOLDER = "reports"
REPORT_FILENAME = "report.log"
SINGLE_REPORT_FILENAME = f"{REPORTS_FOLDER}/report.log"
SUMMARY_FILENAME = f"{REPORTS_FOLDER}/report-summary.log"
DRC_FILENAME = "5_route_drc.rpt"
LAST_EXPECTED_LOG = ["6_report.log", "generate_abstract.log"]
METRICS_LOG = "metadata-generate.log"
METRICS_CHECK_LOG = "metadata-check.log"
CALIBRE_LOG = "calibre/save-to-drc-db.log"
REGEX_ERROR = re.compile(r"^\[error ?(\w+-\d+)?\]", re.IGNORECASE)
REGEX_WARNING = re.compile(r"^\[warning ?(\w+-\d+)?\]", re.IGNORECASE)
REGEX_SIGNAL = re.compile(r"\bsignal (\d+)|\bKilled\b")
# Metric line under "QoR regression detected for ...":
#   <metric> <current> (base <base>, limit <limit>)
REGEX_QOR_METRIC = re.compile(r"^(\S+) (\S+) \(base (\S+), limit (\S+)\)$")
REGEX_QOR_STATUS = re.compile(r"^Dashboard QoR check: (\w+)")
# checkQorMetrics.py starts its lines with the run identity.
REGEX_RUN_PREFIX = re.compile(r"^[^\s/]+/[^\s/]+/[^\s/:]+: ")
SKIPPED_FLOW_VARIANT_KEYWORDS = ["test", "tune"]
STATUS_GREEN = "Passing"
STATUS_RED = "Failing"
TAIL_LINES = 10
RULE = "-" * 60

# Failure categories, most critical first. The summary sorts by this order.
CATEGORIES = {
    "STOP": "flow stopped",
    "ERR": "flow error",
    "DRC": "Calibre DRC",
    "QOR": "QoR regression",
}
CATEGORY_RANK = {code: rank for rank, code in enumerate(CATEGORIES)}
WARN = "WARN"
PASS = "PASS"

HELP_TEXT = """
Scans "./logs" and "./reports" folders for errors and warnings.
"""
parser = argparse.ArgumentParser(description=HELP_TEXT)

HELP_TEXT = """
Level 0: report error message ids.
Level 1: report full error messages.
Level 2: also report passing designs and warning message ids.
Level 3: also report full warning messages.
"""
parser.add_argument(
    "--verbose", "-v", required=False, default=0, action="count", help=HELP_TEXT
)

parser.add_argument(
    "--quiet",
    "-q",
    required=False,
    default=False,
    action="store_true",
    help="Do not print report to stdout.",
)

parser.add_argument(
    "--summary",
    "-s",
    required=False,
    default=False,
    action="store_true",
    help="Only write summary file.",
)

args = parser.parse_args()


def read_lines(filename):
    """Return the lines of a file, or None if it cannot be read."""
    try:
        with open(filename, "r", encoding="utf-8", errors="replace") as file:
            return file.readlines()
    except OSError:
        return None


def parse_messages(lines, source):
    """Return ([ERROR] lines, [WARNING] lines) as (source, text) pairs."""
    errors = []
    warnings = []
    for line in lines or []:
        if REGEX_ERROR.search(line):
            errors.append((source, line.strip()))
        elif REGEX_WARNING.search(line):
            warnings.append((source, line.strip()))
    return errors, warnings


def parse_qor_check(lines):
    """
    Read a metadata-check.log written by checkQorMetrics.py or the CI check.

    Returns (metrics, baseline, notes). Each metric is a tuple
    (name, current, base, limit), or a 1-tuple with the raw line when the
    format is unknown. Notes say why the QoR check did not give a verdict.
    """
    metrics = []
    baseline = None
    notes = []
    in_regressions = False
    for line in lines or []:
        text = line.strip()
        if line.startswith("QoR regression detected for "):
            in_regressions = True
            continue
        if text.startswith("Baseline: "):
            baseline = text.split(" ", 1)[1]
            continue
        if in_regressions and line.startswith("  ") and text:
            match = REGEX_QOR_METRIC.match(text)
            metrics.append(match.groups() if match else (text,))
            continue
        in_regressions = False
        status = REGEX_QOR_STATUS.match(text)
        if status and status.group(1) not in ("PASS", "FAIL"):
            notes.append(f"QoR check {status.group(1)}")
        elif text.startswith("Reason: "):
            reason = text.split(" ", 1)[1]
            if notes and notes[-1].startswith("QoR check "):
                notes[-1] += f": {reason}"
            else:
                notes.append(f"QoR check: {reason}")
        elif text.startswith("[WARN] "):
            message = REGEX_RUN_PREFIX.sub("", text[len("[WARN] ") :])
            notes.append(f"QoR: {message}")
    return metrics, baseline, notes


def message_id(text, regex):
    """Return the message id (e.g. GPL-0307), or the full text if it has none."""
    match = regex.match(text)
    return match.group(1) if match and match.group(1) else text


def shorten(text, width=90):
    return textwrap.shorten(text, width=width, placeholder=" ...")


def collect(log_dir, files, report_dir):
    """Read the logs and reports of one design and classify it."""
    d = dict()
    d["output_file"] = os.path.join(report_dir, REPORT_FILENAME)
    d["log_dir"] = log_dir

    d["log_errors"] = []
    d["log_warnings"] = []
    d["last_log"] = ""
    for name in sorted(files):
        errors, warnings = parse_messages(read_lines(os.path.join(log_dir, name)), name)
        d["log_errors"] += errors
        d["log_warnings"] += warnings
        if name.endswith(".log"):
            d["last_log"] = name
    d["finished"] = any(name in files for name in LAST_EXPECTED_LOG)

    missing = []

    lines = read_lines(os.path.join(report_dir, METRICS_LOG))
    if lines is None and d["finished"]:
        missing.append(METRICS_LOG)
    d["metrics_logs_errors"], d["metrics_logs_warnings"] = parse_messages(
        lines, METRICS_LOG
    )

    lines = read_lines(os.path.join(report_dir, METRICS_CHECK_LOG))
    if lines is None and d["finished"]:
        missing.append(METRICS_CHECK_LOG)
    errors, _ = parse_messages(lines, METRICS_CHECK_LOG)
    # checkQorMetrics.py repeats the failing runs in a trailing line.
    d["metrics_errors"] = [
        e for e in errors if not e[1].startswith("[ERROR] Failing runs:")
    ]
    d["qor_metrics"], d["qor_baseline"], qor_notes = parse_qor_check(lines)

    d["calibre_errors"], d["calibre_warnings"] = parse_messages(
        read_lines(os.path.join(log_dir, CALIBRE_LOG)), CALIBRE_LOG
    )

    d["drcs"] = Counter()
    lines = read_lines(os.path.join(report_dir, DRC_FILENAME))
    if lines is None and d["finished"]:
        missing.append(DRC_FILENAME)
    for line in lines or []:
        if "violation type:" in line:
            d["drcs"][line.split("violation type:", 1)[1].strip()] += 1

    d["tail"] = []
    d["cause"] = ""
    if not d["finished"] and d["last_log"]:
        tail = read_lines(os.path.join(log_dir, d["last_log"])) or []
        d["tail"] = [line.rstrip() for line in tail[-TAIL_LINES:]]
        for line in reversed(d["tail"]):
            match = REGEX_SIGNAL.search(line)
            if match:
                signal = match.group(1) or "9"
                d["cause"] = f"killed by signal {signal}"
                if signal == "9":
                    d["cause"] += " (out of memory?)"
                break

    if not d["finished"]:
        d["category"] = "STOP"
    elif d["log_errors"]:
        d["category"] = "ERR"
    elif d["calibre_errors"]:
        d["category"] = "DRC"
    elif d["metrics_errors"]:
        d["category"] = "QOR"
    else:
        d["category"] = None
    d["status"] = STATUS_RED if d["category"] else STATUS_GREEN

    notes = list(qor_notes)
    if missing:
        notes.append("missing " + ", ".join(missing))
    if d["status"] == STATUS_GREEN:
        if d["metrics_logs_errors"]:
            notes.append(f"{len(d['metrics_logs_errors'])} error(s) in {METRICS_LOG}")
        if d["drcs"]:
            notes.append(f"router DRC under the limit: {format_drcs(d['drcs'])}")
    d["notes"] = notes
    return d


def format_drcs(drcs):
    return ", ".join(f"{name} ({count})" for name, count in drcs.items())


def qor_names(data):
    return [metric[0] for metric in data["qor_metrics"] if len(metric) == 4]


def row_code(data):
    if data["category"]:
        return data["category"]
    return WARN if data["notes"] else PASS


def sort_key(item):
    """Most critical first; more regressed metrics first within QoR."""
    name, data = item
    code = row_code(data)
    rank = CATEGORY_RANK.get(code, len(CATEGORY_RANK) + (code == PASS))
    return (rank, -len(data["qor_metrics"]), name)


def first_error(errors):
    """Short form of the last error: the one most likely to stop the flow."""
    source, text = errors[-1]
    more = f" (+{len(errors) - 1} more)" if len(errors) > 1 else ""
    return f"{source}: {message_id(text, REGEX_ERROR)}{more}"


def row_reason(data):
    """One-line reason for the summary table."""
    code = row_code(data)
    if code == "STOP":
        if data["log_errors"]:
            return first_error(data["log_errors"])
        if not data["last_log"]:
            return "no log file found"
        return f"{data['last_log']}: {data['cause'] or 'no error message'}"
    if code == "ERR":
        return first_error(data["log_errors"])
    if code == "DRC":
        return f"Calibre: {len(data['calibre_errors'])} error(s)"
    if code == "QOR":
        names = qor_names(data)
        if not names:
            return message_id(data["metrics_errors"][0][1], REGEX_ERROR)
        if len(names) == 1:
            return names[0]
        return f"{len(names)} metrics: " + ", ".join(names)
    if code == WARN:
        more = len(data["notes"]) - 1
        return data["notes"][0] + (f" (+{more} more)" if more else "")
    return "passed"


def headline(data):
    """Short description after the design name in the detail block."""
    code = data["category"]
    if code == "STOP":
        if not data["last_log"]:
            return "flow did not reach last stage, no log file found"
        text = f"stopped in {data['last_log']}"
        return f"{text}, {data['cause']}" if data["cause"] else text
    if code == "ERR":
        return f"{len(data['log_errors'])} error(s) in the logs"
    if code == "DRC":
        return f"{len(data['calibre_errors'])} Calibre error(s)"
    if code == "QOR":
        count = len(data["qor_metrics"])
        if count == 0:
            return "QoR check failed"
        return f"{count} metric{'s' if count > 1 else ''} over the limit"
    return "passed"


def message_lines(messages, regex, full):
    """
    Lines for a list of (source, text) messages.
    Full mode shows each distinct message with a repeat count.
    Otherwise one line per source with the distinct message ids.
    """
    lines = []
    if full:
        for (source, text), count in Counter(messages).items():
            repeat = f" (x{count})" if count > 1 else ""
            lines.append(f"{source}: {text}{repeat}")
        return lines
    by_source = {}
    for source, text in messages:
        by_source.setdefault(source, {})[message_id(text, regex)] = None
    for source, ids in by_source.items():
        lines.append(f"{source}: {', '.join(ids)}")
    return lines


def qor_table(metrics):
    rows = [("metric", "current", "base", "limit")]
    rows += [m for m in metrics if len(m) == 4]
    lines = []
    if len(rows) > 1:
        width = max(len(row[0]) for row in rows)
        for row in rows:
            lines.append(
                f"{row[0]:<{width}}  {row[1]:<12}  {row[2]:<12}  {row[3]}".rstrip()
            )
    lines += [m[0] for m in metrics if len(m) == 1]
    return lines


def gen_report(name, data, shared_baseline=None):
    """Detail block for one design. Empty for a passing design without notes."""
    verbose = args.verbose
    if data["status"] == STATUS_GREEN and not data["notes"] and verbose < 2:
        return ""

    body = []
    if data["category"] == "STOP" and data["tail"] and not data["log_errors"]:
        body.append(f"Last {len(data['tail'])} lines of {data['last_log']}:")
        body += [f"  {line}" for line in data["tail"]]
    full = verbose >= 1
    body += message_lines(data["log_errors"], REGEX_ERROR, full)
    body += message_lines(data["metrics_logs_errors"], REGEX_ERROR, full)
    body += message_lines(data["calibre_errors"], REGEX_ERROR, full)
    if data["metrics_errors"]:
        if data["qor_metrics"]:
            body += qor_table(data["qor_metrics"])
        else:
            body += [text for _, text in data["metrics_errors"]]
        if data["qor_baseline"] and data["qor_baseline"] != shared_baseline:
            body.append(f"Baseline: {data['qor_baseline']}")
    if data["drcs"] and data["status"] == STATUS_RED:
        body.append(f"Router DRC: {format_drcs(data['drcs'])}")
    if data["status"] == STATUS_RED:
        body += [f"Note: {note}" for note in data["notes"]]
    if verbose >= 2:
        warnings = (
            data["log_warnings"]
            + data["metrics_logs_warnings"]
            + data["calibre_warnings"]
        )
        body += message_lines(warnings, REGEX_WARNING, verbose >= 3)

    if data["status"] == STATUS_GREEN:
        lines = [f"{name}: {note}" for note in data["notes"]] or [f"{name}: passed"]
    else:
        lines = [f"{name}: {headline(data)}"]
    lines += [f"    {line}" for line in body]
    return "\n".join(lines)


def write_report(path, content):
    """Write one design report and append it to the combined report."""
    content = content.strip()
    # A flow that stops before its first stage has no reports directory.
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as file:
        file.write(content)
    if args.verbose:
        content += f"\n  Generated report file: {path}\n"
    with open(SINGLE_REPORT_FILENAME, "a") as file:
        file.write(content)
        file.write("\n")
    if not args.quiet and content != "":
        print(content)


def section(title):
    return f"{RULE}\n{title}\n{RULE}\n"


def summary_header(designs):
    failing = [d for d in designs.values() if d["status"] == STATUS_RED]
    lines = ["=" * 60]
    lines.append(
        f"SUMMARY: {len(designs)} design{'s' if len(designs) != 1 else ''}, {len(failing)} failing, "
        f"{len(designs) - len(failing)} passing"
    )
    if failing:
        counts = Counter(d["category"] for d in failing)
        lines.append(
            "  "
            + " | ".join(
                f"{label} {counts[code]}" for code, label in CATEGORIES.items()
            )
        )
    regressed = Counter(name for d in failing for name in qor_names(d))
    common = [(name, n) for name, n in regressed.most_common(3) if n > 1]
    if common:
        lines.append(
            "  Most regressed: " + ", ".join(f"{name} ({n})" for name, n in common)
        )
    baselines = {d["qor_baseline"] for d in failing if d["metrics_errors"]}
    shared_baseline = baselines.pop() if len(baselines) == 1 else None
    if shared_baseline:
        lines.append(f"  QoR baseline: {shared_baseline}")
    lines.append("=" * 60)
    return "\n".join(lines) + "\n", shared_baseline


def summary_table(rows):
    if not rows:
        return ""
    width = max(len(name) for name, _ in rows)
    lines = [
        f"{row_code(data):<4}  {name:<{width}}  {shorten(row_reason(data))}"
        for name, data in rows
    ]
    return "\n".join(lines) + "\n"


def attention_section(rows):
    """Notes of passing designs; a note shared by several designs prints once."""
    by_note = {}
    for name, data in rows:
        for note in data["notes"]:
            by_note.setdefault(note, []).append(name)
    lines = []
    for note, names in by_note.items():
        if len(names) == 1:
            lines.append(f"{names[0]}: {note}")
        else:
            lines.append(f"{note} ({len(names)} designs):")
            wrapped = textwrap.wrap(", ".join(names), width=76, break_on_hyphens=False)
            lines += [f"    {line}" for line in wrapped]
    return "\n".join(lines) + "\n"


def write_summary():
    """Write the summary: header, one row per design, then details."""
    rows = sorted(design_list.items(), key=sort_key)
    header, shared_baseline = summary_header(design_list)
    listed = [
        (name, data)
        for name, data in rows
        if row_code(data) != PASS or args.verbose >= 2
    ]

    summary = "\n" + header + "\n" + summary_table(listed)
    for code, label in CATEGORIES.items():
        group = [(n, d) for n, d in rows if d["category"] == code]
        if group:
            summary += "\n" + section(f"{label.upper()} ({len(group)})")
            summary += "\n\n".join(gen_report(n, d, shared_baseline) for n, d in group)
            summary += "\n"
    noted = [(n, d) for n, d in rows if row_code(d) == WARN]
    if noted:
        summary += "\n" + section("NEEDS ATTENTION (not failing)")
        summary += attention_section(noted)
    if args.verbose >= 2:
        passing = [(n, d) for n, d in rows if d["status"] == STATUS_GREEN]
        details = [gen_report(n, d) for n, d in passing]
        if passing:
            summary += "\n" + section(f"PASSING ({len(passing)})")
            summary += "\n".join(details) + "\n"

    if not args.quiet:
        if os.path.isfile(SUMMARY_FILENAME):
            print(f"Overwriting report summary {SUMMARY_FILENAME}.")
        print(summary)
    with open(SUMMARY_FILENAME, "w") as file:
        file.write(summary)
    if not args.quiet and args.verbose:
        print("Generated report summary file:", SUMMARY_FILENAME)


design_list = dict()

if __name__ == "__main__":
    for log_dir, dirs, files in sorted(os.walk(LOGS_FOLDER, topdown=False)):
        dir_list = log_dir.split(os.sep)
        # Handles autotuner folders, which do not have `report.log` natively.
        # TODO: Can we log something for autotuner?
        if len(dir_list) != 4 or any(
            word in dir_list[-1] for word in SKIPPED_FLOW_VARIANT_KEYWORDS
        ):
            continue
        platform, design, variant = dir_list[1:]
        report_dir = log_dir.replace(LOGS_FOLDER, REPORTS_FOLDER, 1)
        design_list[f"{platform}/{design}/{variant}"] = collect(
            log_dir, files, report_dir
        )

    if not os.path.isdir(REPORTS_FOLDER):
        os.mkdir(REPORTS_FOLDER)

    if args.summary:
        write_summary()
    else:
        if os.path.isfile(SINGLE_REPORT_FILENAME):
            if not args.quiet:
                print(f"Overwriting report {SINGLE_REPORT_FILENAME}.")
            os.remove(SINGLE_REPORT_FILENAME)
        for name_, data_ in design_list.items():
            write_report(data_["output_file"], gen_report(name_, data_))
