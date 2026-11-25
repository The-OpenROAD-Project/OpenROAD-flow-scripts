#!/usr/bin/env python3
"""Write a machine-readable summary of a flow run's results.

Reads every design run under <flow dir>/reports/<platform>/<design>/<variant>
and writes one JSON file:

    {
      "collector_version": 1,
      "designs": [
        {
          "platform": "asap7", "design": "gcd", "variant": "base",
          "metrics": {...} or null,
          "logs": {"last_stage": "route", "first_error": "...", "crashed": false}
        }
      ],
      "skipped": [
        {"platform": ..., "design": ..., "variant": ..., "error": "..."}
      ]
    }

``metrics`` holds the contents of the run's metadata.json exactly as written,
or null when the run wrote none. ``logs`` describes the stage logs under
<flow dir>/logs/<platform>/<design>/<variant>: the stage of the last one, the
first error line found reading them from the last stage back, and whether the
last one shows that a tool died on a signal. Each is null (``crashed`` false)
when there are no stage logs or nothing matched. A run whose metadata.json
cannot be read is listed under ``skipped`` instead.

``collector_version`` changes only when a field is removed or its meaning
changes; new fields are added without changing it.

Exits 0 once the file is written, including when no design was found. Any
other failure exits non-zero and leaves no output file behind.
"""

import argparse
import json
import os
import re
import sys

COLLECTOR_VERSION = 1
METADATA_FILENAME = "metadata.json"

# Stage log names start with the step number: 1_2_yosys.log, 5_1_grt.log.
STAGE_LOG = re.compile(r"^(\d+)_(?:(\d+)_)?.*\.log$")
# The OpenROAD form carries the tool's message ID; Yosys prints "ERROR: ".
ERROR_LINE = re.compile(
    r"\[(?:ERROR|CRITICAL|FATAL) [A-Z][A-Z0-9]*-\d+\].*|^ERROR: .*|^Error: .*"
)
# What a tool that died on a signal leaves in its log, as opposed to an error it
# reported itself.
CRASH_LINE = re.compile(r"Signal \d+ received|Segmentation fault|core dumped")


def stage_name(log_name):
    """The flow stage a stage log belongs to, e.g. 5_1_grt.log -> "grt"."""
    match = STAGE_LOG.match(log_name)
    if not match:
        return None
    step, sub = match.group(1), match.group(2)
    if step == "5":
        return "grt" if sub == "1" else "route"
    return {
        "1": "synth",
        "2": "floorplan",
        "3": "place",
        "4": "cts",
        "6": "finish",
    }.get(step)


def stage_logs(log_dir):
    """The run's stage logs, last step first."""
    try:
        names = os.listdir(log_dir)
    except OSError:
        return []

    def key(name):
        match = STAGE_LOG.match(name)
        return (int(match.group(1)), int(match.group(2) or 0), name)

    return sorted((n for n in names if STAGE_LOG.match(n)), key=key, reverse=True)


def scan_log(path):
    """The first error line of a log and whether it shows a crash."""
    error_line = None
    crashed = False
    try:
        with open(path, errors="replace") as f:
            for line in f:
                if error_line is None:
                    match = ERROR_LINE.search(line)
                    if match:
                        error_line = match.group(0).strip()
                if not crashed and CRASH_LINE.search(line):
                    crashed = True
                if error_line is not None and crashed:
                    break
    except OSError:
        pass
    return error_line, crashed


def read_logs(log_dir):
    """The ``logs`` entry of a run."""
    logs = stage_logs(log_dir)
    facts = {"last_stage": None, "first_error": None, "crashed": False}
    if not logs:
        return facts
    facts["last_stage"] = stage_name(logs[0])
    for i, name in enumerate(logs):
        error_line, crashed = scan_log(os.path.join(log_dir, name))
        if i == 0:
            facts["crashed"] = crashed
        if error_line:
            facts["first_error"] = error_line
            break
    return facts


def subdirs(path):
    """The names of the directories directly under ``path``, sorted."""
    try:
        names = os.listdir(path)
    except OSError:
        return []
    return sorted(n for n in names if os.path.isdir(os.path.join(path, n)))


def run_dirs(reports):
    """(platform, design, variant) of every run directory under ``reports``."""
    for platform in subdirs(reports):
        for design in subdirs(os.path.join(reports, platform)):
            for variant in subdirs(os.path.join(reports, platform, design)):
                yield platform, design, variant


def collect(flow_dir):
    """The summary of every run under ``flow_dir``, as a dict."""
    designs = []
    skipped = []
    reports = os.path.join(flow_dir, "reports")
    for platform, design, variant in run_dirs(reports):
        report_dir = os.path.join(reports, platform, design, variant)
        names = {"platform": platform, "design": design, "variant": variant}

        metrics = None
        data_file = os.path.join(report_dir, METADATA_FILENAME)
        if os.path.exists(data_file):
            try:
                with open(data_file) as f:
                    metrics = json.load(f)
            except (OSError, ValueError) as e:
                print(f"[WARN] Skipping {platform} {design} {variant}: {e}")
                skipped.append({**names, "error": str(e)})
                continue
            if not isinstance(metrics, dict):
                error = f"{data_file} does not hold a JSON object"
                print(f"[WARN] Skipping {platform} {design} {variant}: {error}")
                skipped.append({**names, "error": error})
                continue

        log_dir = os.path.join(flow_dir, "logs", platform, design, variant)
        designs.append({**names, "metrics": metrics, "logs": read_logs(log_dir)})

    return {
        "collector_version": COLLECTOR_VERSION,
        "designs": designs,
        "skipped": skipped,
    }


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Write a machine-readable summary of a flow run's results."
    )
    parser.add_argument(
        "--flowDir",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."),
        help="the flow directory holding reports/ and logs/ (default: this "
        "script's flow directory)",
    )
    parser.add_argument("--output", required=True, help="the JSON file to write")
    args = parser.parse_args(argv)

    summary = collect(args.flowDir)
    tmp = args.output + ".tmp"
    with open(tmp, "w") as f:
        json.dump(summary, f, indent=2)
        f.write("\n")
    os.replace(tmp, args.output)
    print(
        f"[INFO] Wrote {len(summary['designs'])} designs "
        f"({len(summary['skipped'])} skipped) to {args.output}."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
