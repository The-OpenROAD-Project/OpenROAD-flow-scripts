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

    def _create_sp_ram(self, process, width, depth):
        mem_config = MemoryConfig.from_json(
            {"name": "sample", "width": width, "depth": depth, "banks": 1}
        )
        return MemoryFactory.create(mem_config, "RAM", "SP", process, TimingData())

    def _pin_height(self, process, memory):
        return 2 * process.y_offset + memory.get_num_pins() * process.pin_pitch_um

    def test_shallow_memory_is_tall_enough_for_its_pins(self):
        """
        A 4x25 RAM's bitcells are 1.296 um tall, too short for its 55 pins;
        it is made as tall as its pins need, snapped up to 2.8 um
        """

        memory = self._create_sp_ram(self._process, 25, 4)
        physical = memory.get_physical_data()
        self.assertEqual(memory.get_num_pins(), 55)
        self.assertGreaterEqual(
            physical.get_height(), self._pin_height(self._process, memory)
        )
        self.assertAlmostEqual(physical.get_height(), 2.8, delta=self._delta)

    def test_deep_memory_keeps_bitcell_height(self):
        """A memory whose bitcells already fit its pins is not made taller"""

        memory = self._create_sp_ram(self._process, 32, 64)
        _, height = self._process.get_macro_dimensions(32, 64, 1, 0)
        self.assertGreater(height, self._pin_height(self._process, memory))
        self.assertAlmostEqual(
            memory.get_physical_data().get_height(), 21.0, delta=self._delta
        )

    def test_pins_fit_exactly_without_snapping(self):
        """
        With a 1 nm snap the height is exactly what the pins need, and
        every pin still gets a track
        """

        process_data = TestUtils.get_base_process_data().copy()
        process_data["snap_height_nm"] = 1
        process = Process(process_data)
        for width in range(1, 300):
            # constructing the memory raises if its pins do not fit
            memory = self._create_sp_ram(process, width, 4)
            self.assertGreaterEqual(memory.get_physical_data().get_pin_pitch(), 0)


if __name__ == "__main__":
    unittest.main()
