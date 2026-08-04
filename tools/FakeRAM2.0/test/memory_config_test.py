#!/usr/bin/env python3

#!/usr/bin/env python3

import os
import sys
import math
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from memory_config import MemoryConfig


class MemoryConfigTest(unittest.TestCase):
    """Unit test for MemoryConfig class"""

    def setUp(self):
        """Sets up base_data with example config data"""
        pass

    def test_basic(self):
        """Tests memory config field defaults"""

        name = "xyz"
        width = 32
        depth = 128
        num_banks = 1
        additional_height = 10
        mem_config = MemoryConfig(name, width, depth, num_banks, additional_height)
        self.assertEqual(mem_config.get_name(), name)
        self.assertEqual(mem_config.get_width_in_bits(), width)
        self.assertEqual(mem_config.get_depth(), depth)
        self.assertEqual(mem_config.get_num_banks(), num_banks)
        self.assertEqual(mem_config.get_additional_height(), additional_height)

    def test_from_json(self):
        """Tests memoryconfig field from json with additional_height"""
        json_data = {
            "name": "abc",
            "width": 25,
            "depth": 99,
            "banks": 2,
            "additional_height": 33,
        }
        mem_config = MemoryConfig.from_json(json_data)
        self.assertEqual(mem_config.get_name(), json_data["name"])
        self.assertEqual(mem_config.get_width_in_bits(), json_data["width"])
        self.assertEqual(mem_config.get_depth(), json_data["depth"])
        self.assertEqual(mem_config.get_num_banks(), json_data["banks"])
        self.assertEqual(
            mem_config.get_additional_height(), json_data["additional_height"]
        )

    def test_from_json_no_height(self):
        """Tests memoryconfig field from json without additional_height"""
        json_data = {
            "name": "abc",
            "width": 24,
            "depth": 89,
            "banks": 4,
        }
        mem_config = MemoryConfig.from_json(json_data)
        self.assertEqual(mem_config.get_name(), json_data["name"])
        self.assertEqual(mem_config.get_width_in_bits(), json_data["width"])
        self.assertEqual(mem_config.get_depth(), json_data["depth"])
        self.assertEqual(mem_config.get_num_banks(), json_data["banks"])
        self.assertEqual(mem_config.get_additional_height(), 0)


if __name__ == "__main__":
    unittest.main()
