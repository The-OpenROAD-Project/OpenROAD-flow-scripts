#!/usr/bin/env python3

import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

UTIL_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
sys.path.append(UTIL_DIR)

import collectMetadata

SCRIPT = os.path.join(UTIL_DIR, "collectMetadata.py")


class TestCollectMetadata(unittest.TestCase):
    def setUp(self):
        self.flow = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.flow)

    def report(self, platform, design, variant, metadata=None, raw=None):
        path = os.path.join(self.flow, "reports", platform, design, variant)
        os.makedirs(path, exist_ok=True)
        if metadata is not None:
            raw = json.dumps(metadata)
        if raw is not None:
            with open(os.path.join(path, "metadata.json"), "w") as f:
                f.write(raw)
        return path

    def log(self, platform, design, variant, name, text=""):
        path = os.path.join(self.flow, "logs", platform, design, variant)
        os.makedirs(path, exist_ok=True)
        with open(os.path.join(path, name), "w") as f:
            f.write(text)

    def collect(self):
        return collectMetadata.collect(self.flow)

    def test_no_reports_gives_an_empty_summary(self):
        self.assertEqual(
            self.collect(),
            {"collector_version": 1, "designs": [], "skipped": []},
        )

    def test_metrics_are_kept_verbatim(self):
        metadata = {
            "run__flow__design": "gcd",
            "finish__timing__setup__ws": -0.1,
            "globalroute__antenna_diodes_count": 3,
            "detailedroute__route__wirelength__iter:1": 7,
            "finish__power__total__units": "W",
        }
        self.report("asap7", "gcd", "base", metadata)
        (design,) = self.collect()["designs"]
        self.assertEqual(design["platform"], "asap7")
        self.assertEqual(design["design"], "gcd")
        self.assertEqual(design["variant"], "base")
        self.assertEqual(design["metrics"], metadata)

    def test_designs_are_in_report_path_order(self):
        self.report("sky130hd", "gcd", "base", {})
        self.report("asap7", "ibex", "base", {})
        self.report("asap7", "gcd", "base", {})
        names = [(d["platform"], d["design"]) for d in self.collect()["designs"]]
        self.assertEqual(
            names, [("asap7", "gcd"), ("asap7", "ibex"), ("sky130hd", "gcd")]
        )

    def test_every_platform_is_reported(self):
        self.report("sky130hd_fakestack", "gcd", "base", {})
        self.report("src", "gcd", "base", {})
        self.assertEqual(len(self.collect()["designs"]), 2)

    def test_run_without_metadata_has_null_metrics(self):
        self.report("asap7", "gcd", "base")
        (design,) = self.collect()["designs"]
        self.assertIsNone(design["metrics"])

    def test_directories_at_other_depths_are_ignored(self):
        os.makedirs(os.path.join(self.flow, "reports", "asap7", "ibex"))
        os.makedirs(os.path.join(self.flow, "reports", "asap7", "gcd", "base", "x"))
        names = [(d["design"], d["variant"]) for d in self.collect()["designs"]]
        self.assertEqual(names, [("gcd", "base")])

    def test_unreadable_metadata_is_skipped(self):
        self.report("asap7", "gcd", "base", raw="{not json")
        self.report("asap7", "ibex", "base", {"a": 1})
        summary = self.collect()
        self.assertEqual([d["design"] for d in summary["designs"]], ["ibex"])
        (skipped,) = summary["skipped"]
        self.assertEqual(skipped["design"], "gcd")
        self.assertTrue(skipped["error"])

    def test_metadata_that_is_not_an_object_is_skipped(self):
        self.report("asap7", "gcd", "base", raw="[1, 2]")
        summary = self.collect()
        self.assertEqual(summary["designs"], [])
        self.assertEqual(len(summary["skipped"]), 1)

    def test_no_logs(self):
        self.report("asap7", "gcd", "base", {})
        (design,) = self.collect()["designs"]
        self.assertEqual(
            design["logs"],
            {"last_stage": None, "first_error": None, "crashed": False},
        )

    def test_last_stage_and_first_error_from_the_last_stage_back(self):
        self.report("asap7", "gcd", "base")
        self.log("asap7", "gcd", "base", "1_2_yosys.log", "ERROR: early\n")
        self.log("asap7", "gcd", "base", "3_3_place_gp.log", "ok\n")
        self.log(
            "asap7",
            "gcd",
            "base",
            "5_1_grt.log",
            "info\n[ERROR GRT-0116] Global routing failed.\n[ERROR GRT-0001] x\n",
        )
        self.log("asap7", "gcd", "base", "notes.txt", "[ERROR GRT-0002] no\n")
        (design,) = self.collect()["designs"]
        self.assertEqual(
            design["logs"],
            {
                "last_stage": "grt",
                "first_error": "[ERROR GRT-0116] Global routing failed.",
                "crashed": False,
            },
        )

    def test_error_found_in_an_earlier_stage(self):
        self.report("asap7", "gcd", "base")
        self.log("asap7", "gcd", "base", "1_2_yosys.log", "ERROR: no top module\n")
        self.log("asap7", "gcd", "base", "2_1_floorplan.log", "fine\n")
        (design,) = self.collect()["designs"]
        self.assertEqual(design["logs"]["last_stage"], "floorplan")
        self.assertEqual(design["logs"]["first_error"], "ERROR: no top module")

    def test_signal_in_the_last_stage_log_is_a_crash(self):
        self.report("asap7", "gcd", "base")
        self.log("asap7", "gcd", "base", "4_1_cts.log", "Signal 11 received\n")
        (design,) = self.collect()["designs"]
        self.assertEqual(design["logs"]["last_stage"], "cts")
        self.assertTrue(design["logs"]["crashed"])

    def test_signal_in_an_earlier_log_is_not_a_crash(self):
        self.report("asap7", "gcd", "base")
        self.log("asap7", "gcd", "base", "4_1_cts.log", "Segmentation fault\n")
        self.log("asap7", "gcd", "base", "5_2_route.log", "fine\n")
        (design,) = self.collect()["designs"]
        self.assertEqual(design["logs"]["last_stage"], "route")
        self.assertFalse(design["logs"]["crashed"])

    def test_stage_names(self):
        cases = {
            "1_1_yosys_canonicalize.log": "synth",
            "2_1_floorplan.log": "floorplan",
            "3_3_place_gp.log": "place",
            "4_1_cts.log": "cts",
            "5_1_grt.log": "grt",
            "5_2_route.log": "route",
            "6_report.log": "finish",
            "7_unknown.log": None,
            "notes.log": None,
        }
        for name, stage in cases.items():
            with self.subTest(name=name):
                self.assertEqual(collectMetadata.stage_name(name), stage)

    def test_command_line_writes_the_file(self):
        self.report("asap7", "gcd", "base", {"a": 1})
        output = os.path.join(self.flow, "out", "summary.json")
        os.makedirs(os.path.dirname(output))
        result = subprocess.run(
            [sys.executable, SCRIPT, "--flowDir", self.flow, "--output", output],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        with open(output) as f:
            summary = json.load(f)
        self.assertEqual(summary["designs"][0]["metrics"], {"a": 1})
        self.assertFalse(os.path.exists(output + ".tmp"))

    def test_failure_exits_non_zero_without_output(self):
        output = os.path.join(self.flow, "missing-dir", "summary.json")
        result = subprocess.run(
            [sys.executable, SCRIPT, "--flowDir", self.flow, "--output", output],
            capture_output=True,
            text=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(os.path.exists(output))


if __name__ == "__main__":
    unittest.main()
