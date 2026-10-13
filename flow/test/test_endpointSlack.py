#!/usr/bin/env python3

import json
import os
import sys
import tempfile
import unittest
from io import StringIO
from unittest.mock import patch

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import endpointSlack


def snapshot(step, endpoints):
    return {
        "design": "test",
        "step": step,
        "parasitics": "placement",
        "time_unit": 1e-12,
        "endpoints": endpoints,
    }


class TestEndpointSlack(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        # slacks in ps: [setup, hold]
        self.a_file = self.write(
            "3_5_place_dp",
            {
                "r1/D": [-10.0, 5.0],  # improves to passing
                "r2/D": [20.0, 5.0],  # degrades to failing
                "r3/D": [30.0, 5.0],  # unchanged
                "r4/D": [40.0, 5.0],  # removed in B
                "out": [None, None],  # unconstrained
            },
        )
        self.b_file = self.write(
            "4_1_cts",
            {
                "r1/D": [15.0, 4.0],
                "r2/D": [-5.0, 6.0],
                "r3/D": [30.0, None],  # hold constrained only in A
                "r5/D": [50.0, 5.0],  # new in B
                "out": [None, None],
                "clkload0/Y": [None, None],  # new but unconstrained
            },
        )
        os.utime(self.a_file, (1, 1))
        os.utime(self.b_file, (2, 2))

    def tearDown(self):
        self.tmp_dir.cleanup()

    def write(self, step, endpoints):
        f = os.path.join(self.tmp_dir.name, step + endpointSlack.SUFFIX)
        with open(f, "w") as fh:
            json.dump(snapshot(step, endpoints), fh)
        return f

    def test_load(self):
        a = endpointSlack.load_snapshot(self.a_file)
        self.assertEqual(a["name"], "3_5_place_dp")
        self.assertEqual(len(a["endpoints"]), 5)
        self.assertNotIn("out", a["setup"])
        self.assertAlmostEqual(a["setup"]["r1/D"], -10e-12)
        s = endpointSlack.summary(a["setup"])
        self.assertEqual(s["violations"], 1)
        self.assertAlmostEqual(s["wns"], -10e-12)
        self.assertAlmostEqual(s["tns"], -10e-12)

    def test_compare(self):
        a = endpointSlack.load_snapshot(self.a_file)
        b = endpointSlack.load_snapshot(self.b_file)
        setup = endpointSlack.compare(a, b, "setup")
        self.assertEqual([ep for ep, _ in setup["only_a"]], ["r4/D"])
        self.assertEqual([ep for ep, _ in setup["only_b"]], ["r5/D"])
        self.assertEqual(len(setup["both"]), 3)
        m = endpointSlack.movement(setup["both"])
        self.assertEqual(
            m,
            {
                "improved": 1,
                "degraded": 1,
                # r3/D is unchanged but positive in both, so not counted
                "unchanged": 0,
                "newly_failing": 1,
                "newly_passing": 1,
            },
        )
        hold = endpointSlack.compare(a, b, "hold")
        self.assertEqual([ep for ep, _ in hold["constrained_only_a"]], ["r3/D"])
        self.assertEqual(len(hold["both"]), 2)

    def test_tolerance(self):
        both = [("r1/D", -10e-12, -9.9e-12), ("r2/D", -10e-12, -12e-12)]
        m = endpointSlack.movement(both, tolerance=0.5e-12)
        self.assertEqual((m["improved"], m["degraded"], m["unchanged"]), (0, 1, 1))
        m = endpointSlack.movement(both)
        self.assertEqual((m["improved"], m["degraded"], m["unchanged"]), (1, 1, 0))

    def test_worst(self):
        a = endpointSlack.load_snapshot(self.a_file)
        b = endpointSlack.load_snapshot(self.b_file)
        setup = endpointSlack.compare(a, b, "setup", worst=1)
        # worst of A is r1/D, worst of B is r2/D
        self.assertEqual(sorted(ep for ep, _, _ in setup["both"]), ["r1/D", "r2/D"])

    def test_spearman(self):
        self.assertAlmostEqual(endpointSlack.spearman([1, 2, 3], [10, 20, 30]), 1.0)
        self.assertAlmostEqual(endpointSlack.spearman([1, 2, 3], [3, 2, 1]), -1.0)
        self.assertEqual(endpointSlack._ranks([5, 1, 5, 3]), [3.5, 1.0, 3.5, 2.0])
        self.assertIsNone(endpointSlack.spearman([1], [1]))
        self.assertIsNone(endpointSlack.spearman([1, 1], [1, 2]))

    def test_metrics(self):
        a = endpointSlack.load_snapshot(self.a_file)
        b = endpointSlack.load_snapshot(self.b_file)
        m = endpointSlack.compare(a, b, "setup")["metrics"]
        # r3/D is positive in both and excluded; r1/D: -10 -> 15, r2/D: 20 -> -5
        self.assertEqual(m["n"], 2)
        self.assertAlmostEqual(m["spearman"], -1.0)
        self.assertAlmostEqual(m["bias"], 0.0)
        self.assertAlmostEqual(m["mae"], 25e-12)
        self.assertAlmostEqual(m["max_abs"], 25e-12)
        self.assertAlmostEqual(m["top_agreement"], 1.0)
        self.assertEqual(m["violator_recall"], 0.0)
        self.assertEqual(m["violator_precision"], 0.0)
        # With K=1 the worst of A (r1/D) and of B (r2/D) differ
        m = endpointSlack.compare(a, b, "setup", critical=1)["metrics"]
        self.assertEqual(m["n"], 2)
        self.assertAlmostEqual(m["top_agreement"], 0.0)
        # No hold violations: nothing critical
        m = endpointSlack.compare(a, b, "hold")["metrics"]
        self.assertEqual(m["n"], 0)
        self.assertIsNone(m["spearman"])
        self.assertIsNone(m["violator_recall"])

    def test_index_row_class(self):
        def row_class(a_eps, b_eps):
            a = endpointSlack.load_snapshot(self.write("3_3_place_gp", a_eps))
            b = endpointSlack.load_snapshot(self.write("3_4_place_resized", b_eps))
            cmps = {c: endpointSlack.compare(a, b, c) for c in endpointSlack.CHECKS}
            page = endpointSlack.track_index_html([(a, b, cmps)], 1e9, "ns", None)
            body = page[page.index("<tr><th rowspan") :]
            for cls in ("same", "better"):
                if f"class='{cls}'" in body:
                    return cls
            return ""

        base = {"r1/D": [-10.0, 5.0], "r2/D": [-20.0, 5.0], "r3/D": [30.0, 5.0]}
        # Only an endpoint positive in both changed
        self.assertEqual(row_class(base, {**base, "r3/D": [40.0, 6.0]}), "same")
        # Every considered endpoint improved
        better = {**base, "r1/D": [-5.0, 5.0], "r2/D": [1.0, 5.0]}
        self.assertEqual(row_class(base, better), "better")
        # One considered endpoint unchanged
        self.assertEqual(row_class(base, {**base, "r1/D": [-5.0, 5.0]}), "")
        # One considered endpoint degraded
        self.assertEqual(row_class(base, {**better, "r2/D": [-25.0, 5.0]}), "")

    @patch("sys.stdout", new_callable=StringIO)
    def test_cli(self, mock_stdout):
        html_file = os.path.join(self.tmp_dir.name, "cmp.html")
        csv_file = os.path.join(self.tmp_dir.name, "slack.csv")
        endpointSlack.main(["compare", self.a_file, self.b_file, "-o", html_file])
        endpointSlack.main(["export", self.tmp_dir.name, "-o", csv_file])
        endpointSlack.main(["list", self.tmp_dir.name])
        track_dir = os.path.join(self.tmp_dir.name, "track")
        endpointSlack.main(["track", self.tmp_dir.name, "--html", track_dir])
        out = mock_stdout.getvalue()
        self.assertIn("newly failing=1 newly passing=1", out)
        self.assertIn("3_5_place_dp (placement parasitics) -> 4_1_cts", out)
        with open(html_file) as f:
            content = f.read()
        self.assertIn("const DATA = {", content)
        self.assertNotIn("__DATA__", content)
        with open(csv_file) as f:
            self.assertEqual(len(f.readlines()), 1 + 5 + 6)
        self.assertEqual(
            sorted(os.listdir(track_dir)),
            ["3_5_place_dp__4_1_cts.html", "index.html"],
        )
        with open(os.path.join(track_dir, "index.html")) as f:
            self.assertIn("3_5_place_dp__4_1_cts.html", f.read())


if __name__ == "__main__":
    unittest.main()
