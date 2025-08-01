#!/usr/bin/env python3

# This scripts attempts to generate elasped time in seconds for all the steps
# in the flow and prints it in a table
# ---------------------------------------------------------------------------

import argparse
import hashlib
import pathlib
import os
import sys

# Parse and validate arguments
# ==============================================================================


def get_hash(f):
    # content hash for the result file alongside .log file is useful to
    # debug divergent results under what should be identical
    # builds(such as local and CI builds)
    for ext in [".odb", ".rtlil", ".v"]:
        result_file = pathlib.Path(
            str(f).replace("logs/", "results/").replace(".log", ext)
        )
        if result_file.exists():
            hasher = hashlib.sha1()
            with open(result_file, "rb") as odb_f:
                while True:
                    chunk = odb_f.read(16 * 1024 * 1024)
                    if not chunk:
                        break
                    hasher.update(chunk)
            return hasher.hexdigest()
    return "N/A"


def print_log_dir_times(logdir, args):
    first = True
    totalElapsed = 0
    total_max_memory = 0
    if not args.match:
        print(logdir)

    # Loop on all log files in the directory
    for f in sorted(pathlib.Path(logdir).glob("**/*.log")):
        if "eqy_output" in str(f):
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
                    # Extract the portion that has the time
                    timePor = line.strip().replace("Elapsed time: ", "")
                    # Remove the units from the time portion
                    timePor = timePor.split("[h:]", 1)[0]
                    # Remove any fraction of a second
                    timePor = timePor.split(".", 1)[0]
                    # Calculate elapsed time that has this format 'h:m:s'
                    timeList = timePor.split(":")
                    if len(timeList) == 2:
                        # Only minutes and seconds are present
                        elapsedTime = int(timeList[0]) * 60 + int(timeList[1])
                    elif len(timeList) == 3:
                        # Hours, minutes, and seconds are present
                        elapsedTime = (
                            int(timeList[0]) * 3600
                            + int(timeList[1]) * 60
                            + int(timeList[2])
                        )
                    else:
                        print(
                            "Elapsed time not understood in", str(line), file=sys.stderr
                        )
                    # Find Peak Memory
                    peak_memory = int(
                        int(line.split("Peak memory: ")[1].split("KB")[0]) / 1024
                    )
                    break

            odb_hash = get_hash(f)

            if not found:
                print("No elapsed time found in", str(f), file=sys.stderr)
                continue

        # Print the name of the step and the corresponding elapsed time
        format_str = "%-25s %10s %14s %20s"
        if elapsedTime is not None and peak_memory is not None:
            if first and not args.noHeader:
                print(
                    format_str
                    % ("Log", "Elapsed/s", "Peak Memory/MB", "sha1sum .odb [0:20)")
                )
                first = False
            print(
                format_str
                % (
                    stem,
                    elapsedTime,
                    peak_memory,
                    odb_hash[0:20],
                )
            )
        if elapsedTime is not None:
            totalElapsed += elapsedTime
        if peak_memory is not None:
            total_max_memory = max(total_max_memory, int(peak_memory))

    if totalElapsed != 0 and not args.match:
        print(format_str % ("Total", totalElapsed, total_max_memory, ""))


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
