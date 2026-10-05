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

    def fixture(self, name, stem, status, script=None, rich=False):
        return self.render(os.path.join(FIXTURES, name), stem, status, script, rich)

    def frame_rows(self, text):
        """The inside of the first (leftmost) die frame, top row first."""
        lines = text.splitlines()
        top = next(i for i, l in enumerate(lines) if l.startswith(" +-"))
        width = len(lines[top][1:].split(" ")[0]) - 2
        rows = []
        for line in lines[top + 1 :]:
            if line.startswith(" +-"):
                return rows
            rows.append(line[2 : 2 + width])
        return rows

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

    # -- macro placement ---------------------------------------------------

    def test_macro_failure_shows_why_the_macros_do_not_fit(self):
        """MPL-0065 on riscv32i at 85% utilization: macros plus their
        channels and the std cells need more than the core, and the
        picture spills the excess out of it."""
        doc = self.fixture("mpl_fail", "2_2_floorplan_macro", 1, "macro_place")
        text = doc.plain()
        self.assertIn("FAIL MPL-0065", text)
        self.assertIn("why: macros+std cells need 158% of core", text)
        self.assertIn("1 macro left over", text)
        rows = self.frame_rows(text)
        # Three of the four macros fit side by side; the fourth does not.
        self.assertEqual(sum(r.count("A") for r in rows), 3)
        # The std cells fill the strip left next to the macros...
        macro_rows = [i for i, r in enumerate(rows) if "|.|" in r]
        self.assertTrue(
            all(r.rstrip().endswith(":|") for r in (rows[i] for i in macro_rows[1:-1]))
        )
        # ...and the rest spills out of the core, below it.
        spill = [i for i, r in enumerate(rows) if "X" in r]
        self.assertTrue(spill and min(spill) > max(macro_rows))
        self.assertIn("58% of core over", text)
        self.assert_plain(text)

    def test_placed_macros_are_drawn_where_the_placer_put_them(self):
        """riscv32i as configured: the four RAMs placed side by side along
        the top of the core, and the area they and the std cells take."""
        text = self.render(
            os.path.join(FIXTURES, "mpl_ok"), "2_2_floorplan_macro", 0, full=True
        ).plain()
        self.assertIn("2_2_floorplan_macro OK", text)
        rows = self.frame_rows(text)
        labelled = [i for i, r in enumerate(rows) if "A" in r]
        self.assertEqual(len(labelled), 1)
        self.assertEqual(rows[labelled[0]].count("A"), 4)
        # In the top half of the die.
        self.assertLess(labelled[0], len(rows) // 2)
        self.assertRegex(text, r"total +#+\.+ +78%")
        self.assertNotIn("core full", text)
        self.assert_plain(text)

    def test_macro_failure_in_colour_draws_blocks(self):
        if importlib.util.find_spec("rich") is None:
            self.skipTest("rich not installed")
        doc = self.fixture("mpl_fail", "2_2_floorplan_macro", 1, rich=True)
        drawn = "".join(t for line in doc.lines for t, _ in line)
        self.assertIn("█", drawn)  # std cells that do not fit
        self.assertIn("▒", drawn)  # std cells that do

    # -- global placement --------------------------------------------------

    def test_global_place_flags_a_too_low_target_density(self):
        """asap7/gcd asks global placement for density 0.35, below what
        the design can reach (GPL-0302): a QoR prompt, not a failure."""
        text = self.fixture("gpl_low_density", "3_3_place_gp", 0).plain()
        self.assertIn("3_3_place_gp WARN", text)
        self.assertIn("target density 0.35 is below the design's minimum", text)
        self.assertIn("cell density", text)
        self.assertIn("RUDY", text)
        # Overflow falls from the start to the end of placement.
        self.assertRegex(text, r"overflow 0.58 \S+ 0.100 after 323 iterations")
        # Two maps of the same die, side by side.
        framed = [l for l in text.splitlines() if l.startswith(" |")]
        self.assertTrue(framed and all(l.count("|") == 4 for l in framed))
        self.assert_plain(text)

    # -- global route ------------------------------------------------------

    def test_congestion_failure_is_drawn_and_traced_back(self):
        """GRT-0116 on gcd with 85% of routing capacity taken away: the
        overflow is everywhere, and placement density at the hotspot is
        average, so the cause is capacity, not a pile of cells."""
        text = self.fixture("grt_fail", "5_1_grt", 2, "global_route").plain()
        self.assertIn("5_1_grt FAIL GRT-0116", text)
        self.assertIn("why: 135 gcells overflow, worst 117% on M5", text)
        self.assertIn("widespread, not one spot", text)
        self.assertIn("make gui_5_1_grt-failed", text)
        rows = self.frame_rows(text)
        # Overflowing gcells are marked, and the three hotspots numbered
        # on the map and listed beside it, worst first.
        self.assertTrue(any("X" in r for r in rows))
        for k in "123":
            self.assertEqual(sum(r.count(k) for r in rows), 1)
        self.assertRegex(text, r"1 M5 117% at \(7, 2\)um")
        for layer in ["M2", "M3", "M4", "M5", "M6", "M7"]:
            self.assertRegex(text, r"\|\s+%s +[HV] " % layer)
        self.assert_plain(text)

    # -- detailed route ----------------------------------------------------

    def test_detail_route_shows_what_is_left_and_where(self):
        """gcd stopped after DETAILED_ROUTE_END_ITERATION=1 with 10 DRCs:
        the per-iteration counts, the DRCs by type, and where they are on
        the global route congestion map."""
        text = self.fixture("drt_drcs", "5_2_route", 0).plain()
        self.assertIn("5_2_route WARN", text)
        self.assertIn("why: 10 DRC violations left after 2 iterations", text)
        self.assertRegex(text, r"it0 +#+ 43\n +it1 +#+ 10\n")
        self.assertIn("by type: Lef58EolKeepOut x9, Metal Spacing x1", text)
        rows = self.frame_rows(text)
        # Three clusters of markers, over the shaded congestion map.
        self.assertEqual(sum(r.count("x") for r in rows), 3)
        self.assertTrue(any(c in "".join(rows) for c in "-=+*"))
        self.assertIn("DRC Viewer; start with Lef58EolKeepOut", text)
        self.assert_plain(text)


if __name__ == "__main__":
    unittest.main()
