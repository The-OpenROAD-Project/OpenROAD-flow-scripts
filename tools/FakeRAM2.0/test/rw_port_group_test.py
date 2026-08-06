#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from rw_port_group import RWPortGroup


class RWPortGroupTest(unittest.TestCase):
    """Unit test for RWPortGroup class"""

    def setUp(self):
        """Sets up base_data with example config data"""
        pass

    def test_defaults(self):
        """Tests the defaults"""

        obj = RWPortGroup()
        self.assertIsNone(obj.get_clock_name())
        self.assertIsNone(obj.get_write_enable_name())
        self.assertIsNone(obj.get_address_bus_name())
        self.assertIsNone(obj.get_data_input_bus_name())
        self.assertIsNone(obj.get_data_output_bus_name())
        self.assertIsNone(obj.get_suffix())

    def test_suffix(self):
        """Tests the defaults"""

        suffix = "abc"
        obj = RWPortGroup(suffix)
        self.assertEqual(obj.get_suffix(), suffix)
        self.assertEqual(obj.get_clock_name(), f"clk_{suffix}")
        self.assertEqual(obj.get_write_enable_name(), f"we_{suffix}")
        self.assertEqual(obj.get_address_bus_name(), f"addr_{suffix}")
        self.assertEqual(obj.get_data_input_bus_name(), f"din_{suffix}")
        self.assertEqual(obj.get_data_output_bus_name(), f"dout_{suffix}")

    def test_setget(self):
        """Tests the non-suffix setting path"""

        clock_name = "gigahertzclock"
        we_name = "writemenow"
        addr_name = "elmst"
        din_name = "goingin"
        dout_name = "goingout"
        obj = RWPortGroup()
        obj.set_clock_name(clock_name)
        self.assertEqual(obj.get_clock_name(), clock_name)
        obj.set_write_enable_name(we_name)
        self.assertEqual(obj.get_write_enable_name(), we_name)
        obj.set_address_bus_name(addr_name)
        self.assertEqual(obj.get_address_bus_name(), addr_name)
        obj.set_data_input_bus_name(din_name)
        self.assertEqual(obj.get_data_input_bus_name(), din_name)
        obj.set_data_output_bus_name(dout_name)
        self.assertEqual(obj.get_data_output_bus_name(), dout_name)


if __name__ == "__main__":
    unittest.main()
