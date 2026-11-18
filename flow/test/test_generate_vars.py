#!/usr/bin/env python3
"""`make vars` and `make <step>_issue` write the flow's variables as vars
files that bash, Tcl and gdb source: generate_vars.py.

The tests call write_vars() with ISSUE_VARIABLES as the flow's Makefile
exports it, one NAME=value per line, and read the files it writes in a
temporary directory. Nothing needs to be installed.
"""

import os
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

UTILS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
GENERATE_VARS = os.path.join(UTILS_DIR, "generate_vars.py")

sys.path.insert(0, UTILS_DIR)
import generate_vars  # noqa: E402


class VarsTestCase(unittest.TestCase):
    """A flow directory, <tmp>/orfs/flow, and the vars files written
    from it."""

    def setUp(self):
        tmp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(tmp_dir.cleanup)
        self.tmp = os.path.realpath(tmp_dir.name)
        self.orfs = os.path.join(self.tmp, "orfs")
        self.flow = os.path.join(self.orfs, "flow")
        os.makedirs(self.flow)
        self.basename = os.path.join(self.tmp, "vars")

    def env(self, issue_variables, **extra):
        return dict(extra, FLOW_HOME=self.flow, ISSUE_VARIABLES=issue_variables)

    def generate(self, issue_variables, **extra):
        """Writes the vars files and returns their lines by extension."""
        generate_vars.write_vars(self.basename, self.env(issue_variables, **extra))
        return self.read()

    def read(self):
        lines = {}
        for ext in ["sh", "tcl", "gdb"]:
            with open(f"{self.basename}.{ext}") as f:
                lines[ext] = f.read().splitlines()
        return lines


class TestVarsFiles(VarsTestCase):
    def test_each_variable_in_each_file(self):
        lines = self.generate("PLATFORM=nangate45\n DESIGN_NAME=gcd\n")
        self.assertIn('export PLATFORM="nangate45"', lines["sh"])
        self.assertIn('set env(PLATFORM) "nangate45"', lines["tcl"])
        self.assertIn("set env PLATFORM nangate45", lines["gdb"])
        self.assertIn('export DESIGN_NAME="gcd"', lines["sh"])

    def test_variables_in_make_order(self):
        lines = self.generate("B=1\nA=2\n")
        self.assertLess(
            lines["sh"].index('export B="1"'), lines["sh"].index('export A="2"')
        )

    def test_shell_file_sets_flow_home_first(self):
        self.assertEqual(
            self.generate("")["sh"][0], "export FLOW_HOME=${FLOW_HOME:-$(pwd)}"
        )

    def test_flow_home_and_issue_variables_are_required(self):
        with self.assertRaises(KeyError):
            generate_vars.write_vars(self.basename, {"ISSUE_VARIABLES": ""})
        with self.assertRaises(KeyError):
            generate_vars.write_vars(self.basename, {"FLOW_HOME": self.flow})

    def test_work_home_resolved_from_the_working_directory(self):
        with mock.patch.object(
            generate_vars.os.path, "realpath", side_effect=lambda p: p
        ) as realpath:
            generate_vars.write_vars(self.basename, self.env("A=1", WORK_HOME="w"))
        self.assertIn(mock.call("w"), realpath.call_args_list)
        self.assertIn(mock.call(self.flow), realpath.call_args_list)


class TestCommandLine(VarsTestCase):
    """The flow's Makefile runs it as `generate_vars.py <basename>` with
    the variables in its environment."""

    def run_script(self, *args, **env):
        return subprocess.run(
            [sys.executable, GENERATE_VARS] + list(args),
            env=dict(os.environ, **env),
            cwd=self.flow,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
        )

    def test_writes_the_files_from_the_environment(self):
        result = self.run_script(
            self.basename, FLOW_HOME=self.flow, ISSUE_VARIABLES="A=1\n"
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('export A="1"', self.read()["sh"])

    def test_usage(self):
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("usage", result.stdout)


if __name__ == "__main__":
    unittest.main()
