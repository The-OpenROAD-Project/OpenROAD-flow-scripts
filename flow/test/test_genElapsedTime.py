#!/usr/bin/env python3

import unittest
from unittest.mock import patch
from unittest.mock import MagicMock
from io import StringIO
import sys
import os
import tempfile
import importlib  # module reloading

# make sure the working dir is flow/
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'util'))
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__))))

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
            f.write("Elapsed time: 01:30:00[h:]min:sec.\n")
        # call the script with the test log file
        sys.argv = ["./genElapsedTime.py", "--logDir", str(self.tmp_dir.name),
                    "--noHeader"]
        with patch.object(sys, 'argv', sys.argv):
            module = importlib.import_module(self.module_name)
        # check if output is correct
        expected_output = self.tmp_dir.name + "\n1_test                          5400\nTotal                           5400\n"
        self.assertEqual(mock_stdout.getvalue(), expected_output)

    @patch("sys.stdout", new_callable=StringIO)
    def test_zero_time(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 00:00:74[h:]min:sec.\n")
        # call the script with the test log file
        sys.argv = ["./genElapsedTime.py", "--logDir", str(self.tmp_dir.name),
                    "--noHeader"]
        with patch.object(sys, 'argv', sys.argv):
            module = importlib.import_module(self.module_name)
        # check if output is correct
        self.assertEqual(mock_stdout.getvalue(), "")

    @patch("sys.stdout", new_callable=StringIO)
    def test_elapsed_time_longer_duration(self, mock_stdout):
        # create a log file with elapsed time
        with open(self.log_file, "w") as f:
            f.write("Some log entry\n")
            f.write("Elapsed time: 12:24.14[h:]min:sec. CPU time: user 5081.82 sys 170.18 (705%). Peak memory: 9667132KB.\n")
        # call the script with the test log file
        sys.argv = ["util/genElapsedTime.py", "--logDir", str(self.tmp_dir.name),
                    "--noHeader"]
        with patch.object(sys, 'argv', sys.argv):
            module = importlib.import_module(self.module_name)
            importlib.reload(module)
        # check if output is correct
        expected_output = self.tmp_dir.name + "\n1_test                           744\nTotal                            744\n"
        self.assertEqual(mock_stdout.getvalue(), expected_output)

    def test_missing_arg(self):
        with self.assertRaises(SystemExit):
            with patch('sys.stderr', new=StringIO()) as fake_err_output:
                with patch('sys.argv', ["util/genElapsedTime.py"]):
                    module = importlib.import_module(self.module_name)
                    importlib.reload(module)
            self.assertIn('--logDir', fake_err_output.getvalue())

    def test_no_elapsed_time(self):
        with open(self.log_file, "w") as f:
            f.write('Other log message')
        with patch('sys.argv', ["util/genElapsedTime.py",
                                "--logDir", str(self.tmp_dir.name),
                                "--noHeader"]):
            with patch('sys.stderr', new=StringIO()) as fake_err_output:
                module = importlib.import_module(self.module_name)
                importlib.reload(module)
            self.assertIn('No elapsed time found in', fake_err_output.getvalue())

    def tearDown(self):
       self.tmp_dir.cleanup()

if __name__ == '__main__':
    unittest.main()
