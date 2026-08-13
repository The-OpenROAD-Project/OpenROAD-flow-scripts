#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from class_process import Process
from memory_factory import MemoryFactory
from memory_config import MemoryConfig
from timing_data import TimingData
from test_utils import TestUtils


class MemoryFactoryTest(unittest.TestCase):
    """Unit test for MemoryFactory object"""

    def setUp(self):
        """Sets up process object used by test methods"""

        self._process = Process(TestUtils.get_base_process_data())
        self._timing_data = TimingData()

    def test_basic(self):
        """
        Tests basic operations
        """

        timing_data = TimingData()
        for memory_type in ["RAM", "RF"]:
            for port_config in ["SP", "DP"]:
                name = (f"{port_config}{memory_type}",)
                mem_config = MemoryConfig(name, 32, 256, 1, 0)
                memory = MemoryFactory.create(
                    mem_config,
                    memory_type,
                    port_config,
                    self._process,
                    timing_data,
                )
                self.assertIsNotNone(memory)
                self.assertEqual(memory.get_name(), name)
        with self.assertRaises(Exception):
            bogus_config = MemoryConfig("bogus", 32, 256, 1, 0)
            memory = MemoryFactory.create(
                bogus_config, "unknown", "unknown", self._process, timing_data
            )


if __name__ == "__main__":
    unittest.main()
