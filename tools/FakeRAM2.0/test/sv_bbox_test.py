#!/usr/bin/env python3

import os
import re
import io
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from single_port_ram_verilog_exporter import SinglePortRAMVerilogExporter
from memory_factory import MemoryFactory
from memory_config import MemoryConfig
from class_process import Process
from timing_data import TimingData
from test_utils import TestUtils


class SVBBoxDataTest(unittest.TestCase):
    """Unit test for SystemVerilog blackbox class"""

    def setUp(self):
        """Sets up base_data with example config data"""
        self._process = Process(TestUtils.get_base_process_data())
        self._timing_data = TimingData()
        self._bus_re = re.compile(
            r"^\s*\S+\s+(?:reg)?\s*\[\s*(\d+)\:(\d+)\s*]\s*(\S+)\s*\,"
        )

    def _extract_bus_msb(self, content):
        msb_map = {}
        in_strm = io.StringIO(content)

        for line in in_strm:
            result = self._bus_re.match(line)
            if result:
                msb = int(result.group(1))
                bus_name = result.group(3)
                msb_map[bus_name] = msb
        return msb_map

    def _check_bus_msb(self, mem_name, bus_name, bus_msb_map, exp_msb):
        self.assertIn(bus_name, bus_msb_map)
        self.assertEqual(
            bus_msb_map[bus_name],
            exp_msb,
            f"msb's don't match for {bus_name} on {mem_name}: {bus_msb_map[bus_name]} {exp_msb}",
        )

    def _check_bbox(self, words, depth):
        name = f"fakeram_16_{depth}"
        mem_config = MemoryConfig(name, words, depth, 4, 0)
        mem = MemoryFactory.create(
            mem_config, "RAM", "SP", self._process, self._timing_data
        )
        exporter = SinglePortRAMVerilogExporter(mem)
        strm = io.StringIO()
        exporter.export_blackbox(strm)
        content = strm.getvalue()
        strm.close()
        bus_msb_map = self._extract_bus_msb(content)
        self._check_bus_msb(name, "rd_out", bus_msb_map, mem.get_data_bus_msb())
        self._check_bus_msb(name, "wd_in", bus_msb_map, mem.get_data_bus_msb())
        self._check_bus_msb(name, "addr_in", bus_msb_map, mem.get_addr_bus_msb())

    def test_spsram_bbox(self):
        """
        Tests that the spsram rd_out and wd_in indices are the same and
        correct
        """

        words = 16
        depths = [32, 64, 256]
        for depth in depths:
            self._check_bbox(words, depth)


if __name__ == "__main__":
    unittest.main()
