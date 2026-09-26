#!/usr/bin/env python3

import os
import shutil
import unittest
import subprocess

from flow_test_base import FlowTestBase


class SPRFFlowTest(FlowTestBase):
    """Flow test for single port reg file"""

    def setUp(self):
        """Sets up paths to validate results"""
        self._tag = "sprf"
        FlowTestBase.set_up(self, self._tag)

    def test_example_input(self):
        """Tests the example input run"""

        expected_ram_list = [
            "sprf_256x256",
            "sprf_256x32",
            "sprf_256x32_h",
        ]
        self._execute_run(self._tag, expected_ram_list)


if __name__ == "__main__":
    unittest.main()
