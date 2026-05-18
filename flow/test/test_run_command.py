#!/usr/bin/env python3

import os
import re
import subprocess
import sys
import tempfile
import threading
import time
import unittest

sys.path.append(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "scripts")
)

import run_command

TIMING_RE = re.compile(
    r"^Elapsed time: (\S+)\[h:\]min:sec\. "
    r"CPU time: user (\S+) sys (\S+) \((\d+)%\)\. "
    r"Peak memory: (\d+)KB\.$",
    re.MULTILINE,
)


class TestRunCommand(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.log_path = os.path.join(self.tmp_dir.name, "test.log")

    def tearDown(self):
        self.tmp_dir.cleanup()

    def test_basic_timing(self):
        rc = run_command.run(["--log", self.log_path, "--", "sleep", "0.1"])
        self.assertEqual(rc, 0)
        with open(self.log_path) as f:
            content = f.read()
        m = TIMING_RE.search(content)
        self.assertIsNotNone(m, f"Timing line not found in: {content!r}")

    def test_output_format(self):
        run_command.run(["--log", self.log_path, "--", "echo", "hello world"])
        with open(self.log_path) as f:
            content = f.read()
        self.assertIn("hello world", content)
        m = TIMING_RE.search(content)
        self.assertIsNotNone(m, f"Timing line not found in: {content!r}")
        # Verify time fields are parseable floats
        float(m.group(2))  # user
        float(m.group(3))  # sys

    def test_log_file_created(self):
        self.assertFalse(os.path.exists(self.log_path))
        run_command.run(["--log", self.log_path, "--", "echo", "test"])
        self.assertTrue(os.path.exists(self.log_path))

    def test_append_mode(self):
        with open(self.log_path, "w") as f:
            f.write("pre-existing content\n")
        run_command.run(["--log", self.log_path, "--append", "--", "echo", "appended"])
        with open(self.log_path) as f:
            content = f.read()
        self.assertIn("pre-existing content", content)
        self.assertIn("appended", content)

    def test_overwrite_mode(self):
        with open(self.log_path, "w") as f:
            f.write("old content\n")
        run_command.run(["--log", self.log_path, "--", "echo", "new"])
        with open(self.log_path) as f:
            content = f.read()
        self.assertNotIn("old content", content)
        self.assertIn("new", content)

    def test_tee_output(self):
        """Verify --tee sends output to stdout as well as the log file."""
        result = subprocess.run(
            [
                sys.executable,
                os.path.join(
                    os.path.dirname(os.path.abspath(__file__)),
                    "..",
                    "scripts",
                    "run_command.py",
                ),
                "--log",
                self.log_path,
                "--tee",
                "--",
                "echo",
                "visible",
            ],
            capture_output=True,
            text=True,
        )
        self.assertIn("visible", result.stdout)
        with open(self.log_path) as f:
            self.assertIn("visible", f.read())

    def test_exit_code_propagation(self):
        rc = run_command.run(["--log", self.log_path, "--", "false"])
        self.assertNotEqual(rc, 0)

    def test_exit_code_success(self):
        rc = run_command.run(["--log", self.log_path, "--", "true"])
        self.assertEqual(rc, 0)

    def test_peak_memory(self):
        """Peak memory should be reported and > 0 for a real command."""
        run_command.run(
            ["--log", self.log_path, "--", sys.executable, "-c", "x = 'a' * 1000000"]
        )
        with open(self.log_path) as f:
            content = f.read()
        m = TIMING_RE.search(content)
        self.assertIsNotNone(m)
        peak_kb = int(m.group(5))
        self.assertGreater(peak_kb, 0)

    def test_cpu_time(self):
        """CPU time fields should be present and parseable."""
        run_command.run(
            [
                "--log",
                self.log_path,
                "--",
                sys.executable,
                "-c",
                "sum(range(100000))",
            ]
        )
        with open(self.log_path) as f:
            content = f.read()
        m = TIMING_RE.search(content)
        self.assertIsNotNone(m)
        user = float(m.group(2))
        sys_ = float(m.group(3))
        self.assertGreaterEqual(user, 0)
        self.assertGreaterEqual(sys_, 0)

    def test_stderr_captured(self):
        """Stderr from the subprocess should appear in the log."""
        run_command.run(
            [
                "--log",
                self.log_path,
                "--",
                sys.executable,
                "-c",
                "import sys; sys.stderr.write('err_msg\\n')",
            ]
        )
        with open(self.log_path) as f:
            content = f.read()
        self.assertIn("err_msg", content)

    def test_cross_platform_memory_units(self):
        """Verify _maxrss_kb normalizes correctly for current platform."""
        if sys.platform == "darwin":
            # macOS: bytes -> KB
            self.assertEqual(run_command._maxrss_kb(1024000), 1000)
        else:
            # Linux: already KB
            self.assertEqual(run_command._maxrss_kb(1000), 1000)

    def test_streaming_flush(self):
        """Verify log file is written incrementally, not buffered until exit.

        This validates the tail -f use case: users must see output in the
        log file while the subprocess is still running.
        """
        script = (
            "import sys, time; "
            "print('line1', flush=True); "
            "time.sleep(0.5); "
            "print('line2', flush=True); "
            "time.sleep(1)"
        )
        proc = subprocess.Popen(
            [
                sys.executable,
                os.path.join(
                    os.path.dirname(os.path.abspath(__file__)),
                    "..",
                    "scripts",
                    "run_command.py",
                ),
                "--log",
                self.log_path,
                "--",
                sys.executable,
                "-c",
                script,
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        # Wait a bit for first line to be flushed
        time.sleep(0.3)
        with open(self.log_path) as f:
            content = f.read()
        self.assertIn(
            "line1", content, "line1 should appear before subprocess finishes"
        )
        proc.wait()

    def test_log_path_in_cmdline(self):
        """Verify the log path is visible in ps output (for discoverability).

        Users find logs via `ps -Af | grep run_command` or `ps -Af | grep tmp.log`.
        The log path must appear in /proc/<pid>/cmdline (ps -Af may truncate).
        """
        script = "import time; time.sleep(2)"
        proc = subprocess.Popen(
            [
                sys.executable,
                os.path.join(
                    os.path.dirname(os.path.abspath(__file__)),
                    "..",
                    "scripts",
                    "run_command.py",
                ),
                "--log",
                self.log_path,
                "--",
                sys.executable,
                "-c",
                script,
            ],
        )
        time.sleep(0.3)
        try:
            # Read full cmdline from /proc (not truncated like ps -Af)
            cmdline_path = f"/proc/{proc.pid}/cmdline"
            if os.path.exists(cmdline_path):
                with open(cmdline_path) as f:
                    cmdline = f.read()
                self.assertIn(
                    self.log_path,
                    cmdline,
                    "Log path should be visible in /proc/<pid>/cmdline",
                )
            else:
                # Fallback for non-Linux: use ps with wide output
                ps = subprocess.run(
                    ["ps", "-ww", "-p", str(proc.pid), "-o", "args="],
                    capture_output=True,
                    text=True,
                )
                self.assertIn(self.log_path, ps.stdout)
        finally:
            proc.kill()
            proc.wait()

    def test_no_command_error(self):
        with self.assertRaises(SystemExit):
            run_command.run(["--log", self.log_path])

    def test_format_elapsed_minutes_seconds(self):
        self.assertEqual(run_command._format_elapsed(65.5), "1:05.50")

    def test_format_elapsed_hours(self):
        self.assertEqual(run_command._format_elapsed(3661.0), "1:01:01.00")

    def test_format_elapsed_subsecond(self):
        self.assertEqual(run_command._format_elapsed(0.5), "0:00.50")

    def test_genElapsedTime_parses_output(self):
        """Verify genElapsedTime.py can parse the timing line produced by run_command."""
        sys.path.insert(
            0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
        )
        import genElapsedTime
        from io import StringIO
        from unittest.mock import patch

        log_dir = self.tmp_dir.name
        log_file = os.path.join(log_dir, "1_test.log")
        # Run a real command to generate a timing line
        run_command.run(["--log", log_file, "--", "echo", "hello"])
        with patch("sys.stdout", new_callable=StringIO) as mock_out:
            genElapsedTime.scan_logs(["--logDir", log_dir, "--noHeader"])
        output = mock_out.getvalue()
        self.assertIn("1_test", output)


if __name__ == "__main__":
    unittest.main()
