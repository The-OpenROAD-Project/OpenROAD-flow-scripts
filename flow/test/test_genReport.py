#!/usr/bin/env python3

import importlib.util
import os
import sys
import tempfile
import unittest
from unittest.mock import patch

GEN_REPORT_PATH = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "util", "genReport.py"
)
with patch("sys.argv", [GEN_REPORT_PATH]), patch("os.chdir"):
    SPEC = importlib.util.spec_from_file_location("genReport", GEN_REPORT_PATH)
    genReport = importlib.util.module_from_spec(SPEC)
    SPEC.loader.exec_module(genReport)


class TestGenReport(unittest.TestCase):
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
