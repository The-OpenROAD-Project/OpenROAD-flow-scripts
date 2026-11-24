#!/usr/bin/env python3
"""The make rules that run a KLayout application: a Ruby DRC or LVS deck
and the klayout_<file> viewers. With KLayout, each rule hands it the
rule's arguments as they are; without it, each stops with an error and
runs nothing.

KLayout is stubbed: `klayout` logs its argv and writes the report file it
is given, so make needs nothing installed. The inputs the rules depend on
are written empty and kept as they are with make's -o.
"""

import os
import subprocess
import tempfile
import unittest

FLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DESIGN_CONFIG = "designs/nangate45/gcd/config.mk"

FAKE_KLAYOUT = """\
#!/usr/bin/env bash
printf "%s|" "$@" >> "$ARGV_LOG"
echo >> "$ARGV_LOG"
for arg in "$@"; do
  case "$arg" in
    report_file=*) echo "<value>1</value>" > "${arg#report_file=}" ;;
  esac
done
"""


class TestKlayoutMake(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        tmp = self.tmp_dir.name
        self.log = os.path.join(tmp, "argv.log")
        self.klayout = os.path.join(tmp, "klayout")
        with open(self.klayout, "w") as f:
            f.write(FAKE_KLAYOUT)
        os.chmod(self.klayout, 0o755)
        self.deck = {}
        for name in ("drc.lydrc", "lvs.lylvs"):
            self.deck[name] = os.path.join(tmp, name)
            open(self.deck[name], "w").close()
        self.args = [
            f"DESIGN_CONFIG={DESIGN_CONFIG}",
            f"WORK_HOME={os.path.join(tmp, 'work')}",
            "FLOW_VARIANT=klayout_make",
        ]
        self.env = dict(os.environ, ARGV_LOG=self.log)
        for name in ("KLAYOUT_CMD", "MAKEFLAGS"):
            self.env.pop(name, None)
        self.dirs = {
            name: self.print_var(name)
            for name in ("RESULTS_DIR", "OBJECTS_DIR", "REPORTS_DIR", "LOG_DIR")
        }
        for path in self.dirs.values():
            os.makedirs(path, exist_ok=True)
        self.gds = self.input("RESULTS_DIR", "6_final.gds")
        self.lyt = self.input("OBJECTS_DIR", "klayout.lyt")
        self.cdl = self.input("OBJECTS_DIR", "6_final_concat.cdl")

    def tearDown(self):
        self.tmp_dir.cleanup()

    def input(self, directory, name):
        path = os.path.join(self.dirs[directory], name)
        open(path, "w").close()
        return path

    def print_var(self, name):
        result = subprocess.run(
            ["make", "--no-print-directory", *self.args, f"print-{name}"],
            cwd=FLOW_DIR,
            env=self.env,
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.split(f"{name}: ")[1].strip()

    def make(self, target, klayout_cmd, *args):
        if os.path.exists(self.log):
            os.remove(self.log)
        result = subprocess.run(
            [
                "make",
                "--no-print-directory",
                *self.args,
                f"KLAYOUT_CMD={klayout_cmd}",
                *(f"-o{path}" for path in (self.gds, self.lyt, self.cdl)),
                *args,
                target,
            ],
            cwd=FLOW_DIR,
            env=self.env,
            stdin=subprocess.DEVNULL,
            capture_output=True,
            text=True,
        )
        calls = []
        if os.path.exists(self.log):
            with open(self.log) as f:
                calls = [line.split("|")[:-1] for line in f.read().splitlines()]
        return result, calls

    def routes(self):
        """Each route: the make target, its variables and the arguments
        KLayout gets."""
        drc_report = os.path.join(self.dirs["REPORTS_DIR"], "6_drc.lyrdb")
        lvs_report = os.path.join(self.dirs["RESULTS_DIR"], "6_lvs.lvsdb")
        return {
            "viewer": (
                "klayout_6_final.gds",
                [],
                ["-nn", self.lyt, self.gds],
            ),
            "ruby drc": (
                drc_report,
                [f"KLAYOUT_DRC_FILE={self.deck['drc.lydrc']}"],
                [
                    "-zz",
                    "-rd",
                    f"in_gds={self.gds}",
                    "-rd",
                    f"report_file={drc_report}",
                    "-r",
                    self.deck["drc.lydrc"],
                ],
            ),
            "ruby lvs": (
                lvs_report,
                [f"KLAYOUT_LVS_FILE={self.deck['lvs.lylvs']}"],
                [
                    "-b",
                    "-rd",
                    f"in_gds={self.gds}",
                    "-rd",
                    f"cdl_file={self.cdl}",
                    "-rd",
                    "top_cell=gcd",
                    "-rd",
                    f"report_file={lvs_report}",
                    "-r",
                    self.deck["lvs.lylvs"],
                ],
            ),
        }

    def test_klayout_gets_the_arguments(self):
        for route, (target, args, expected) in self.routes().items():
            with self.subTest(route):
                result, calls = self.make(target, self.klayout, *args)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertEqual(calls, [expected])

    def test_missing_klayout_stops_the_rule(self):
        for route, (target, args, _) in self.routes().items():
            with self.subTest(route):
                result, calls = self.make(target, "", *args)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("KLayout not found", result.stdout + result.stderr)
                self.assertEqual(calls, [])


if __name__ == "__main__":
    unittest.main()
