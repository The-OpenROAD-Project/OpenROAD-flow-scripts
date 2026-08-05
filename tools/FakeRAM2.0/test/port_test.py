#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from port import Port


class PortTest(unittest.TestCase):
    """Unit test for Port class"""

    def setUp(self):
        """Sets up base_data with example config data"""
        pass

    def test_port_defaults(self):
        """Tests port defaults"""

        name = "dummy"
        port = Port(name)
        self.assertEqual(port.get_name(), name)
        self.assertEqual(port.get_direction(), Port.Direction.INPUT)
        self.assertEqual(port.get_use(), "SIGNAL")
        self.assertIsNone(port.get_layer())
        self.assertEqual(len(port.get_rects()), 0)

    def test_port_dir(self):
        """Test the Direction enum"""

        for dir in Port.Direction:
            self.assertEqual(dir.get_liberty_name(), dir.name.lower())
            self.assertEqual(dir.get_verilog_name(), dir.name.lower())
            self.assertEqual(dir.get_lef_name(), dir.name.upper())

    def test_port_set_get(self):
        """Tests basic port set/get methods"""
        name = "dummy"
        use = "POWER"
        layer_name = "M1"
        rect = [1, 2, 3, 4]
        port = Port(name)
        port.set_use(use)
        self.assertEqual(port.get_use(), use)
        port.set_layer(layer_name)
        self.assertEqual(port.get_layer(), layer_name)
        port.add_rect(rect)
        self.assertEqual(len(port.get_rects()), 1)
        self.assertEqual(port.get_rects()[0], rect)
        port.add_rect(rect)
        self.assertEqual(len(port.get_rects()), 2)
        for port_rect in port.get_rects():
            self.assertEqual(port_rect, rect)


if __name__ == "__main__":
    unittest.main()
