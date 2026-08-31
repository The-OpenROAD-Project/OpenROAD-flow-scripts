#!/usr/bin/env python3

"""Tests for checkPareto.py.

The interesting cases are the ones the existing rules check cannot
express: a genuine trade must pass, a dominated point must fail, and a
lost timing closure must fail even though it looks like a small delta.
"""

import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "checkPareto.py")

# A baseline that meets timing with margin, so closure cases are testable.
BASE = {
    "finish__timing__setup__ws": 10.0,
    "finish__timing__setup__tns": -100.0,
    "finish__design__core__area": 1000.0,
    "finish__design__instance__area": 800.0,
    "finish__power__total": 0.001,
    "detailedroute__route__drc_errors": 0,
    "detailedplace__design__violations": 0,
    "detailedroute__antenna__violating__nets": 0,
}


def rules_from(base, tie=None):
    out = {}
    for k, v in base.items():
        entry = {"value": v, "compare": "<=", "golden": v}
        if tie and k in tie:
            entry["tie"] = tie[k]
        out[k] = entry
    return out


def run(metadata, rules, extra=()):
    with tempfile.TemporaryDirectory() as d:
        m, r = os.path.join(d, "m.json"), os.path.join(d, "r.json")
        with open(m, "w") as f:
            json.dump(metadata, f)
        with open(r, "w") as f:
            json.dump(rules, f)
        p = subprocess.run(
            [sys.executable, SCRIPT, "-m", m, "-r", r, *extra],
            capture_output=True,
            text=True,
        )
        return p.returncode, p.stdout + p.stderr


class TestCheckPareto(unittest.TestCase):
    def test_identical_passes(self):
        rc, out = run(dict(BASE), rules_from(BASE))
        self.assertEqual(rc, 0, out)
        self.assertIn("no measurable movement", out)

    def test_strict_improvement_passes(self):
        new = dict(BASE)
        new["finish__design__core__area"] = 900.0  # -10%
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 0, out)
        self.assertIn("strict improvement", out)

    def test_genuine_trade_passes(self):
        # Core area down 10%, TNS worse 50%: a real move along the front.
        # The existing rules check would simply fail on the TNS half.
        new = dict(BASE)
        new["finish__design__core__area"] = 900.0
        new["finish__timing__setup__tns"] = -150.0
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 0, out)
        self.assertIn("trade:", out)

    def test_dominated_fails(self):
        # Everything worse, nothing better.
        new = dict(BASE)
        new["finish__design__core__area"] = 1200.0
        new["finish__timing__setup__tns"] = -200.0
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 1, out)
        self.assertIn("dominated", out)

    def test_within_tie_band_passes(self):
        # 1% area change against a 1.5% default band is not movement.
        new = dict(BASE)
        new["finish__design__core__area"] = 990.0
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 0, out)
        self.assertIn("no measurable movement", out)

    def test_hard_constraint_regression_fails(self):
        # A DRC error is never a trade, even alongside a big area win.
        new = dict(BASE)
        new["finish__design__core__area"] = 500.0
        new["detailedroute__route__drc_errors"] = 3
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 1, out)
        self.assertIn("hard constraint", out)

    def test_losing_closure_fails(self):
        # +10 ps -> -3 ps. Small in percentage terms, and a change in kind.
        # This is the ibex case from the AUTO_FLOORPLAN sweep.
        new = dict(BASE)
        new["finish__timing__setup__ws"] = -3.0
        new["finish__design__core__area"] = 750.0  # even with a 25% area win
        rc, out = run(new, rules_from(BASE))
        self.assertEqual(rc, 1, out)
        self.assertIn("change in kind", out)

    def test_still_missing_closure_is_not_a_closure_failure(self):
        # A design that already missed timing has no closure to lose; it
        # is judged on the axes like anything else.
        base = dict(BASE)
        base["finish__timing__setup__ws"] = -50.0
        new = dict(base)
        new["finish__timing__setup__ws"] = -55.0
        new["finish__design__core__area"] = 900.0
        rc, out = run(new, rules_from(base))
        self.assertEqual(rc, 0, out)
        self.assertNotIn("change in kind", out)

    def test_require_improvement_fails_on_no_movement(self):
        rc, out = run(dict(BASE), rules_from(BASE), extra=("--require-improvement",))
        self.assertEqual(rc, 1, out)
        self.assertIn("no axis improved", out)

    def test_measured_tie_band_overrides_default(self):
        # A 4% area regression passes when the measured band is 5%.
        new = dict(BASE)
        new["finish__design__core__area"] = 1040.0
        rules = rules_from(BASE, tie={"finish__design__core__area": 0.05})
        rc, out = run(new, rules)
        self.assertEqual(rc, 0, out)
        self.assertIn("measured", out)

    def test_missing_golden_is_warned_not_fatal(self):
        rules = rules_from(BASE)
        del rules["finish__design__core__area"]["golden"]
        rc, out = run(dict(BASE), rules)
        self.assertEqual(rc, 0, out)
        self.assertIn("no golden value for", out)


if __name__ == "__main__":
    unittest.main()
