#!/usr/bin/env python3

import os
import shutil
import unittest
import subprocess
from test_utils import TestUtils
from flow_test_base import FlowTestBase


class SSFlowTestBase(FlowTestBase):
    """Spreadsheet input flow test base class"""

    def set_up(self, tag):
        result_dir = f"{tag}_results"
        self._test_dir = os.path.abspath(os.path.dirname(__file__))
        self._script_dir = os.path.abspath(os.path.join(self._test_dir, ".."))
        self._golden_dir = os.path.abspath(os.path.join(self._test_dir, "au"))
        self._exec = os.path.join(self._script_dir, "spreadsheet_ram.py")
        self._results_dir = os.path.join(self._test_dir, result_dir)
        if os.path.isdir(self._results_dir):
            shutil.rmtree(self._results_dir)

    def _execute_run(
        self, tag, physical_csv, metrics_csv, mapping_file, expected_ram_list
    ):
        cfg_file_name = f"{tag}_example.cfg"

        exec_cmd = TestUtils.get_exec_name(self._exec)
        cmd = (
            exec_cmd
            + " --config "
            + os.path.join(self._test_dir, "cfg", cfg_file_name)
            + " --physical "
            + os.path.join(self._test_dir, "cfg", physical_csv)
            + " --mem_config "
            + os.path.join(self._test_dir, "cfg", metrics_csv)
            + " --mapping "
            + os.path.join(self._test_dir, "cfg", mapping_file)
            + " --output_dir "
            + self._results_dir
        )
        out = subprocess.run(cmd, check=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self._check_results_dir(expected_ram_list)
