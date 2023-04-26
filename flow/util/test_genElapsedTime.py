#!/usr/bin/env python3

import unittest
from unittest.mock import patch
from unittest.mock import MagicMock
from io import StringIO
import io
import sys
import os
import tempfile
from datetime import datetime
import argparse  # argument parsing
from pathlib import Path

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)) , '..'))

class TestElapsedTime(unittest.TestCase):

    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.log_file = os.path.join(self.tmp_dir.name, "1_test.log")

    @patch("sys.stdout", new_callable=StringIO)
    def test_elapsed_time(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 01:30:00[h:]min:sec.\n")
        # call the script with the test log file
        sys.argv = ["util/genElapsedTime.py", "--logDir", str(self.tmp_dir.name)]
        with patch.object(sys, 'argv', sys.argv):
                import genElapsedTime
        # check if output is correct
        expected_output = "1_test                          5400\n"
        self.assertEqual(mock_stdout.getvalue(), expected_output)

    @patch("sys.stdout", new_callable=StringIO)
    def test_longer_elapsed_time(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 12:24.14[h:]min:sec. CPU time: user 5081.82 sys 170.18 (705%). Peak memory: 9667132KB.\n")
        # call the script with the test log file
        sys.argv = ["util/genElapsedTime.py", "--logDir", str(self.tmp_dir.name)]
        with patch.object(sys, 'argv', sys.argv):
                import genElapsedTime
        # check if output is correct
        expected_output = "1_test                         44654\n"
        self.assertEqual(mock_stdout.getvalue(), expected_output)

    def test_missing_arg(self):
        with self.assertRaises(SystemExit):
            with patch('sys.stderr', new=StringIO()) as fake_err_output:
                with patch('sys.argv', ["util/genElapsedTime.py"]):
                    import genElapsedTime
            self.assertIn('--logDir', fake_err_output.getvalue())


    def test_no_elapsed_time(self):
        with open(self.log_file, "w") as f:
            f.write('Other log message')
        with patch('sys.argv', ["util/genElapsedTime.py", "--logDir", str(self.tmp_dir.name)]):
                with patch('sys.stderr', new=StringIO()) as fake_err_output:
                    import genElapsedTime
                self.assertIn('No elapsed time found in', fake_err_output.getvalue())

    def tearDown(self):
       self.tmp_dir.cleanup()

if __name__ == '__main__':
    unittest.main()
