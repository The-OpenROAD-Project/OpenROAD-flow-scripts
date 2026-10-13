#!/usr/bin/env python3
"""flow.sh runs every stage, and runs it through RUN_CMD like the rest of
the flow. With RUN_CMD unset, a stage runs exactly as before; with it set,
the stage goes through it and the per-stage summary still comes out.

The tools are stubbed: OPENROAD_EXE is `true` and OPENROAD_CMD is `echo`,
so the stage is quick and needs nothing installed.
"""

import os
import subprocess
import sys
import tempfile
import textwrap
import unittest

FLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
SCRIPTS_DIR = os.path.join(FLOW_DIR, "scripts")
UTILS_DIR = os.path.join(FLOW_DIR, "util")


class TestFlowSh(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        tmp = self.tmp_dir.name
        self.log_dir = os.path.join(tmp, "logs")
        self.env = dict(
            os.environ,
            RESULTS_DIR=os.path.join(tmp, "results"),
            LOG_DIR=self.log_dir,
            REPORTS_DIR=os.path.join(tmp, "reports"),
            OBJECTS_DIR=os.path.join(tmp, "objects"),
            SCRIPTS_DIR=SCRIPTS_DIR,
            UTILS_DIR=UTILS_DIR,
            PYTHON_EXE=sys.executable,
            OPENROAD_EXE="true",
            OPENROAD_ARGS="",
            OPENROAD_CMD="echo",
        )
        self.env.pop("RUN_CMD", None)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def run_stage(self):
        result = subprocess.run(
            [
                "bash",
                os.path.join(SCRIPTS_DIR, "flow.sh"),
                "2_1_floorplan",
                "floorplan",
            ],
            env=self.env,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        with open(os.path.join(self.log_dir, "2_1_floorplan.log")) as f:
            return f.read()

    def assert_summary(self, log):
        # genElapsedTime.py's row for the stage: name, elapsed, peak memory.
        rows = [line for line in log.splitlines() if line.startswith("2_1_floorplan")]
        self.assertEqual(len(rows), 1, log)
        self.assertGreaterEqual(len(rows[0].split()), 3, rows[0])

    def test_run_cmd_unset_runs_the_stage_as_before(self):
        log = self.run_stage()
        self.assertIn("Elapsed time:", log)
        self.assert_summary(log)

    def test_run_cmd_runs_the_stage(self):
        # A RUN_CMD that records that it ran, then runs run_command.py.
        marker = os.path.join(self.tmp_dir.name, "run_cmd_ran")
        wrapper = os.path.join(self.tmp_dir.name, "run_cmd.py")
        with open(wrapper, "w") as f:
            f.write(textwrap.dedent(f"""\
                import os, sys
                with open({marker!r}, "a") as m:
                    m.write(" ".join(sys.argv[1:]) + "\\n")
                run_command = os.path.join({SCRIPTS_DIR!r}, "run_command.py")
                os.execv(sys.executable, [sys.executable, run_command] + sys.argv[1:])
                """))
        self.env["RUN_CMD"] = f"{sys.executable} {wrapper}"

        log = self.run_stage()

        self.assertTrue(os.path.exists(marker), "RUN_CMD did not run the stage")
        with open(marker) as f:
            self.assertIn("floorplan.tcl", f.read())
        self.assertIn("Elapsed time:", log)
        self.assert_summary(log)


if __name__ == "__main__":
    unittest.main()
