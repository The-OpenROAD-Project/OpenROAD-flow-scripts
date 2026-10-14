#!/usr/bin/env python3

import importlib.util
import os
import shutil
import subprocess
import sys
import tempfile
import textwrap
import unittest
from unittest.mock import patch

GEN_REPORT_PATH = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "util", "genReport.py"
)
with patch("sys.argv", [GEN_REPORT_PATH]), patch("os.chdir"):
    SPEC = importlib.util.spec_from_file_location("genReport", GEN_REPORT_PATH)
    genReport = importlib.util.module_from_spec(SPEC)
    SPEC.loader.exec_module(genReport)


class TestReportCollection(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp_dir.cleanup)
        self.tmp = self.tmp_dir.name
        for folder in ("test", "util", "reports"):
            os.makedirs(os.path.join(self.tmp, folder))
        shutil.copy2(GEN_REPORT_PATH, os.path.join(self.tmp, "util/genReport.py"))
        self.helper = os.path.join(self.tmp, "test/test_helper.sh")
        shutil.copy2(
            os.path.join(os.path.dirname(GEN_REPORT_PATH), "../test/test_helper.sh"),
            self.helper,
        )
        self.write_file(
            "designs/sky130hd/gcd/config.mk",
            "PLATFORM = sky130hd\nDESIGN_NICKNAME = gcd\n",
        )
        # Real Make resolves the run directory and fails on the missing input.
        self.write_file(
            "Makefile",
            textwrap.dedent("""\
                include $(DESIGN_CONFIG)
                FLOW_VARIANT ?= base
                LOG_DIR = $(WORK_HOME)/logs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
                .PHONY: clean_all clean_metadata finish metadata
                clean_all clean_metadata:
                \t@rm -f $(LOG_DIR)/[1-6]_*.log
                finish: missing.v
                \t@mkdir -p $(LOG_DIR)
                \t@echo Finished > $(LOG_DIR)/6_report.log
                metadata:
                \t@true
                print-%:
                \t$(info $*: $($*))
                \t@true
                """),
        )
        self.env = dict(os.environ, WORK_HOME=self.tmp)
        for key in ("FLOW_VARIANT", "MAKE_ISSUE", "SAVE_TO_DB", "RUN_CALIBRE"):
            self.env.pop(key, None)

    def write_file(self, path, content):
        path = os.path.join(self.tmp, path)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(content)

    def run_helper(self):
        return subprocess.run(
            ["bash", self.helper, "gcd", "sky130hd"],
            env=self.env,
            capture_output=True,
            text=True,
        )

    def summary(self):
        result = subprocess.run(
            [sys.executable, os.path.join(self.tmp, "util/genReport.py"), "-sv"],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        with open(os.path.join(self.tmp, "reports/report-summary.log")) as f:
            return f.read()

    def test_summary_includes_make_failure_before_the_first_stage(self):
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertRegex(result.stdout, r"No rule to make target .missing\.v.")
        for platform in ("nangate45", "ihp-sg13g2"):
            self.write_file(f"logs/{platform}/gcd/base/6_report.log", "Finished\n")
            self.write_file(f"reports/{platform}/gcd/base/metadata-check.log", "")
        self.write_file(
            "reports/nangate45/gcd/base/metadata-check.log",
            "[ERROR] nangate45/gcd/base: FAIL\n",
        )

        summary = self.summary()

        self.assertIn("Number of designs: 3", summary)
        self.assertIn("nangate45 gcd (base)", summary)
        self.assertIn("sky130hd gcd (base)\n  Flow did not reach last stage.", summary)
        self.assertRegex(summary, r"No rule to make target .missing\.v.")
        self.assertNotIn("ihp-sg13g2 gcd (base)", summary)

    def test_early_failure_uses_the_configured_variant_and_design_nickname(self):
        self.write_file(
            "designs/sky130hd/gcd/config.mk",
            "PLATFORM = sky130hd\nDESIGN_NICKNAME = gcd_alias\nFLOW_VARIANT = alternate\n",
        )
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn(
            "sky130hd gcd_alias (alternate)\n  Flow did not reach last stage.",
            self.summary(),
        )

    def test_successful_rerun_does_not_keep_the_early_failure(self):
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.write_file("missing.v", "")
        result = self.run_helper()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        summary = self.summary()
        self.assertIn("Number of designs: 1", summary)
        self.assertNotIn("Failing designs", summary)

    def test_finish_log_is_recognized_with_a_later_auxiliary_log(self):
        self.write_file("logs/sky130hd/gcd/base/6_report.log", "Finished\n")
        self.write_file("logs/sky130hd/gcd/base/6_write_rc.log", "RC values\n")
        summary = self.summary()
        self.assertIn("Number of designs: 1", summary)
        self.assertNotIn("Failing designs", summary)

    def test_empty_log_directory_is_reported_as_incomplete(self):
        os.makedirs(os.path.join(self.tmp, "logs/sky130hd/gcd/base"))
        summary = self.summary()
        self.assertIn("Number of designs: 1", summary)
        self.assertIn("sky130hd gcd (base)\n  Flow did not reach last stage.", summary)
        self.assertIn("No log file found.", summary)


class TestGenReport(unittest.TestCase):
    def test_incomplete_flow_reports_that_it_did_not_reach_last_stage(self):
        name = "nangate45 gcd (base)"
        data = {
            "status": genReport.STATUS_RED,
            "finished": False,
            "last_log": "5_route.log",
            "log_errors": [],
            "metrics_logs_errors": [],
            "metrics_errors": [],
            "metrics_regressions": [],
            "calibre_errors": [],
            "drcs": {},
        }

        report = genReport.gen_report(name, data)

        self.assertEqual(
            report,
            "\n".join(
                [
                    name,
                    "  Flow did not reach last stage.",
                    "  Last log file 5_route.log",
                ]
            ),
        )

    def test_parse_qor_regressions_omits_the_optional_heading(self):
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8") as log:
            log.write("Ignored UTF-8 text: µ\n")
            log.write(
                "QoR regression detected for nangate45/gcd:\n"
                "  cts__timing__setup__tns -12.2456 "
                "(base -6.95522, limit -8.346264)\n"
            )
            log.flush()

            self.assertEqual(
                genReport.parse_qor_regressions(log.name),
                [
                    "cts__timing__setup__tns -12.2456 "
                    "(base -6.95522, limit -8.346264)"
                ],
            )

    def test_qor_metrics_are_nested_under_the_failing_run(self):
        name = "nangate45 gcd (base)"
        data = {
            "status": genReport.STATUS_RED,
            "finished": True,
            "last_log": "",
            "log_errors": [],
            "metrics_logs_errors": [],
            "metrics_errors": [
                "[ERROR] nangate45/gcd/base: FAIL — 19 passed, 6 failed, "
                "0 missing (478 metrics sent)",
                "[ERROR] Failing runs: nangate45/gcd/base",
            ],
            "metrics_regressions": [
                "cts__timing__setup__tns -12.2456 " "(base -6.95522, limit -8.346264)",
                "cts__timing__setup__ws -0.261172 " "(base -0.156758, limit -0.169258)",
                "finish__timing__setup__tns -12.4146 "
                "(base -7.19445, limit -8.63334)",
                "finish__timing__setup__ws -0.271991 "
                "(base -0.163541, limit -0.176041)",
                "globalroute__timing__setup__tns -12.7365 "
                "(base -7.5407, limit -9.04884)",
                "globalroute__timing__setup__ws -0.275208 "
                "(base -0.171167, limit -0.183667)",
            ],
            "calibre_errors": [],
            "drcs": {},
        }

        report = genReport.gen_report(name, data)

        self.assertEqual(
            report,
            "\n".join(
                [
                    name,
                    "  Flow reached last stage.",
                    "  Found 2 metrics failures.",
                    "      [ERROR] nangate45/gcd/base: FAIL — 19 passed, 6 failed, "
                    "0 missing (478 metrics sent)",
                    "          cts__timing__setup__tns -12.2456 "
                    "(base -6.95522, limit -8.346264)",
                    "          cts__timing__setup__ws -0.261172 "
                    "(base -0.156758, limit -0.169258)",
                    "          finish__timing__setup__tns -12.4146 "
                    "(base -7.19445, limit -8.63334)",
                    "          finish__timing__setup__ws -0.271991 "
                    "(base -0.163541, limit -0.176041)",
                    "          globalroute__timing__setup__tns -12.7365 "
                    "(base -7.5407, limit -9.04884)",
                    "          globalroute__timing__setup__ws -0.275208 "
                    "(base -0.171167, limit -0.183667)",
                    "      [ERROR] Failing runs: nangate45/gcd/base",
                ]
            ),
        )


if __name__ == "__main__":
    unittest.main()
