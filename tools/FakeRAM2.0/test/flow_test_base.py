#!/usr/bin/env python3

import os
import shutil
import unittest
import subprocess
from test_utils import TestUtils


class FlowTestBase(unittest.TestCase):
    """Flow test base class"""

    def set_up(self, tag):
        result_dir = f"{tag}_results"
        self._test_dir = os.path.abspath(os.path.dirname(__file__))
        self._script_dir = os.path.abspath(os.path.join(self._test_dir, ".."))
        self._golden_dir = os.path.abspath(os.path.join(self._test_dir, "au"))
        self._exec = os.path.join(self._script_dir, "run.py")
        self._results_dir = os.path.join(self._test_dir, result_dir)
        if os.path.isdir(self._results_dir):
            shutil.rmtree(self._results_dir)

    def _compare_golden(
        self, ram_name, lef_file, verilog_file, sv_blackbox_file, liberty_file
    ):
        temp_file = os.path.join(self._results_dir, ram_name + ".out")
        golden_file = os.path.join(self._golden_dir, ram_name + ".au")
        cmd = f"cat {lef_file} {verilog_file} {sv_blackbox_file} {liberty_file} | grep -v date > {temp_file}"
        out = subprocess.run(cmd, check=True, shell=True)
        self.assertEqual(out.returncode, 0)
        cmd = f"cmp {temp_file} {golden_file}"
        out = subprocess.run(cmd, check=True, shell=True)
        self.assertEqual(out.returncode, 0)

    def _check_memory(self, ram_name):
        lef_file = os.path.join(self._results_dir, ram_name, ram_name + ".lef")
        verilog_file = os.path.join(self._results_dir, ram_name, ram_name + ".v")
        sv_blackbox_file = os.path.join(self._results_dir, ram_name, ram_name + ".sv")
        liberty_file = os.path.join(self._results_dir, ram_name, ram_name + ".lib")
        self.assertTrue(os.path.exists(lef_file), f"{lef_file} doesn't exist")
        self.assertTrue(os.path.exists(verilog_file), f"{verilog_file} doesn't exist")
        self.assertTrue(
            os.path.exists(sv_blackbox_file), f"{sv_blackbox_file} doesn't exist"
        )
        self.assertTrue(os.path.exists(liberty_file), f"{liberty_file} doesn't exist")
        self._compare_golden(
            ram_name, lef_file, verilog_file, sv_blackbox_file, liberty_file
        )

    def _check_results_dir(self, expected_ram_list):
        """Checks that the expected RAMs were generated"""
        self.assertTrue(os.path.isdir(self._results_dir))
        self.assertListEqual(sorted(os.listdir(self._results_dir)), expected_ram_list)
        for ram_name in expected_ram_list:
            self._check_memory(ram_name)

    def _execute_run(self, tag, expected_ram_list):
        cfg_file_name = f"{tag}_example.cfg"

        exec_cmd = TestUtils.get_exec_name(self._exec)
        cmd = (
            exec_cmd
            + " "
            + os.path.join(self._test_dir, "cfg", cfg_file_name)
            + " --output_dir "
            + self._results_dir
        )
        out = subprocess.run(cmd, check=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self._check_results_dir(expected_ram_list)
