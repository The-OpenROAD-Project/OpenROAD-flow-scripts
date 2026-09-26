#!/usr/bin/env python3

import os
import sys
import math
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from physical_data import PhysicalData


class PhysicalDataTest(unittest.TestCase):
    """Unit test for PhysicalData class"""

    def setUp(self):
        """Sets up base_data with example config data"""
        self._threshold = 0.001

    def test_empty_physical(self):
        """Tests physical field defaults"""

        physical = PhysicalData()
        self.assertIsNone(physical.get_width())
        self.assertIsNone(physical.get_height())
        self.assertIsNone(physical.get_width(True))
        self.assertIsNone(physical.get_height(True))
        self.assertIsNone(physical.get_pin_pitch())
        self.assertIsNone(physical.get_group_pitch())

    def test_set_extents_and_snapping(self):
        """Tests physical field extents and snapping results"""

        physical = PhysicalData()
        width = 123.4
        height = 456.5
        snapped_width = math.ceil(width)
        snapped_height = math.ceil(height)

        # Can't snap before setting extents
        with self.assertRaises(Exception):
            physical.snap_to_grid(1000, 1000)

        # Set extents and verify values
        physical.set_extents(width, height)
        self.assertEqual(physical.get_width(False), width)
        self.assertEqual(physical.get_height(False), height)
        self.assertEqual(physical.get_area(False), width * height)
        # Not snapped yet, so should return non-snapped value
        self.assertEqual(physical.get_width(True), width)
        self.assertEqual(physical.get_height(True), height)
        self.assertEqual(physical.get_area(True), width * height)

        # Snap to 1um
        physical.snap_to_grid(1000, 1000)

        # Non-snapped should return original
        self.assertEqual(physical.get_width(False), width)
        self.assertEqual(physical.get_height(False), height)
        self.assertEqual(physical.get_area(False), width * height)
        self.assertEqual(physical.get_width(True), snapped_width)
        self.assertEqual(physical.get_height(True), snapped_height)
        self.assertEqual(physical.get_area(True), snapped_width * snapped_height)

    def test_pin_pitches_exact(self):
        """Tests get_pin_pitches the height exactly fits the available tracks"""

        num_pins = 521
        min_pin_pitch = 0.046
        y_offset = min_pin_pitch
        # number of pins + offset at the top and bottom
        height = round(min_pin_pitch * (num_pins + 2), 2)
        print(height)
        physical = PhysicalData()

        physical.set_extents(height, height)
        physical.snap_to_grid(1, 1)
        physical.set_pin_pitches("bogus", num_pins, min_pin_pitch, y_offset)
        # just enough space, so pin pitch is the minimum pitch and there's no
        # group pitch
        self.assertAlmostEqual(
            physical.get_pin_pitch(), min_pin_pitch, delta=self._threshold
        )
        self.assertAlmostEqual(physical.get_group_pitch(), 0, delta=self._threshold)

    def test_pin_pitches_exception(self):
        """Tests get_pin_pitches when there's no enough room for the pins"""

        num_pins = 523
        min_pin_pitch = 0.048
        y_offset = 0.048
        height = 21.0
        height_that_fits = height + 5
        physical = PhysicalData()

        # Can't set pin pitches before setting height
        with self.assertRaises(Exception):
            physical.set_pin_pitches("bogus", num_pins, min_pin_pitch, y_offset)

        # Try again after setting height
        physical.set_extents(height, height)
        physical.snap_to_grid(1, 1)
        # Not enough height to fit the pins 523 * 0.048 == 25.104
        with self.assertRaises(Exception):
            physical.set_pin_pitches("bogus", num_pins, min_pin_pitch, y_offset)

        # update height to something that fits
        physical.set_extents(height, height_that_fits)
        physical.snap_to_grid(1, 1)
        physical.set_pin_pitches("bogus", num_pins, min_pin_pitch, y_offset)
        # just enough space, so pin pitch is the minimum pitch
        self.assertAlmostEqual(
            physical.get_pin_pitch(), min_pin_pitch, delta=self._threshold
        )
        self.assertAlmostEqual(physical.get_group_pitch(), 0.24, delta=self._threshold)


if __name__ == "__main__":
    unittest.main()
