#!/usr/bin/env python3

import io
import os
import re
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from port import Port
from basic_port_creator import BasicPortCreator
from class_process import Process
from timing_data import TimingData
from memory_config import MemoryConfig
from memory_factory import MemoryFactory
from test_utils import TestUtils


class BasicPortCreatorTest(unittest.TestCase):
    """Tests specific cases for the basic port creator"""

    def setUp(self):
        """Define a bunch of variables used later in the tests"""

        self._process = Process(TestUtils.get_base_process_data())
        self._timing_data = TimingData()
        self._rect_re = re.compile(r"^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+\;")
        self._start_y = 0.48
        self._start_pitch = 0.0
        self._threshold = 0.001
        self._mem_width = 100
        self._mem_height = 200
        self._x_offset = 0.25
        self._y_offset = 10
        self._y_step = 99
        self._supply_pin_width = self._process.get_pin_width_um() * 4
        self._supply_pin_half_width = self._supply_pin_width / 2
        self._supply_pin_pitch = self._process.get_pin_width_um() * 8

    def _check_pin(self, rect, exp_width, exp_height, start_x, start_y):
        """
        Checks that the signal pin meets width, height and start location
        expectations
        """

        pin_width = rect[2] - rect[0]
        pin_height = rect[3] - rect[1]
        self.assertAlmostEqual(pin_width, exp_width, delta=self._threshold)
        self.assertAlmostEqual(pin_height, exp_height, delta=self._threshold)
        self.assertAlmostEqual(rect[0], start_x, delta=self._threshold)
        self.assertAlmostEqual(rect[1], start_y, delta=self._threshold)

    def _check_pg_pin(self, rect_list, exp_width, exp_height):
        """Checks that the pg pins meet width and height expectations"""

        for rect in rect_list:
            pin_width = rect[2] - rect[0]
            pin_height = rect[3] - rect[1]
            self.assertAlmostEqual(pin_width, exp_width, delta=self._threshold)
            self.assertAlmostEqual(pin_height, exp_height, delta=self._threshold)

    def test_normal_pin_mode(self):
        """
        Tests normal pin mode

        signal pins should be square (pin_width x pin_width as defined in the
        process object.

        pg pins should be the width of the memory (minus two x_offsets) x
        8 * pin_widths high
        """

        mem_config = MemoryConfig("test", 32, 256, 1, 0)
        mem = MemoryFactory.create(
            mem_config, "RAM", "SP", self._process, self._timing_data
        )
        exporter = BasicPortCreator(mem)
        self.assertEqual(exporter._rect_pin_mode, False)

        # Test the pin first. Should be pin_width x pin_width
        pitch = exporter.add_pin(
            "A", Port.Direction.INPUT, self._start_y, self._start_pitch
        )
        self.assertEqual(pitch, self._start_pitch + self._start_y)
        rect_list = mem.get_port("A").get_rects()
        self.assertEqual(len(rect_list), 1)
        exp_width = self._process.get_pin_width_um()
        self._check_pin(
            rect_list[0], exp_width, exp_width, 0.0, self._start_y - (exp_width / 2.0)
        )

        # Test the pg pin
        exporter.create_pg_pin(
            "VSS",
            "GROUND",
            self._process.get_metal_layer(),
            self._mem_width,
            self._mem_height,
            self._y_step,
            self._x_offset,
            self._y_offset,
            self._supply_pin_half_width,
            self._supply_pin_pitch,
        )
        rect_list = mem.get_pg_port("VSS").get_rects()
        self._check_pg_pin(
            rect_list, self._mem_width - 2 * self._x_offset, self._supply_pin_width
        )

    def test_rect_pin_mode(self):
        """
        Tests rect pin mode

        signal pins should be rectangular and longer in the X direction
        (1.5 * pin_width x pin_width as defined in the process object.

        pg pins should be the width of the memory (minus four x_offsets) x
        8 * pin_widths high
        """

        mem_config = MemoryConfig("test", 28, 64, 4, 0)
        mem = MemoryFactory.create(
            mem_config, "RAM", "SP", self._process, self._timing_data
        )
        exporter = BasicPortCreator(mem)
        self.assertEqual(exporter._rect_pin_mode, True)

        # Test the pin first. Should be pin_width * 1.5 x pin_width
        pitch = exporter.add_pin(
            "A", Port.Direction.INPUT, self._start_y, self._start_pitch
        )
        self.assertEqual(pitch, self._start_pitch + self._start_y)
        rect_list = mem.get_port("A").get_rects()
        self.assertEqual(len(rect_list), 1)
        exp_width = self._process.get_pin_width_um()
        self._check_pin(
            rect_list[0],
            exp_width * 1.5,
            exp_width,
            0.0,
            self._start_y - (exp_width / 2.0),
        )

        # Test the pg pin
        exporter.create_pg_pin(
            "VSS",
            "GROUND",
            self._process.get_metal_layer(),
            self._mem_width,
            self._mem_height,
            self._y_step,
            self._x_offset,
            self._y_offset,
            self._supply_pin_half_width,
            self._supply_pin_pitch,
        )
        rect_list = mem.get_pg_port("VSS").get_rects()
        self._check_pg_pin(
            rect_list, self._mem_width - 4 * self._x_offset, self._supply_pin_width
        )


if __name__ == "__main__":
    unittest.main()
