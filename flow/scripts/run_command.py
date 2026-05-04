#!/usr/bin/env python3
"""Run a command with timing and optional log file output.

Replaces the GNU `time` + `tee` shell pipeline with a pure-Python
implementation that works on both Linux and macOS without external
dependencies.

Usage:
    run_command.py [--log FILE] [--append] [--tee] -- command [args...]

Output is streamed line-by-line and flushed after every line so that
`tail -f <logfile>` works in real time.  The log path is visible in
`ps` output for discoverability (replaces `ps -Af | grep tee`).

On completion an "Elapsed time: ..." line is appended to stderr (and
the log file) in the same format that the rest of the ORFS
infrastructure expects.
"""

import argparse
import os
import resource
import subprocess
import sys
import time


def _maxrss_kb(ru_maxrss: int) -> int:
    """Normalize ru_maxrss to kilobytes (Linux reports KB, macOS reports bytes)."""
    if sys.platform == "darwin":
        return ru_maxrss // 1024
    return ru_maxrss


def _format_elapsed(seconds: float) -> str:
    """Format seconds as [H:]MM:SS.ff matching GNU time %E output."""
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = seconds % 60
    if h:
        return f"{h}:{m:02d}:{s:05.2f}"
    return f"{m}:{s:05.2f}"


def _build_timing_line(
    wall: float,
    user: float,
    sys_: float,
    peak_kb: int,
) -> str:
    cpu_pct = int(100 * (user + sys_) / wall) if wall > 0 else 0
    return (
        f"Elapsed time: {_format_elapsed(wall)}[h:]min:sec. "
        f"CPU time: user {user:.2f} sys {sys_:.2f} ({cpu_pct}%). "
        f"Peak memory: {peak_kb}KB."
    )


def run(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Run a command with timing, optional tee-to-log."
    )
    parser.add_argument("--log", help="Log file path")
    parser.add_argument(
        "--append", action="store_true", help="Append to log file instead of overwrite"
    )
    parser.add_argument(
        "--tee",
        action="store_true",
        help="Also write output to stdout (like tee)",
    )
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args(argv)

    cmd = args.command
    if cmd and cmd[0] == "--":
        cmd = cmd[1:]
    if not cmd:
        parser.error("No command specified")

    # Snapshot children resource usage before the subprocess.
    before = resource.getrusage(resource.RUSAGE_CHILDREN)

    log_file = None
    if args.log:
        log_file = open(args.log, "a" if args.append else "w")

    wall_start = time.monotonic()
    env = os.environ.copy()
    for var in ("RUNFILES_DIR", "RUNFILES_MANIFEST_FILE", "RUNFILES_MANIFEST_ONLY"):
        env.pop(var, None)
    proc = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env
    )

    try:
        for line in iter(proc.stdout.readline, b""):
            if args.tee:
                sys.stdout.buffer.write(line)
                sys.stdout.buffer.flush()
            if log_file:
                log_file.write(line.decode(errors="replace"))
                log_file.flush()
        proc.wait()
    except BaseException:
        proc.kill()
        proc.wait()
        raise
    finally:
        wall = time.monotonic() - wall_start

        after = resource.getrusage(resource.RUSAGE_CHILDREN)
        user = after.ru_utime - before.ru_utime
        sys_ = after.ru_stime - before.ru_stime
        peak_kb = _maxrss_kb(after.ru_maxrss)

        timing_line = _build_timing_line(wall, user, sys_, peak_kb)

        sys.stderr.write(timing_line + "\n")
        sys.stderr.flush()
        if log_file:
            log_file.write(timing_line + "\n")
            log_file.flush()
            log_file.close()

    return proc.returncode


if __name__ == "__main__":
    sys.exit(run())
