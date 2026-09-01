#!/usr/bin/env python3

"""Tests for pinAutoFloorplan.py.

The job is editing a config.mk in place without disturbing it, so the
cases that matter are about what the file looks like afterwards: existing
assignments keep their position and operator, missing ones land next to
their relatives, and nothing else in the file moves.
"""

import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "pinAutoFloorplan.py")

WINNER = {
    "util": 78.0,
    "aspect": 1.25,
    "margin": 2.0,
    "density": 0.938,
    "addon": 0.15,
    "die_rect": "0.0 0.0 16.919 16.919",
    "core_rect": "1.026 1.08 15.876 15.66",
}

EVIDENCE = {
    "winner": WINNER,
    "incumbent": {"util": 65, "aspect": 1, "addon": -1},
    "delta_tie": 3.42,
    "period": {"sdc_target": 310, "achieved": 355.1},
}


def run(config_text, evidence=None):
    with tempfile.TemporaryDirectory() as d:
        cfg = os.path.join(d, "config.mk")
        ev = os.path.join(d, "ev.json")
        with open(cfg, "w") as f:
            f.write(config_text)
        with open(ev, "w") as f:
            json.dump(evidence or EVIDENCE, f)
        p = subprocess.run(
            [sys.executable, SCRIPT, ev, cfg],
            capture_output=True,
            text=True,
        )
        with open(cfg) as f:
            return p.returncode, f.read(), p.stdout + p.stderr


class TestPin(unittest.TestCase):
    def test_updates_in_place_keeping_position(self):
        cfg = (
            "export DESIGN_NAME = gcd\n"
            "export CORE_UTILIZATION = 65\n"
            "export PLACE_DENSITY = 0.35\n"
            "export SDC_FILE = constraint.sdc\n"
        )
        rc, out, log = run(cfg)
        self.assertEqual(rc, 0, log)
        lines = out.splitlines()
        # position preserved: utilization is still the second line
        self.assertTrue(lines[1].startswith("export CORE_UTILIZATION"))
        self.assertIn("78", lines[1])
        # unrelated lines untouched
        self.assertIn("export DESIGN_NAME = gcd", out)
        self.assertIn("export SDC_FILE = constraint.sdc", out)

    def test_no_markers_or_banner(self):
        rc, out, log = run("export CORE_UTILIZATION = 65\n")
        self.assertEqual(rc, 0, log)
        for banned in ("BEGIN AUTO_FLOORPLAN", "do not edit", "generated"):
            self.assertNotIn(banned, out)

    def test_preserves_conditional_operator(self):
        # A design that deliberately allows the platform to override keeps
        # doing so; a pin changes the value, not the semantics.
        rc, out, log = run("export PLACE_DENSITY ?= 0.35\n")
        self.assertEqual(rc, 0, log)
        self.assertIn("export PLACE_DENSITY ?= 0.938", out)

    def test_appends_missing_next_to_relatives(self):
        cfg = "export DESIGN_NAME = gcd\nexport CORE_UTILIZATION = 65\nexport SDC_FILE = x.sdc\n"
        rc, out, log = run(cfg)
        self.assertEqual(rc, 0, log)
        lines = out.splitlines()
        u = next(i for i, l in enumerate(lines) if "CORE_UTILIZATION" in l)
        d = next(i for i, l in enumerate(lines) if "PLACE_DENSITY " in l)
        s = next(i for i, l in enumerate(lines) if "SDC_FILE" in l)
        # new density lands after the utilization it belongs with, and
        # before the unrelated tail
        self.assertGreater(d, u)
        self.assertGreater(s, d)

    def test_new_design_with_no_floorplan_vars(self):
        # "wire up the strictly necessary variables and let the pin fill
        # in the rest"
        cfg = "export DESIGN_NAME = newthing\nexport SDC_FILE = c.sdc\n"
        rc, out, log = run(cfg)
        self.assertEqual(rc, 0, log)
        for v in ("CORE_UTILIZATION", "CORE_ASPECT_RATIO", "CORE_MARGIN", "PLACE_DENSITY"):
            self.assertIn(v, out)
        self.assertIn("export DESIGN_NAME = newthing", out)

    def test_rectangle_design_stays_a_rectangle(self):
        cfg = (
            "export DIE_AREA = 0 0 17 17\n"
            "export CORE_AREA = 1.08 1.08 16 16\n"
            "export PLACE_DENSITY = 0.70\n"
        )
        rc, out, log = run(cfg)
        self.assertEqual(rc, 0, log)
        self.assertIn("export DIE_AREA = 0.0 0.0 16.919 16.919", out)
        self.assertIn("export CORE_AREA = 1.026 1.08 15.876 15.66", out)
        # and is not silently converted to a utilization
        self.assertNotIn("CORE_UTILIZATION", out)

    def test_utilization_design_does_not_gain_a_rectangle(self):
        rc, out, log = run("export CORE_UTILIZATION = 65\n")
        self.assertEqual(rc, 0, log)
        self.assertNotIn("DIE_AREA", out)

    def test_writes_only_one_density_form(self):
        # place_density_with_lb_addon() returns the addon form whenever the
        # addon is set, so writing both would leave PLACE_DENSITY dead and
        # let the addon re-resolve to something other than what was
        # measured.
        rc, out, log = run("export PLACE_DENSITY = 0.35\n")
        self.assertEqual(rc, 0, log)
        self.assertIn("export PLACE_DENSITY = 0.938", out)
        self.assertNotIn("PLACE_DENSITY_LB_ADDON", out)

    def test_addon_design_keeps_the_addon_form(self):
        rc, out, log = run("export PLACE_DENSITY_LB_ADDON = 0.20\n")
        self.assertEqual(rc, 0, log)
        self.assertIn("export PLACE_DENSITY_LB_ADDON = 0.15", out)
        self.assertNotIn("export PLACE_DENSITY ", out)

    def test_idempotent(self):
        cfg = "export CORE_UTILIZATION = 65\nexport PLACE_DENSITY = 0.35\n"
        rc, once, _ = run(cfg)
        self.assertEqual(rc, 0)
        rc2, twice, log = run(once)
        self.assertEqual(rc2, 0, log)
        self.assertEqual(once, twice)
        self.assertIn("already holds these values", log)

    def test_no_winner_is_an_error_not_a_silent_write(self):
        ev = dict(EVIDENCE)
        ev["winner"] = None
        rc, out, log = run("export CORE_UTILIZATION = 65\n", evidence=ev)
        self.assertEqual(rc, 1, log)
        self.assertIn("export CORE_UTILIZATION = 65", out)

    def test_provenance_goes_to_stdout_not_the_file(self):
        rc, out, log = run("export CORE_UTILIZATION = 65\n")
        self.assertEqual(rc, 0, log)
        self.assertIn("delta_tie", log)
        self.assertNotIn("delta_tie", out)


if __name__ == "__main__":
    unittest.main()
