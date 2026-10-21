#!/usr/bin/env python3
"""klayout.sh without KLayout: streaming out GDS writes an empty file and
warns, so the flow runs to the end for those who don't need or want a GDS
file. Every other KLayout call, DRC and LVS among them, still stops with
an error. With KLayout, the call goes to it unchanged.
"""

import os
import subprocess
import tempfile
import unittest

SCRIPTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "scripts")
KLAYOUT_SH = os.path.join(SCRIPTS_DIR, "klayout.sh")


class TestKlayoutSh(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.out_file = os.path.join(self.tmp_dir.name, "6_1_merged.gds")

    def tearDown(self):
        self.tmp_dir.cleanup()

    def run_klayout(self, klayout_cmd, *args):
        return subprocess.run(
            ["bash", KLAYOUT_SH, *args],
            env=dict(os.environ, KLAYOUT_CMD=klayout_cmd),
            capture_output=True,
            text=True,
        )

    def stream_args(self):
        return [
            "-zz",
            "-rd",
            "design_name=gcd",
            "-rd",
            f"out_file={self.out_file}",
            "-r",
            "/flow/util/def2stream.py",
        ]

    def test_stream_out_writes_an_empty_file_and_warns(self):
        result = self.run_klayout("", *self.stream_args())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn(
            "WARNING: klayout not found, mocking klayout by writing empty file "
            + self.out_file,
            result.stdout,
        )
        self.assertEqual(os.path.getsize(self.out_file), 0)

    def test_drc_still_needs_klayout(self):
        result = self.run_klayout(
            "",
            "-zz",
            "-rd",
            "in_gds=6_final.gds",
            "-rd",
            "report_file=6_drc.lyrdb",
            "-r",
            "/flow/platforms/asap7/drc/asap7.lydrc",
        )
        self.assertEqual(result.returncode, 1)
        self.assertIn("Error: KLayout not found", result.stdout)

    def test_viewer_still_needs_klayout(self):
        result = self.run_klayout("", "-nn", "klayout.lyt", "6_final.odb")
        self.assertEqual(result.returncode, 1)
        self.assertIn("Error: KLayout not found", result.stdout)
        self.assertFalse(os.path.exists(self.out_file))

    def test_installed_klayout_gets_the_call(self):
        result = self.run_klayout("echo", *self.stream_args())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("WARNING", result.stdout)
        self.assertIn(f"out_file={self.out_file}", result.stdout)
        self.assertFalse(os.path.exists(self.out_file))


if __name__ == "__main__":
    unittest.main()
