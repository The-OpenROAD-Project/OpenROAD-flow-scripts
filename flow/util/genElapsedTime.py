#!/usr/bin/env python3

# This scripts attempts to generate elasped time in seconds for all the steps
# in the flow and prints it in a table
# ---------------------------------------------------------------------------

import argparse
import hashlib
import pathlib
import os
import re
import sys

# Parse and validate arguments
# ==============================================================================


# Primary data artifacts first, then derived/exported artifacts and
# the SDC constraint file: yosys emits .v / .rtlil; OpenROAD stages
# emit .odb (and often .def / .sdc); routing emits .spef; finish
# emits .gds.
RESULT_EXTS = [".v", ".rtlil", ".odb", ".def", ".spef", ".gds", ".sdc"]


# The timing line run_command.py emits, matched wherever it appears in
# the line rather than from its start.  A RUN_CMD wrapper is free to
# prefix every log line -- a per-line elapsed stamp, "[  123.45] " --
# and such a prefix must not change what this reports.  Hours are
# optional, as _format_elapsed only emits them past an hour, and the
# fraction of a second is matched so it can be discarded.
ELAPSED_RE = re.compile(r"Elapsed time: (?:(\d+):)?(\d+):(\d+)(?:\.\d+)?\[h:\]min:sec")


def get_hashes(f):
    """Return [(ext, sha1), ...] for every result file alongside log
    `f` whose extension is in RESULT_EXTS.  A yosys stage typically
    produces both `.v` and `.sdc`; a floorplan/route stage produces
    `.odb` (and often `.sdc`); the canonicalize stage produces
    `.rtlil`.  Hashing each separately makes "the netlist changed"
    distinguishable from "the SDC changed" in the elapsed-time table
    used to triage divergent local vs CI builds.

    Falls back to a single ("", "N/A") entry when no result file
    exists so the caller always emits at least one row per stage.
    """
    results = []
    for ext in RESULT_EXTS:
        result_file = pathlib.Path(
            str(f).replace("logs/", "results/").replace(".log", ext)
        )
        if result_file.exists():
            hasher = hashlib.sha1()
            with open(result_file, "rb") as rf:
                while True:
                    chunk = rf.read(16 * 1024 * 1024)
                    if not chunk:
                        break
                    hasher.update(chunk)
            results.append((ext, hasher.hexdigest()))
    if not results:
        results.append(("", "N/A"))
    return results


def print_log_dir_times(logdir, args):
    first = True
    totalElapsed = 0
    total_max_memory = 0
    if not args.match:
        print(logdir)

    # Loop on all log files in the directory
    for f in sorted(pathlib.Path(logdir).glob("**/*.log")):
        if any(x in str(f) for x in ["eqy_output", "rsz_lec_check"]):
            continue
        # Extract Elapsed Time line from log file
        stem = os.path.splitext(os.path.basename(str(f)))[0]
        if args.match and args.match != stem:
            continue
        with open(str(f)) as logfile:
            found = False
            for line in logfile:
                elapsedTime = None
                peak_memory = None

                # Example line:
                # Elapsed time: 0:04.26[h:]min:sec. CPU time: user 4.08 sys 0.17 (99%). Peak memory: 671508KB.
                if "Elapsed time" in line:
                    found = True
                    # Match the 'h:m:s' time against the known format,
                    # so anything the line is prefixed with is ignored.
                    timeMatch = ELAPSED_RE.search(line)
                    if timeMatch:
                        hours, minutes, seconds = timeMatch.groups()
                        # Any fraction of a second is dropped.
                        elapsedTime = int(minutes) * 60 + int(seconds)
                        if hours is not None:
                            elapsedTime += int(hours) * 3600
                    else:
                        print(
                            "Elapsed time not understood in", str(line), file=sys.stderr
                        )
                    # Find Peak Memory
                    peak_memory = int(
                        int(line.split("Peak memory: ")[1].split("KB")[0]) / 1024
                    )
                    break

            hashes = get_hashes(f)

            if not found:
                print("No elapsed time found in", str(f), file=sys.stderr)
                continue

        # Print the name of the step and the corresponding elapsed time.
        # One row per (stage, result-file-ext); only the first row of a
        # stage shows elapsed/peak.
        format_str = "%-25s %-6s %10s %14s %20s"
        if elapsedTime is not None and peak_memory is not None:
            if first and not args.noHeader:
                print(
                    format_str
                    % (
                        "Log",
                        "Ext",
                        "Elapsed/s",
                        "Peak Memory/MB",
                        "sha1sum result [0:20)",
                    )
                )
                first = False
            stage_first = True
            for ext, h in hashes:
                print(
                    format_str
                    % (
                        stem,
                        ext,
                        elapsedTime if stage_first else "",
                        peak_memory if stage_first else "",
                        h[0:20],
                    )
                )
                stage_first = False
        if elapsedTime is not None:
            totalElapsed += elapsedTime
        if peak_memory is not None:
            total_max_memory = max(total_max_memory, int(peak_memory))

    if totalElapsed != 0 and not args.match:
        print(format_str % ("Total", "", totalElapsed, total_max_memory, ""))


def scan_logs(args):
    parser = argparse.ArgumentParser(
        description="Print elapsed time for every step in the flow"
    )
    parser.add_argument(
        "--match",
        help="Match this string in the log file names",
    )
    parser.add_argument(
        "--logDir", "-d", required=True, nargs="+", help="Log files directories"
    )
    parser.add_argument("--noHeader", action="store_true", help="Skip the header")
    args = parser.parse_args(args)

    if not args.logDir:
        print("[ERROR] Please add a logDir" "-d/--logDir.", file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    for log_dir in args.logDir:
        print_log_dir_times(log_dir, args)


if __name__ == "__main__":
    scan_logs(sys.argv[1:])
