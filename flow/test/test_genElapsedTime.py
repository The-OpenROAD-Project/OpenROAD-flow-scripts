#!/usr/bin/env python3

import unittest
from unittest.mock import patch
from io import StringIO
import sys
import os
import tempfile

# make sure the working dir is flow/
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__))))

import genElapsedTime


class TestElapsedTime(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.log_file = os.path.join(self.tmp_dir.name, "1_test.log")
        self.module_name = "genElapsedTime"

    @patch("sys.stdout", new_callable=StringIO)
    def test_elapsed_time(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 01:30:00[h:]min:sec. Peak memory: 9667132KB.\n")
        # call the script with the test log file
        genElapsedTime.scan_logs(["--logDir", str(self.tmp_dir.name), "--noHeader"])
        # check if output is correct
        expected_output = (
            self.tmp_dir.name + "\n1_test 5400 9440\nTotal 5400 9440\n"
        ).split()
        actual_output = mock_stdout.getvalue().split()
        self.assertEqual(actual_output, expected_output)

    @patch("sys.stdout", new_callable=StringIO)
    def test_zero_time(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 00:00:74[h:]min:sec. Peak memory: 9667132KB.\n")
        # call the script with the test log file
        genElapsedTime.scan_logs(["--logDir", str(self.tmp_dir.name), "--noHeader"])
        expected_output = (
            self.tmp_dir.name + "\n1_test 74 9440\nTotal 74 9440\n"
        ).split()
        actual_output = mock_stdout.getvalue().split()
        self.assertEqual(actual_output, expected_output)

    @patch("sys.stdout", new_callable=StringIO)
    def test_elapsed_time_longer_duration(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write(
                "Elapsed time: 12:24.14[h:]min:sec. CPU time: user 5081.82 sys 170.18 (705%). Peak memory: 9667132KB.\n"
            )
        # call the script with the test log file
        genElapsedTime.scan_logs(["--logDir", str(self.tmp_dir.name), "--noHeader"])
        # check if output is correct
        expected_output = (
            self.tmp_dir.name + "\n1_test 744 9440 Total 744 9440"
        ).split()
        actual_output = mock_stdout.getvalue().split()
        self.assertEqual(actual_output, expected_output)

    def test_missing_arg(self):
        with self.assertRaises(SystemExit):
            with patch("sys.stderr", new=StringIO()) as fake_err_output:
                genElapsedTime.scan_logs(["util/genElapsedTime.py"])
            self.assertIn("--logDir", fake_err_output.getvalue())

    @patch("sys.stderr", new_callable=StringIO)
    def test_no_elapsed_time(self, fake_err_output):
        with open(self.log_file, "w") as f:
            f.write("Other log message")
        genElapsedTime.scan_logs(["--logDir", str(self.tmp_dir.name), "--noHeader"])
        self.assertIn("No elapsed time found in", fake_err_output.getvalue())

    def tearDown(self):
        self.tmp_dir.cleanup()


if __name__ == "__main__":
    unittest.main()
