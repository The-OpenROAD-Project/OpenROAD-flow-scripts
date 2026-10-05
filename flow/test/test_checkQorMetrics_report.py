#!/usr/bin/env python3
"""Tests that failed QoR rules reach the report summary.

genReport.py copies only the [ERROR] lines of metadata-check.log into
reports/report-summary.log, which CI prints at the end of a build. These
tests check that checkQorMetrics.py writes one such line per failed rule,
with its values, and that the summary shows them.
"""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest

UTIL_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
sys.path.append(UTIL_DIR)

import checkQorMetrics


def metric(name, status, target, base, threshold, delta):
    return {
        "metricName": name,
        "status": status,
        "targetValue": target,
        "baseValue": base,
        "thresholdValue": threshold,
        "deltaPct": delta,
        "ruleSource": "rule_config",
    }


def result(status, metrics, failed):
    return {
        "platform": "sky130hd",
        "design": "riscv32i",
        "variant": "base",
        "status": status,
        "metric_count": 499,
        "response": {
            "status": status,
            "baselineStrategy": "latest-master",
            "baseBuildId": 33029,
            "baseCommitSha": "55687ece2024cc7682ec56b34109ab0490cf2ee4",
            "totals": {
                "passed": len(metrics) - failed,
                "failed": failed,
                "missingFromBaseline": 0,
            },
            "metrics": metrics,
        },
    }


FAILING = result(
    "fail",
    [
        metric("cts__timing__setup__ws", "pass", -52.623, -60.0663, -80.0663, -12.39),
        metric(
            "globalroute__timing__setup__tns",
            "fail",
            -8899.95,
            -4617.66,
            -5541.192,
            92.74,
        ),
        metric(
            "finish__timing__setup__tns", "fail", -8900.79, -4650.05, -5580.06, 91.41
        ),
    ],
    failed=2,
)


def errors(lines):
    return [line for line in lines if line.startswith("[ERROR]")]


class RenderRunTest(unittest.TestCase):
    def test_one_error_line_per_failed_rule(self):
        self.assertEqual(
            errors(checkQorMetrics.render_run(FAILING, verbose=False)),
            [
                "[ERROR] sky130hd/riscv32i/base: finish__timing__setup__tns: "
                "current -8900.7900, baseline -4650.0500, limit -5580.0600, "
                "delta +91.41%",
                "[ERROR] sky130hd/riscv32i/base: globalroute__timing__setup__tns: "
                "current -8899.9500, baseline -4617.6600, limit -5541.1920, "
                "delta +92.74%",
            ],
        )

    def test_summary_adds_no_error_line(self):
        self.assertEqual(errors(checkQorMetrics.summarize([FAILING])), [])
        self.assertEqual(checkQorMetrics.summarize([FAILING])[-1], "QoR check: FAIL")

    def test_table_only_when_verbose(self):
        quiet = "\n".join(checkQorMetrics.render_run(FAILING, verbose=False))
        loud = "\n".join(checkQorMetrics.render_run(FAILING, verbose=True))
        self.assertNotIn("| Metric", quiet)
        self.assertIn("| Metric", loud)
        self.assertIn("cts__timing__setup__ws", loud)

    def test_fail_without_named_metric_still_errors(self):
        lines = checkQorMetrics.render_run(result("fail", [], failed=1), False)
        self.assertEqual(len(errors(lines)), 1)
        self.assertIn("FAIL", errors(lines)[0])

    def test_pass_has_no_error_line(self):
        passing = result(
            "pass", [metric("cts__timing__setup__ws", "pass", 1, 1, 0, 0)], failed=0
        )
        self.assertEqual(errors(checkQorMetrics.render_run(passing, False)), [])


class ReportSummaryTest(unittest.TestCase):
    """Runs genReport.py the way CI does, on a minimal flow tree."""

    def test_summary_lists_failed_rules_with_values(self):
        with tempfile.TemporaryDirectory() as root:
            # genReport.py works from the parent of its own directory.
            os.mkdir(os.path.join(root, "util"))
            shutil.copy(os.path.join(UTIL_DIR, "genReport.py"), f"{root}/util")
            run = os.path.join("sky130hd", "riscv32i", "base")
            for folder in ("logs", "reports"):
                os.makedirs(os.path.join(root, folder, run))
            with open(os.path.join(root, "logs", run, "6_report.log"), "w") as f:
                f.write("done\n")
            lines = checkQorMetrics.render_run(FAILING, False)
            lines += checkQorMetrics.summarize([FAILING])
            check_log = os.path.join(root, "reports", run, "metadata-check.log")
            with open(check_log, "w") as f:
                f.write("\n".join(lines) + "\n")

            subprocess.run(
                [sys.executable, f"{root}/util/genReport.py", "-sv", "-q"],
                check=True,
                capture_output=True,
            )
            with open(os.path.join(root, "reports", "report-summary.log")) as f:
                summary = f.read()

        self.assertIn("Found 2 metrics failures.", summary)
        self.assertIn(
            "finish__timing__setup__tns: current -8900.7900, "
            "baseline -4650.0500, limit -5580.0600, delta +91.41%",
            summary,
        )
        self.assertIn("globalroute__timing__setup__tns: current -8899.9500", summary)


if __name__ == "__main__":
    unittest.main()
