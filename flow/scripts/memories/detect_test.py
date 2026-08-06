#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import detect


class DetectTest(unittest.TestCase):
    def test_scan_yosys_json_single_clock(self):
        yosys_json = {
            "modules": {
                "\\sram_256x32": {
                    "cells": {
                        "\\$mem_0": {
                            "type": "$mem_v2",
                            "parameters": {
                                "SIZE": "00000000000000000000000100000000",  # 256
                                "WIDTH": "00000000000000000000000000100000",  # 32
                                "RD_PORTS": 1,
                                "WR_PORTS": 1,
                            },
                            "connections": {
                                "RD_CLK": [10],
                                "WR_CLK": [10],
                                "RD_EN": [11],
                                "WR_EN": [12, 13, 14, 15],  # 4 mask lanes
                                "RD_ADDR": [16, 17, 18, 19, 20, 21, 22, 23],
                                "WR_ADDR": [16, 17, 18, 19, 20, 21, 22, 23],
                                "RD_DATA": list(range(24, 56)),
                                "WR_DATA": list(range(56, 88)),
                            },
                        }
                    }
                }
            }
        }
        mems = detect.scan_yosys_json(yosys_json)
        self.assertEqual(len(mems), 1)
        m = mems[0]
        self.assertEqual(
            (m.name, m.rows, m.bits, m.addr_w), ("sram_256x32", 256, 32, 8)
        )
        self.assertEqual((m.read_ports, m.write_ports, m.mask_lanes), (1, 1, 4))
        self.assertIn("single-clock", m.reason)

    def test_scan_yosys_json_multi_clock(self):
        yosys_json = {
            "modules": {
                "\\async_ram_512x16": {
                    "cells": {
                        "\\$mem_0": {
                            "type": "$mem_v2",
                            "parameters": {
                                "SIZE": 512,
                                "WIDTH": 16,
                                "RD_PORTS": 1,
                                "WR_PORTS": 1,
                            },
                            "connections": {
                                "RD_CLK": [100],
                                "WR_CLK": [200],  # Different clock net ID
                                "RD_EN": [101],
                                "WR_EN": [201],
                                "RD_ADDR": list(range(102, 111)),
                                "WR_ADDR": list(range(202, 211)),
                                "RD_DATA": list(range(111, 127)),
                                "WR_DATA": list(range(211, 227)),
                            },
                        }
                    }
                }
            }
        }
        mems = detect.scan_yosys_json(yosys_json)
        self.assertEqual(len(mems), 1)
        m = mems[0]
        self.assertEqual(
            (m.name, m.rows, m.bits, m.addr_w), ("async_ram_512x16", 512, 16, 9)
        )
        self.assertIn("multi-clock", m.reason)

    def test_scan_yosys_json_empty_or_non_memory(self):
        yosys_json = {
            "modules": {
                "\\counter": {
                    "cells": {
                        "\\$add_0": {
                            "type": "$add",
                            "parameters": {"A_WIDTH": 8, "B_WIDTH": 8},
                            "connections": {},
                        }
                    }
                }
            }
        }
        self.assertEqual(detect.scan_yosys_json(yosys_json), [])


if __name__ == "__main__":
    unittest.main()
