#!/usr/bin/env python3

import os
import shutil
import unittest
import subprocess

from flow_test_base import FlowTestBase


class DPRFFlowTest(FlowTestBase):
    """Flow test for dual port reg file"""

    def setUp(self):
        """Sets up paths to validate results"""
        self._tag = "dprf"
        FlowTestBase.set_up(self, self._tag)

    def test_example_input(self):
        """Tests the example input run"""

        expected_ram_list = [
            "dprf_256x256",
            "dprf_256x32",
            "dprf_256x32_h",
        ]
        self._execute_run(self._tag, expected_ram_list)


if __name__ == "__main__":
    unittest.main()
