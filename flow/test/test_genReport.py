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

    def run_report(self, *flags):
        result = subprocess.run(
            [sys.executable, os.path.join(self.tmp, "util/genReport.py"), *flags],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result.stdout

    def read(self, path):
        with open(os.path.join(self.tmp, path), encoding="utf-8") as f:
            return f.read()

    def summary(self, flags="-sv"):
        self.run_report(flags)
        return self.read("reports/report-summary.log")

    def qor_fail(self, pdv, metrics, baseline="https://dashboard.example/builds/7"):
        """A finished run with the CI QoR check verdict FAIL."""
        lines = [f"[ERROR] Dashboard QoR check: FAIL ({pdv})"]
        lines.append(f"QoR regression detected for {pdv}:")
        lines += [f"  {m} 2 (base 1, limit 1.5)" for m in metrics]
        lines.append(f"  Baseline: {baseline}")
        self.finished(pdv, "\n".join(lines) + "\n")

    def finished(self, pdv, check=""):
        """A run that reached the last stage, with its metadata and DRC reports."""
        self.write_file(f"logs/{pdv}/6_report.log", "Finished\n")
        self.write_file(f"reports/{pdv}/metadata-generate.log", "")
        self.write_file(f"reports/{pdv}/metadata-check.log", check)
        self.write_file(f"reports/{pdv}/5_route_drc.rpt", "")

    def test_summary_includes_make_failure_before_the_first_stage(self):
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertRegex(result.stdout, r"No rule to make target .missing\.v.")
        self.finished("ihp-sg13g2/gcd/base")
        self.finished("nangate45/gcd/base", "[ERROR] nangate45/gcd/base: FAIL\n")

        summary = self.summary()

        self.assertIn("SUMMARY: 3 designs, 2 failing, 1 passing", summary)
        self.assertIn("QOR   nangate45/gcd/base", summary)
        self.assertIn("STOP  sky130hd/gcd/base", summary)
        self.assertIn("sky130hd/gcd/base: stopped in 0_make.log", summary)
        self.assertRegex(summary, r"No rule to make target .missing\.v.")
        self.assertNotIn("ihp-sg13g2/gcd/base", summary)

    def test_early_failure_uses_the_configured_variant_and_design_nickname(self):
        self.write_file(
            "designs/sky130hd/gcd/config.mk",
            "PLATFORM = sky130hd\nDESIGN_NICKNAME = gcd_alias\nFLOW_VARIANT = alternate\n",
        )
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn("STOP  sky130hd/gcd_alias/alternate", self.summary())

    def test_successful_rerun_does_not_keep_the_early_failure(self):
        result = self.run_helper()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.write_file("missing.v", "")
        result = self.run_helper()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("SUMMARY: 1 design, 0 failing, 1 passing", self.summary())

    def test_finish_log_is_recognized_with_a_later_auxiliary_log(self):
        self.finished("sky130hd/gcd/base")
        self.write_file("logs/sky130hd/gcd/base/6_write_rc.log", "RC values\n")
        self.assertIn("SUMMARY: 1 design, 0 failing, 1 passing", self.summary())

    def test_empty_log_directory_is_reported_as_incomplete(self):
        os.makedirs(os.path.join(self.tmp, "logs/sky130hd/gcd/base"))
        summary = self.summary()
        self.assertIn("STOP  sky130hd/gcd/base  no log file found", summary)
        self.assertIn(
            "sky130hd/gcd/base: flow did not reach last stage, no log file found",
            summary,
        )

    def test_dashboard_verdict_reaches_the_summary(self):
        self.finished(
            "nangate45/gcd/base",
            "[ERROR] Dashboard QoR check: FAIL (nangate45/gcd/base)\n"
            "QoR regression detected for nangate45/gcd/base:\n"
            "  finish__timing__setup__tns -12.0 (base -6.0, limit -8.0)\n"
            "  Baseline: https://dashboard.example/builds/7\n",
        )
        summary = self.summary()
        self.assertIn("QoR regression 1", summary)
        self.assertIn("QoR baseline: https://dashboard.example/builds/7", summary)
        self.assertIn("QOR   nangate45/gcd/base  finish__timing__setup__tns", summary)
        self.assertIn("nangate45/gcd/base: 1 metric over the limit", summary)
        self.assertRegex(summary, r"finish__timing__setup__tns +-12\.0 +-6\.0 +-8\.0")

    def test_failures_are_ordered_by_criticality(self):
        self.finished(
            "asap7/a_one_metric/base",
            "[ERROR] Dashboard QoR check: FAIL (asap7/a_one_metric/base)\n"
            "QoR regression detected for asap7/a_one_metric/base:\n"
            "  m1 2 (base 1, limit 1.5)\n",
        )
        self.finished(
            "asap7/b_two_metrics/base",
            "[ERROR] Dashboard QoR check: FAIL (asap7/b_two_metrics/base)\n"
            "QoR regression detected for asap7/b_two_metrics/base:\n"
            "  m1 2 (base 1, limit 1.5)\n"
            "  m2 2 (base 1, limit 1.5)\n",
        )
        self.finished("asap7/c_calibre/base")
        self.write_file(
            "logs/asap7/c_calibre/base/calibre/save-to-drc-db.log",
            "[ERROR DRC-0001] violations\n",
        )
        self.finished("asap7/d_error/base")
        self.write_file("logs/asap7/d_error/base/5_1_grt.log", "[ERROR GRT-0116] x\n")
        self.write_file(
            "logs/asap7/e_killed/base/5_2_route.log",
            "Command terminated by signal 9\n",
        )
        self.finished(
            "asap7/f_inconclusive/base",
            "Dashboard QoR check: INCONCLUSIVE (asap7/f_inconclusive/base)\n"
            "Reason: no baseline\n",
        )

        summary = self.summary()

        codes = [
            line.split()[:2]
            for line in summary.split("-" * 60)[0].splitlines()
            if line.split()[:1] in (["STOP"], ["ERR"], ["DRC"], ["QOR"], ["WARN"])
        ]
        self.assertEqual(
            codes,
            [
                ["STOP", "asap7/e_killed/base"],
                ["ERR", "asap7/d_error/base"],
                ["DRC", "asap7/c_calibre/base"],
                ["QOR", "asap7/b_two_metrics/base"],
                ["QOR", "asap7/a_one_metric/base"],
                ["WARN", "asap7/f_inconclusive/base"],
            ],
        )
        self.assertIn("5_2_route.log: killed by signal 9 (out of memory?)", summary)
        self.assertIn("5_1_grt.log: [ERROR GRT-0116] x", summary)
        self.assertIn(
            "asap7/f_inconclusive/base: QoR check INCONCLUSIVE: no baseline", summary
        )

    def test_missing_metadata_is_grouped_under_needs_attention(self):
        for name in ("a", "b"):
            self.write_file(f"logs/asap7/{name}/base/6_report.log", "Finished\n")
            self.write_file(f"reports/asap7/{name}/base/5_route_drc.rpt", "")
        summary = self.summary()
        self.assertIn(
            "missing metadata-generate.log, metadata-check.log (2 designs):\n"
            "    asap7/a/base, asap7/b/base\n",
            summary,
        )

    def verbosity_fixture(self):
        self.write_file(
            "logs/asap7/stop/base/3_3_place_gp.log",
            "[WARNING GPL-0302] Use a larger density\n"
            "[ERROR GPL-0307] RePlAce divergence\n"
            "[ERROR GPL-0307] RePlAce divergence\n",
        )
        self.finished("asap7/pass/base")
        self.write_file(
            "logs/asap7/pass/base/2_1_floorplan.log", "[WARNING IFP-0028] Core area\n"
        )
        self.finished(
            "asap7/warn/base",
            "Dashboard QoR check: INCONCLUSIVE (asap7/warn/base)\nReason: no baseline\n",
        )

    def test_level_0_shows_error_ids_only(self):
        self.verbosity_fixture()
        summary = self.summary("-s")
        self.assertIn("    3_3_place_gp.log: GPL-0307\n", summary)
        self.assertNotIn("RePlAce divergence", summary)
        self.assertNotIn("asap7/pass/base", summary)

    def test_level_1_shows_each_full_error_once_with_a_count(self):
        self.verbosity_fixture()
        summary = self.summary("-sv")
        self.assertIn(
            "    3_3_place_gp.log: [ERROR GPL-0307] RePlAce divergence (x2)\n", summary
        )
        self.assertNotIn("GPL-0302", summary)

    def test_level_2_adds_passing_designs_and_warning_ids(self):
        self.verbosity_fixture()
        summary = self.summary("-svv")
        self.assertIn("PASS  asap7/pass/base", summary)
        passing = summary.split("PASSING (2)")[1]
        self.assertIn(
            "asap7/pass/base: passed\n    2_1_floorplan.log: IFP-0028", passing
        )
        # The note of a WARN design shows under "Needs attention" only.
        self.assertIn("asap7/warn/base: passed\n", passing)
        self.assertNotIn("no baseline", passing)
        self.assertIn("    3_3_place_gp.log: GPL-0302", summary)

    def test_level_3_shows_full_warnings(self):
        self.verbosity_fixture()
        summary = self.summary("-svvv")
        self.assertIn("2_1_floorplan.log: [WARNING IFP-0028] Core area", summary)

    def test_report_mode_writes_each_design_report(self):
        self.verbosity_fixture()
        # A run that stopped early may have no reports directory yet.
        self.assertFalse(os.path.isdir(os.path.join(self.tmp, "reports/asap7/stop")))
        output = self.run_report("-v")
        self.assertIn("asap7/stop/base: stopped in 3_3_place_gp.log", output)
        self.assertIn(
            "[ERROR GPL-0307] RePlAce divergence (x2)",
            self.read("reports/asap7/stop/base/report.log"),
        )
        self.assertIn(
            "asap7/warn/base: QoR check INCONCLUSIVE: no baseline",
            self.read("reports/asap7/warn/base/report.log"),
        )
        self.assertIn("asap7/stop/base", self.read("reports/report.log"))

    def test_local_qor_check_format(self):
        self.finished(
            "nangate45/gcd/base",
            "[ERROR] nangate45/gcd/base: FAIL \u2014 19 passed, 2 failed, 0 missing "
            "(478 metrics sent)\n"
            "[INFO] baseline build 7 (abc, latest)\n"
            "Metric       Baseline  Current  Limit  Delta%\n"
            "QoR regression detected for nangate45/gcd:\n"
            "  cts__timing__setup__tns -12.2456 (base -6.95522, limit -8.346264)\n"
            "  finish__timing__setup__ws -0.27 (base -0.16, limit -0.17)\n"
            "[WARN] Rules not evaluated for 3 metric(s) absent from the baseline "
            "build. Use --verbose to list them.\n"
            "[ERROR] Failing runs: nangate45/gcd/base\n"
            "QoR check: FAIL\n",
        )
        summary = self.summary()
        self.assertIn("nangate45/gcd/base: 2 metrics over the limit", summary)
        self.assertRegex(summary, r"cts__timing__setup__tns +-12\.2456 +-6\.95522")
        self.assertIn("Note: QoR: Rules not evaluated for 3 metric(s)", summary)
        self.assertNotIn("Failing runs", summary)

    def test_each_design_shows_its_baseline_when_they_differ(self):
        self.qor_fail("asap7/a/base", ["m1"], "https://dashboard.example/builds/1")
        self.qor_fail("asap7/b/base", ["m1"], "https://dashboard.example/builds/2")
        summary = self.summary()
        self.assertNotIn("QoR baseline:", summary)
        self.assertIn("    Baseline: https://dashboard.example/builds/1", summary)
        self.assertIn("    Baseline: https://dashboard.example/builds/2", summary)
        self.assertIn("Most regressed: m1 (2)", summary)

    def test_metric_count_orders_only_qor_rows(self):
        for name in ("a", "b"):
            self.write_file(f"logs/asap7/{name}/base/1_1_yosys.log", "ok\n")
        self.write_file(
            "reports/asap7/b/base/metadata-check.log",
            "QoR regression detected for asap7/b/base:\n  m1 2 (base 1, limit 1.5)\n",
        )
        table = self.summary().split("-" * 60)[0]
        self.assertLess(
            table.index("STOP  asap7/a/base"), table.index("STOP  asap7/b/base")
        )

    def test_metadata_generation_error_text_reaches_the_summary(self):
        self.finished("asap7/a/base")
        self.write_file(
            "reports/asap7/a/base/metadata-generate.log", "[ERROR] bad metric\n"
        )
        summary = self.summary()
        self.assertIn(
            "asap7/a/base: metadata-generate.log: [ERROR] bad metric\n", summary
        )

    def test_log_that_is_not_utf8_is_read(self):
        path = os.path.join(self.tmp, "logs/asap7/a/base/1_1_yosys.log")
        os.makedirs(os.path.dirname(path))
        with open(path, "wb") as f:
            f.write(b"\xff\xfe \xc2\xb5\n[ERROR SYN-0001] bad input\n")
        self.assertIn("1_1_yosys.log: SYN-0001", self.summary())


class TestParseQorCheck(unittest.TestCase):
    def test_ci_format(self):
        metrics, baseline, notes = genReport.parse_qor_check(
            [
                "[ERROR] Dashboard QoR check: FAIL (nangate45/gcd/base)\n",
                "QoR regression detected for nangate45/gcd/base:\n",
                "  cts__timing__setup__tns -12.2456 (base -6.95522, limit -8.346264)\n",
                "  Baseline: https://dashboard.example/builds/7\n",
            ]
        )
        self.assertEqual(
            metrics, [("cts__timing__setup__tns", "-12.2456", "-6.95522", "-8.346264")]
        )
        self.assertEqual(baseline, "https://dashboard.example/builds/7")
        self.assertEqual(notes, [])

    def test_local_check_warnings_become_notes(self):
        _, _, notes = genReport.parse_qor_check(
            [
                "[WARN] nangate45/gcd/base: no baseline to compare against "
                "(strategy=none). Nothing was checked.\n",
                "QoR check: INCONCLUSIVE\n",
            ]
        )
        self.assertEqual(
            notes,
            [
                "QoR: no baseline to compare against (strategy=none). Nothing was checked."
            ],
        )

    def test_reason_is_kept_only_for_a_check_without_a_verdict(self):
        for status in ("PASS", "FAIL"):
            _, _, notes = genReport.parse_qor_check(
                [f"Dashboard QoR check: {status} (a/b/c)\n", "Reason: text\n"]
            )
            self.assertEqual(notes, [], status)
        _, _, notes = genReport.parse_qor_check(
            ["Dashboard QoR check: INCONCLUSIVE (a/b/c)\n", "Reason: no data\n"]
        )
        self.assertEqual(notes, ["QoR check INCONCLUSIVE: no data"])

    def test_unknown_metric_line_is_kept_verbatim(self):
        metrics, _, _ = genReport.parse_qor_check(
            ["QoR regression detected for x/y/z:\n", "  odd line\n"]
        )
        self.assertEqual(metrics, [("odd line",)])


if __name__ == "__main__":
    unittest.main()
