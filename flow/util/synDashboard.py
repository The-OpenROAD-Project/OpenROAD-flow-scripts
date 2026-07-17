#!/usr/bin/env python3

"""TL;DR dashboard over locally built OpenROAD-SYN QoR test results.

The local counterpart of https://dashboard.precisioninno.com/: scans
bazel-testlogs for the forced-engine QoR tests emitted by
flow/designs/design.bzl (<name>_{syn,yosys}[_synth]_test) and prints a
GitHub-flavored markdown status table, so the output can be pasted
into a PR or issue as-is. Reads only what previous `bazelisk test`
runs left behind — it never builds anything, so it is instant.

Run it via:
    bazelisk run //flow/designs:syn-dashboard
"""

import os
import re
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

# <design>_{syn,yosys}[_synth]_test, as emitted by design.bzl's
# forced-engine variants. "_synth" marks the fast synthesis-only tier.
TARGET_RE = re.compile(r"^(?P<base>.+)_(?P<engine>syn|yosys)(?P<fast>_synth)?_test$")

FAIL_RULE_RE = re.compile(r"^\[ERROR\] (\S+) fail test: (.*)$")
MISSING_RULE_RE = re.compile(r"^\[ERROR\] Value not found for (\S+)\.$")

# (engine, fast) -> table column, in display order.
COLUMNS = [
    ("syn", True, "SYN synth"),
    ("syn", False, "SYN flow"),
    ("yosys", True, "yosys synth"),
    ("yosys", False, "yosys flow"),
]


def workspace_root():
    """The bazel workspace root: BUILD_WORKSPACE_DIRECTORY under
    `bazel run`, else the nearest ancestor holding MODULE.bazel."""
    env = os.environ.get("BUILD_WORKSPACE_DIRECTORY")
    if env:
        return Path(env)
    for path in [Path.cwd()] + list(Path.cwd().parents):
        if (path / "MODULE.bazel").is_file():
            return path
    sys.exit("error: not inside a bazel workspace (no MODULE.bazel found)")


def test_status(test_dir):
    """(passed, mtime) for one bazel-testlogs test dir, or None if the
    test never produced a result. The test.xml duration is just the
    metadata-check action, not the flow build, so it is not reported."""
    xml_file = test_dir / "test.xml"
    if not xml_file.is_file():
        return None
    try:
        root = ET.parse(xml_file).getroot()
    except ET.ParseError:
        return None
    failures = 0
    for suite in root.iter("testsuite"):
        failures += int(suite.get("failures", 0)) + int(suite.get("errors", 0))
    return failures == 0, xml_file.stat().st_mtime


def failing_rules(test_dir):
    """Failed rule fields harvested from checkMetadata.py output in
    test.log."""
    log_file = test_dir / "test.log"
    if not log_file.is_file():
        return []
    fields = []
    for line in log_file.read_text(errors="replace").splitlines():
        match = FAIL_RULE_RE.match(line)
        if match:
            fields.append(match.group(1))
            continue
        match = MISSING_RULE_RE.match(line)
        if match:
            fields.append(match.group(1) + " (missing)")
    return fields


def age(mtime):
    seconds = max(0, time.time() - mtime)
    if seconds >= 86400:
        return f"{seconds / 86400:.0f}d ago"
    if seconds >= 3600:
        return f"{seconds / 3600:.0f}h ago"
    if seconds >= 60:
        return f"{seconds / 60:.0f}m ago"
    return "just now"


def collect(root):
    """{(platform, design_pkg): {(engine, fast): result}} from
    bazel-testlogs, where result adds the failed-rule fields."""
    designs = {}
    testlogs = root / "bazel-testlogs" / "flow" / "designs"
    if not testlogs.is_dir():
        return designs
    for xml_file in testlogs.glob("*/*/*/test.xml"):
        target_dir = xml_file.parent
        match = TARGET_RE.match(target_dir.name)
        if not match:
            continue
        status = test_status(target_dir)
        if status is None:
            continue
        passed, mtime = status
        key = (target_dir.parent.parent.name, target_dir.parent.name)
        designs.setdefault(key, {})[
            (match.group("engine"), bool(match.group("fast")))
        ] = {
            "passed": passed,
            "mtime": mtime,
            "failing": [] if passed else failing_rules(target_dir),
        }
    return designs


def format_rules(fields, limit=3):
    if len(fields) > limit:
        fields = fields[:limit] + [f"+{len(fields) - limit} more"]
    return ", ".join(fields)


def main():
    designs = collect(workspace_root())
    print("# OpenROAD-SYN local status")
    print()
    if not designs:
        print("No forced-engine test results under bazel-testlogs yet. Build some:")
        print()
        print("    bazelisk test --keep_going //flow/designs/asap7:syn_synth_test")
        print("    bazelisk test --keep_going //flow/designs/asap7:syn_test")
        return
    header = (
        ["design"] + [title for _, _, title in COLUMNS] + ["failing rules", "last run"]
    )
    print("| " + " | ".join(header) + " |")
    print("|" + "|".join(["---"] * len(header)) + "|")
    for (platform, pkg), results in sorted(designs.items()):
        cells = []
        for engine, fast, _ in COLUMNS:
            result = results.get((engine, fast))
            if result is None:
                cells.append("—")
            else:
                cells.append("✅" if result["passed"] else "❌")
        # The most meaningful failure detail: the full SYN flow if it
        # failed, else the fast SYN tier, else any failing variant.
        failing = []
        for key in [("syn", False), ("syn", True), ("yosys", False), ("yosys", True)]:
            result = results.get(key)
            if result and not result["passed"] and result["failing"]:
                failing = result["failing"]
                break
        newest = max(result["mtime"] for result in results.values())
        row = [f"{platform}/{pkg}"] + cells + [format_rules(failing), age(newest)]
        print("| " + " | ".join(row) + " |")
    print()
    print("Each cell reflects its own last `bazelisk test` run; `last run` is the")
    print("newest across the row. `—` = no local result: never run, or its build")
    print("failed outright (e.g. synthesis died) — bazel records no test result")
    print("for build failures, so run the suites with `--keep_going` and check")
    print("their output for `FAILED TO BUILD`.")


if __name__ == "__main__":
    main()
