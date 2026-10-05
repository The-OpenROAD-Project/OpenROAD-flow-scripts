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
            SKIP_STAGE_ART="0",
        )
        self.env.pop("RUN_CMD", None)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def run_stage(self, returncode=0):
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
        self.assertEqual(result.returncode, returncode, result.stdout + result.stderr)
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

    def test_stage_ends_with_its_summary(self):
        log = self.run_stage()
        self.assertIn("== ORFS 2_1_floorplan OK", log)

    def test_skip_stage_art(self):
        self.env["SKIP_STAGE_ART"] = "1"
        log = self.run_stage()
        self.assertNotIn("== ORFS", log)

    def test_unset_skip_stage_art_is_an_error(self):
        """No silent default: the flow always sets it (variables.yaml)."""
        del self.env["SKIP_STAGE_ART"]
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
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("SKIP_STAGE_ART", result.stderr)

    def test_failed_stage_is_explained_and_keeps_its_status(self):
        stub = os.path.join(self.tmp_dir.name, "failing_openroad.sh")
        with open(stub, "w") as f:
            f.write("#!/bin/sh\necho '[ERROR IFP-0065] No rows created.'\nexit 3\n")
        os.chmod(stub, 0o755)
        self.env["OPENROAD_CMD"] = stub
        log = self.run_stage(returncode=3)
        self.assertIn("== ORFS 2_1_floorplan FAIL IFP-0065", log)
        self.assertIn("issue: make floorplan_issue", log)

    def test_run_cmd_runs_the_stage(self):
        # A RUN_CMD that records that it ran, then runs run_command.py.
        marker = os.path.join(self.tmp_dir.name, "run_cmd_ran")
        wrapper = os.path.join(self.tmp_dir.name, "run_cmd.py")
        with open(wrapper, "w") as f:
            f.write(textwrap.dedent(f"""\
                import os, sys
                with open({marker!r}, "a") as m:
                    m.write(" ".join(sys.argv[1:]) + "\\n")
                    m.write(os.environ["ORFS_STAGE_SCRIPT"] + "\\n")
                run_command = os.path.join({SCRIPTS_DIR!r}, "run_command.py")
                os.execv(sys.executable, [sys.executable, run_command] + sys.argv[1:])
                """))
        self.env["RUN_CMD"] = f"{sys.executable} {wrapper}"

        log = self.run_stage()

        self.assertTrue(os.path.exists(marker), "RUN_CMD did not run the stage")
        with open(marker) as f:
            ran = f.read()
        # run_stage.tcl wraps the stage script to snapshot its result.
        self.assertIn("run_stage.tcl", ran)
        self.assertIn("floorplan.tcl", ran)
        self.assertIn("Elapsed time:", log)
        self.assert_summary(log)


if __name__ == "__main__":
    unittest.main()
