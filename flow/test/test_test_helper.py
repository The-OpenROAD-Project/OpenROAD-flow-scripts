"""Run the real flow helper against a disposable Makefile."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

HELPER = Path(__file__).with_name("test_helper.sh")


class TestHelper(unittest.TestCase):
    def run_helper(self, target, fail_target=""):
        with tempfile.TemporaryDirectory() as directory:
            flow = Path(directory)
            (flow / "test").mkdir()
            helper = flow / "test/test_helper.sh"
            shutil.copyfile(HELPER, helper)
            (flow / "Makefile").write_text(
                ".PHONY: clean_all clean_metadata finish metadata metadata-generate "
                "metadata-check final_report_issue simulate power\n"
                "metadata: finish metadata-generate metadata-check\n"
                "print-LOG_DIR:\n\t@echo logs/nangate45/gcd/base\n"
                "clean_all clean_metadata finish metadata-generate metadata-check "
                "final_report_issue simulate power:\n"
                "\t@echo $@ >> targets\n"
                f"\t@test '$@' != '{fail_target}'\n"
            )
            env = dict(
                os.environ,
                TARGET=target,
                MAKE_ISSUE="1",
                PRIVATE_DIR=str(flow / "private"),
            )
            result = subprocess.run(
                ["bash", str(helper), "gcd", "nangate45"],
                cwd=flow,
                env=env,
                capture_output=True,
                text=True,
            )
            return result, (flow / "targets").read_text().splitlines()

    def test_metadata_generation_keeps_follow_up_steps(self):
        result, targets = self.run_helper("finish metadata-generate")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            targets,
            [
                "clean_all",
                "clean_metadata",
                "finish",
                "metadata-generate",
                "final_report_issue",
                "simulate",
                "power",
            ],
        )

    def test_default_target_still_checks_qor(self):
        result, targets = self.run_helper("finish metadata")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("metadata-check", targets)
        self.assertEqual(targets[-3:], ["final_report_issue", "simulate", "power"])

    def test_custom_target_still_stops_after_that_target(self):
        result, targets = self.run_helper("finish")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(targets, ["clean_all", "clean_metadata", "finish"])

    def test_failed_generation_is_not_a_pass(self):
        result, targets = self.run_helper(
            "finish metadata-generate", "metadata-generate"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("simulate", targets)
        self.assertNotIn("power", targets)


if __name__ == "__main__":
    unittest.main()
