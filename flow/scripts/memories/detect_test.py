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


def _mem_cell(size, width, rd_clk_enable="1", wr_en_bits=None):
    return {
        "type": "$mem_v2",
        "parameters": {
            "SIZE": size,
            "WIDTH": width,
            "RD_PORTS": 1,
            "WR_PORTS": 1,
            "RD_CLK_ENABLE": rd_clk_enable,
        },
        "connections": {
            "RD_CLK": [2],
            "WR_CLK": [2],
            "RD_EN": [3],
            "WR_EN": wr_en_bits if wr_en_bits is not None else [4],
            "RD_ADDR": list(range(10, 16)),
            "WR_ADDR": list(range(10, 16)),
            "RD_DATA": list(range(100, 100 + width)),
            "WR_DATA": list(range(300, 300 + width)),
        },
    }


def _firtool_rw_module(size=64, width=114, lanes=2, rd_clk_enable="1"):
    """A module shaped like firtool's array_<depth>x<width>: one RW port."""
    addr_w = (size - 1).bit_length()
    ports = {
        "RW0_addr": {"direction": "input", "bits": list(range(1, 1 + addr_w))},
        "RW0_en": {"direction": "input", "bits": [20]},
        "RW0_clk": {"direction": "input", "bits": [2]},
        "RW0_wmode": {"direction": "input", "bits": [21]},
        "RW0_wdata": {"direction": "input", "bits": list(range(300, 300 + width))},
        "RW0_rdata": {"direction": "output", "bits": list(range(500, 500 + width))},
        "RW0_wmask": {"direction": "input", "bits": list(range(30, 30 + lanes))},
    }
    cells = {
        "\\Memory": _mem_cell(
            size, width, rd_clk_enable, list(range(700, 700 + width))
        ),
        "$and$1": {"type": "$and", "parameters": {}, "connections": {}},
        "$mux$2": {"type": "$mux", "parameters": {}, "connections": {}},
    }
    return {"ports": ports, "cells": cells}


class FirtoolConventionTest(unittest.TestCase):
    def test_one_memory_per_module_is_named_after_the_module(self):
        # firtool calls every array `Memory`; two modules with glue around
        # theirs must come out as two entries, named for the modules.
        yosys_json = {
            "modules": {
                "\\array_64x114": _firtool_rw_module(),
                "\\array_256x66": _firtool_rw_module(256, 66, 1),
            }
        }
        mems = detect.scan_yosys_json(yosys_json)
        self.assertEqual(sorted(m.name for m in mems), ["array_256x66", "array_64x114"])

    def test_rw_port_pins_are_the_module_ports(self):
        (m,) = detect.scan_yosys_json(
            {"modules": {"\\array_64x114": _firtool_rw_module()}}
        )
        self.assertEqual(m.port_convention, "firtool")
        self.assertEqual((m.read_ports, m.write_ports, m.rw_ports), (0, 0, 1))
        self.assertEqual(m.mask_lanes, 2)
        self.assertEqual(m.comb_read_ports, 0)
        by_name = {p.name: p for p in m.pins}
        self.assertEqual(
            sorted(by_name),
            [
                "RW0_addr",
                "RW0_clk",
                "RW0_en",
                "RW0_rdata",
                "RW0_wdata",
                "RW0_wmask",
                "RW0_wmode",
            ],
        )
        self.assertEqual(by_name["RW0_rdata"].function, "data_out")
        self.assertEqual(by_name["RW0_rdata"].direction, "output")
        self.assertEqual(by_name["RW0_wdata"].function, "data_in")
        self.assertEqual(by_name["RW0_wmask"].function, "mask")
        self.assertEqual(by_name["RW0_wmask"].width, 2)
        self.assertEqual(by_name["RW0_wmode"].function, "wmode")
        self.assertTrue(all(p.port_id == "RW0" for p in m.pins))

    def test_combinational_read_is_counted(self):
        (m,) = detect.scan_yosys_json(
            {"modules": {"\\bank": _firtool_rw_module(rd_clk_enable="0")}}
        )
        self.assertEqual(m.comb_read_ports, 1)

    def test_clock_enable_as_integer(self):
        self.assertEqual(detect._clock_enable_bits(1, 1), "1")
        self.assertEqual(detect._clock_enable_bits(2, 2), "10")
        self.assertEqual(detect._clock_enable_bits("0", 1), "0")

    def test_clock_enable_that_is_not_one_bit_per_port_is_refused(self):
        # yosys writes exactly RD_PORTS binary digits; padding a short value
        # or reading "2" as decimal would miscount combinational reads.
        for val, ports in (("0", 2), ("011", 2), ("2", 2), (4, 2), (-1, 1)):
            with self.assertRaises(ValueError, msg=(val, ports)):
                detect._clock_enable_bits(val, ports)

    def test_ports_outside_the_convention_keep_synthesized_pins(self):
        module = _firtool_rw_module()
        module["ports"]["ce_in"] = {"direction": "input", "bits": [40]}
        (m,) = detect.scan_yosys_json({"modules": {"\\other": module}})
        self.assertEqual(m.port_convention, "")
        self.assertEqual((m.read_ports, m.write_ports, m.rw_ports), (1, 1, 0))
        self.assertIn("R0_addr", [p.name for p in m.pins])

    def test_second_memory_in_a_module_gets_a_qualified_name(self):
        module = _firtool_rw_module()
        module["cells"]["\\Other"] = _mem_cell(64, 8)
        names = sorted(
            m.name for m in detect.scan_yosys_json({"modules": {"\\m": module}})
        )
        self.assertEqual(names, ["m.Memory", "m.Other"])

    def test_inline_array_with_other_logic_is_named_per_cell(self):
        # One memory among other logic, ports not firtool's: the module is
        # not a memory, so the entry must not take its name.
        mod = _firtool_rw_module()
        mod["ports"] = {
            "clk": {"direction": "input", "bits": [2]},
            "parity": {"direction": "output", "bits": [3]},
        }
        mems = detect.scan_yosys_json({"modules": {"\\am_regs": mod}})
        self.assertEqual([m.name for m in mems], ["am_regs.Memory"])


if __name__ == "__main__":
    unittest.main()
