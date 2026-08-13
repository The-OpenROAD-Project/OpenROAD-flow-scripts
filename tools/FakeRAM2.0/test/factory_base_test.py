#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from factory_base import FactoryBase
from memory_config import MemoryConfig


class DPRAM:
    """Test class for DPRAM"""

    def __init__(self, mem_config, process, timing_data):
        pass

    def get_type(self):
        return "DPRAM"


class SPRAM:
    """Test class for SPRAM"""

    def __init__(self, mem_config, process, timing_data):
        pass

    def get_type(self):
        return "SPRAM"


class FactoryBaseTest(unittest.TestCase):
    """Unit test for FactoryBase class"""

    def setUp(self):
        """Sets up factory by registering two types of SRAMs"""
        FactoryBase.register("RAM", "DP", DPRAM)
        FactoryBase.register("RAM", "SP", SPRAM)

    def test_basic(self):
        """Tests calling factory with existent and non existent keys"""
        width = 32
        depth = 256
        banks = 2
        mem_config = MemoryConfig("dpram", width, depth, banks, 0)
        dpram = FactoryBase.create(mem_config, "RAM", "DP", None, None)
        self.assertIsNotNone(dpram)
        self.assertEqual(dpram.get_type(), "DPRAM")
        mem_config.set_name("spram")
        spram = FactoryBase.create(mem_config, "RAM", "SP", None, None)
        self.assertIsNotNone(spram)
        self.assertEqual(spram.get_type(), "SPRAM")
        # SP RF is not registered, so raise exception
        with self.assertRaises(Exception):
            mem_config.set_name("sprf")
            sprf = FactoryBase.create(mem_config, "RF", "SP", None, None)


if __name__ == "__main__":
    unittest.main()
