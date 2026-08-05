#!/usr/bin/env python3

import os
import sys
import math
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from class_memory import Memory
from class_process import Process
from memory_factory import MemoryFactory
from memory_config import MemoryConfig
from timing_data import TimingData
from test_utils import TestUtils


class MemoryTest(unittest.TestCase):
    """Unit test for Memory object"""

    def setUp(self):
        """Sets up process object used by test methods"""

        self._process = Process(TestUtils.get_base_process_data())
        # delta for use when comparing floats
        self._delta = 0.01
        self._sram_data = {
            "name": "sample",
            "width": 39,
            "depth": 2048,
            "banks": 1,
        }

    def test_memory(self):
        """
        Tests basic memory object
        """

        timing_data = TimingData()
        mem_config = MemoryConfig.from_json(self._sram_data)
        memory = MemoryFactory.create(
            mem_config,
            "RAM",
            "SP",
            self._process,
            timing_data,
        )
        self.assertEqual(memory.get_name(), self._sram_data["name"])
        self.assertEqual(memory.get_width(), self._sram_data["width"])
        self.assertEqual(memory.get_depth(), self._sram_data["depth"])
        self.assertEqual(memory.get_num_banks(), self._sram_data["banks"])
        self.assertEqual(memory.get_additional_height(), 0)
        self.assertEqual(
            memory.get_width_in_bytes(), math.ceil(memory.get_width() / 8.0)
        )
        self.assertEqual(
            memory.get_total_size(), memory.get_width_in_bytes() * memory.get_depth()
        )
        # the area used by Liberty is calculated prior to snapping, so check
        # that the area is within some delta determined by the snap area
        area_delta = self._process.snap_width_nm * self._process.snap_height_nm * 1e-3
        physical = memory.get_physical_data()
        self.assertAlmostEqual(
            physical.get_area(False),
            physical.get_width() * physical.get_height(),
            delta=area_delta,
        )

        # These values are all hard-coded in the Memory object
        timing_data = memory.get_timing_data()
        self.assertEqual(memory.get_num_rw_ports(), 1)
        self.assertEqual(timing_data.t_setup_ns, 0.05)
        self.assertEqual(timing_data.t_hold_ns, 0.05)
        self.assertEqual(timing_data.standby_leakage_per_bank_mW, 0.1289)
        self.assertEqual(timing_data.access_time_ns, 0.2183)
        self.assertEqual(timing_data.pin_dynamic_power_mW, 0.0013449)
        self.assertEqual(timing_data.cap_input_pf, 0.005)
        self.assertEqual(timing_data.cycle_time_ns, 0.1566)
        self.assertEqual(timing_data.fo4_ps, 9.0632)


if __name__ == "__main__":
    unittest.main()
