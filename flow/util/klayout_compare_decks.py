#!/usr/bin/env python3
"""Compare a Ruby KLayout DRC deck with its Python translation.

Runs the Ruby deck in the KLayout application and the Python deck with the
klayout Python module on the same GDS file, then compares the violations
per category: the count and the marker geometry. Exits 0 when they agree,
1 when they differ.

For converting a deck to Python before the Ruby decks stop working; see
docs/user/KLayoutPythonDecks.md. A clean layout proves little: also run it
on a copy of the layout with shapes added that break the rules.
"""

import argparse
import collections
import os
import shutil
import subprocess
import sys

import klayout.rdb as rdb

UTIL_DIR = os.path.dirname(os.path.abspath(__file__))


def violations(path):
    report = rdb.ReportDatabase()
    report.load(path)
    names = {}

    def walk(categories, prefix):
        for category in categories:
            name = prefix + category.name()
            names[category.rdb_id()] = name
            walk(category.each_sub_category(), name + ".")

    walk(report.each_category(), "")
    markers = collections.defaultdict(collections.Counter)
    for item in report.each_item():
        name = names[item.category_id()]
        for value in item.each_value():
            markers[name][value.to_s()] += 1
    return markers


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--ruby-deck", required=True)
    parser.add_argument("--python-deck", required=True)
    parser.add_argument("--in-gds", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument(
        "--klayout",
        default=os.environ.get("KLAYOUT_CMD") or shutil.which("klayout"),
        help="the KLayout application, default KLAYOUT_CMD or klayout on PATH",
    )
    args = parser.parse_args()
    if not args.klayout:
        sys.exit("ERROR: the KLayout application is needed to run the Ruby deck")

    os.makedirs(args.out_dir, exist_ok=True)
    ruby_report = os.path.join(args.out_dir, "ruby.lyrdb")
    python_report = os.path.join(args.out_dir, "python.lyrdb")
    subprocess.run(
        [
            args.klayout,
            "-b",
            "-rd",
            "in_gds=" + args.in_gds,
            "-rd",
            "report_file=" + ruby_report,
            "-r",
            args.ruby_deck,
        ],
        check=True,
    )
    subprocess.run(
        [
            sys.executable,
            os.path.join(UTIL_DIR, "klayout_drc.py"),
            "--deck=" + args.python_deck,
            "--in-gds=" + args.in_gds,
            "--report-file=" + python_report,
        ],
        check=True,
    )

    ruby = violations(ruby_report)
    python = violations(python_report)
    same = True
    for name in sorted(set(ruby) | set(python)):
        ruby_count = sum(ruby[name].values())
        python_count = sum(python[name].values())
        differs = ruby[name] != python[name]
        same = same and not differs
        print(
            "%-40s ruby %6d python %6d%s"
            % (name, ruby_count, python_count, "  <-- differs" if differs else "")
        )
    print("same" if same else "DIFFERENT")
    sys.exit(0 if same else 1)


if __name__ == "__main__":
    main()
