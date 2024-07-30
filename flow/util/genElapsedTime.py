#!/usr/bin/env python3

# This scripts attempts to generate elasped time in seconds for all the steps
# in the flow and prints it in a table
# ---------------------------------------------------------------------------

import pathlib
import os
import argparse  # argument parsing
import sys

# Parse and validate arguments
# ==============================================================================


def print_log_dir_times(logdir, args):
    first = True
    totalElapsed = 0
    total_max_memory = 0
    print(logdir)

    # Loop on all log files in the directory
    for f in sorted(pathlib.Path(logdir).glob("**/*.log")):
        if "eqy_output" in str(f):
            continue
        # Extract Elapsed Time line from log file
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

            if not found:
                print("No elapsed time found in", str(f), file=sys.stderr)
                continue

        # Print the name of the step and the corresponding elapsed time
        format_str = "%-25s %20s %14s"
        if elapsedTime is not None and peak_memory is not None:
            if first and not args.noHeader:
                print(format_str % ("Log", "Elapsed seconds", "Peak Memory/MB"))
                first = False
            print(
                format_str
                % (
                    os.path.splitext(os.path.basename(str(f)))[0],
                    elapsedTime,
                    peak_memory,
                )
            )
        totalElapsed += elapsedTime
        total_max_memory = max(total_max_memory, int(peak_memory))

    if totalElapsed != 0:
        print(format_str % ("Total", totalElapsed, total_max_memory))


def scan_logs(args):
    parser = argparse.ArgumentParser(
        description="Print elapsed time for every step in the flow"
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
