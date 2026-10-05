#!/usr/bin/env python3
"""util/stage_art.py draws the end-of-stage summary from what the stage
left behind: its log, metrics and the scripts/stage_art.tcl snapshot.

Fixtures under stage_art/ are trimmed copies of real runs; the tests
check that each picture shows what it is for, not its exact characters.
"""

import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import unittest

TEST_DIR = os.path.dirname(os.path.abspath(__file__))
FIXTURES = os.path.join(TEST_DIR, "stage_art")
UTILS_DIR = os.path.join(TEST_DIR, "..", "util")
sys.path.insert(0, UTILS_DIR)

import stage_art

# Environment the renderer reads; fixed so output does not depend on the
# caller's shell.
ENV = {"DESIGN_NICKNAME": "test", "PLATFORM": "asap7", "FLOW_VARIANT": "base"}
CLEARED = [
    "DESIGN_CONFIG",
    "SCRIPTS_DIR",
    "MAKEFLAGS",
    "RTLMP_MIN_CHANNEL_SIZE",
    "PLACE_DENSITY",
]

ELAPSED = (
    "Elapsed time: 0:03.00[h:]min:sec. CPU time: user 1 sys 0 (99%). "
    "Peak memory: 2048KB.\n"
)


class StageArtTest(unittest.TestCase):
    def setUp(self):
        self.saved = dict(os.environ)
        for name in CLEARED:
            os.environ.pop(name, None)
        os.environ.update(ENV)
        self.tmp = tempfile.TemporaryDirectory()

    def tearDown(self):
        os.environ.clear()
        os.environ.update(self.saved)
        self.tmp.cleanup()

    def stage_dir(self, files):
        """A log/report dir holding the given {name: content} files."""
        for name, content in files.items():
            with open(os.path.join(self.tmp.name, name), "w") as f:
                f.write(content if isinstance(content, str) else json.dumps(content))
        return self.tmp.name

    def render(self, path, stem, status, script=None, rich=False, full=False):
        st = stage_art.Stage(stem, status, path, path)
        st.script = script
        return stage_art.render(st, rich=rich, full=full)

    def assert_plain(self, text):
        """ASCII only, and everything but the header fits 80 columns; the
        header carries the version and may run long."""
        text.encode("ascii")
        for line in text.splitlines()[1:]:
            self.assertLessEqual(len(line), stage_art.WIDTH, line)

    # -- every stage -------------------------------------------------------

    def test_healthy_stage_is_a_few_lines(self):
        """A stage with nothing wrong prints the header, what it does, the
        key metrics and the footer; no picture."""
        d = self.stage_dir(
            {
                "2_1_floorplan.json": {
                    "floorplan__design__instance__count": 100,
                    "floorplan__timing__setup__ws": -5.0,
                },
                "3_4_place_resized.json": {
                    "placeopt__design__instance__count": 120,
                    "placeopt__timing__setup__ws": -2.0,
                },
                "3_4_place_resized.log": ELAPSED,
            }
        )
        text = self.render(d, "3_4_place_resized", 0).plain()
        lines = text.splitlines()
        self.assertLessEqual(len(lines), 6, text)
        self.assertIn("3_4_place_resized OK", lines[0])
        # Deltas against the previous stage that reported the metric.
        self.assertIn("inst 120(+20)", text)
        self.assertIn("setup ws -2(+3)", text)
        self.assert_plain(text)

    def test_time_unit_is_named_plainly(self):
        """Metrics give the unit as "1ps"; the summary says ps."""
        d = self.stage_dir(
            {
                "2_1_floorplan.json": {
                    "floorplan__timing__setup__ws": -5.0,
                    "floorplan__flow__platform__time_units": "1ps",
                },
                "2_1_floorplan.log": ELAPSED,
            }
        )
        text = self.render(d, "2_1_floorplan", 0).plain()
        self.assertIn("(time in ps)", text)

    def test_missing_inputs_still_render(self):
        """A stage that crashed before writing metrics or a snapshot is
        explained from what is left: the exit status and the log tail."""
        d = self.stage_dir({"5_2_route.log": "detailed_route\nKilled\n"})
        text = self.render(d, "5_2_route", 137, "detail_route").plain()
        self.assertIn("5_2_route FAIL exit 137", text)
        self.assertIn("error: Killed", text)
        self.assertIn("issue: make detail_route_issue", text)

    def test_error_line_names_the_message(self):
        d = self.stage_dir(
            {"2_1_floorplan.log": "[ERROR IFP-0065] No rows created.\n" + ELAPSED}
        )
        text = self.render(d, "2_1_floorplan", 1, "floorplan").plain()
        self.assertIn("2_1_floorplan FAIL IFP-0065", text)
        self.assertIn("error: No rows created.", text)

    def test_command_line_variables_are_listed(self):
        """What a maintainer asks first: which settings did you change?"""
        d = self.stage_dir({"2_1_floorplan.log": "[ERROR IFP-0065] No rows.\n"})
        os.environ["SCRIPTS_DIR"] = os.path.join(TEST_DIR, "..", "scripts")
        os.environ["MAKEFLAGS"] = "s -j4 -- CORE_UTILIZATION=90 DESIGN_CONFIG=x"
        text = self.render(d, "2_1_floorplan", 1).plain()
        self.assertIn("vars: CORE_UTILIZATION=90* (*make cmdline)", text)

    def test_failed_probe_is_skipped(self):
        """A probe that errored in Tcl is ignored, not drawn as data."""
        d = self.stage_dir(
            {"2_2_floorplan_macro.art.json": {"macros": {"probe_error": "boom"}}}
        )
        st = stage_art.Stage("2_2_floorplan_macro", 0, d, d)
        self.assertIsNone(st.probe("macros"))
        stage_art.render(st, rich=False)

    def test_snapshot_names_the_design(self):
        """Rendering later from the stage's outputs alone, without the
        flow's environment, still says which design and platform."""
        d = self.stage_dir(
            {
                "2_1_floorplan.art.json": {
                    "design": "aes",
                    "platform": "sky130hd",
                    "variant": "base",
                },
                "2_1_floorplan.log": ELAPSED,
            }
        )
        for name in ENV:
            os.environ.pop(name)
        text = self.render(d, "2_1_floorplan", 0).plain()
        self.assertIn("aes/sky130hd", text.splitlines()[0])

    def test_rendering_is_deterministic(self):
        d = self.stage_dir({"5_2_route.log": "[ERROR DRT-0001] x\n" + ELAPSED})
        a = self.render(d, "5_2_route", 1).plain()
        b = self.render(d, "5_2_route", 1).plain()
        self.assertEqual(a, b)

    def test_main_appends_plain_text_to_the_log(self):
        d = self.stage_dir({"2_1_floorplan.log": "[ERROR IFP-0065] No rows.\n"})
        log = os.path.join(d, "2_1_floorplan.log")
        with open(log) as f:
            before = f.read()
        result = subprocess.run(
            [
                sys.executable,
                os.path.join(UTILS_DIR, "stage_art.py"),
                "--stage=2_1_floorplan",
                "--status=1",
                "--log-dir=" + d,
                "--reports-dir=" + d,
            ],
            capture_output=True,
            text=True,
            env=dict(os.environ, TERM="dumb"),
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        with open(log) as f:
            after = f.read()
        self.assertTrue(after.startswith(before))
        self.assertIn("== ORFS 2_1_floorplan FAIL", after[len(before) :])
        self.assertNotIn("\x1b", after)

    def test_rich_rendering_has_the_same_lines(self):
        if importlib.util.find_spec("rich") is None:
            self.skipTest("rich not installed")
        d = self.stage_dir({"2_1_floorplan.log": "[ERROR IFP-0065] No rows.\n"})
        rich = self.render(d, "2_1_floorplan", 1, rich=True)
        plain = self.render(d, "2_1_floorplan", 1).plain()
        self.assertEqual(len(rich.lines), len(plain.splitlines()))


if __name__ == "__main__":
    unittest.main()
