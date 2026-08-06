#!/usr/bin/env python3

import os
import shutil
import unittest
import subprocess
from test_utils import TestUtils
from ss_flow_test_base import SSFlowTestBase


class SSSPSRAMFlowTest(SSFlowTestBase):
    """Flow test for spreadsheet input single port RAM"""

    def setUp(self):
        """Sets up paths to validate results"""
        self._tag = "spsram"
        SSFlowTestBase.set_up(self, self._tag)

    def test_example_input(self):
        """Tests the example input run"""

        test_config = {
            "sssram_64x256": {
                "physical_csv": "sssram_64x256_physical.csv",
                "metrics_csv": "ss_metrics.csv",
                "mapping_file": "csv_map.py",
            },
        }
        for test_name, file_config in test_config.items():
            self._execute_run(
                self._tag,
                file_config["physical_csv"],
                file_config["metrics_csv"],
                file_config["mapping_file"],
                [test_name],
            )


if __name__ == "__main__":
    unittest.main()
