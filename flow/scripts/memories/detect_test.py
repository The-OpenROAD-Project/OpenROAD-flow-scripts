#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import detect

# firtool-style memory with whole-bus data and mask pins, and a
# continuation-comma port (`W0_clk` carries no direction keyword of its
# own — it continues the preceding `input` group).
BUS_STYLE = """\
module mem_128x32(
  input  [6:0]  R0_addr,
  input         R0_en,
  input         R0_clk,
  output [31:0] R0_data,
  input  [6:0]  W0_addr,
  input         W0_en,
                W0_clk,
  input  [31:0] W0_data,
  input  [3:0]  W0_mask
);
endmodule
"""

# Subword-split style: data and mask split into per-lane pins.
SUBWORD_STYLE = """\
module mem_1024x32(
  input  [9:0] R0_addr,
  input        R0_en,
  input        R0_clk,
  output [7:0] R0_data_0,
  output [7:0] R0_data_1,
  output [7:0] R0_data_2,
  output [7:0] R0_data_3,
  input  [9:0] W0_addr,
  input        W0_en,
  input        W0_clk,
  input  [7:0] W0_data_0,
  input  [7:0] W0_data_1,
  input  [7:0] W0_data_2,
  input  [7:0] W0_data_3,
  input        W0_mask_0,
  input        W0_mask_1,
  input        W0_mask_2,
  input        W0_mask_3
);
endmodule
"""

RW_STYLE = """\
module cache_tags(
  input  [1:0]  RW0_addr,
  input         RW0_en,
  input         RW0_clk,
  input         RW0_wmode,
  input  [24:0] RW0_wdata_0,
  output [24:0] RW0_rdata_0
);
endmodule
"""

# A module with one convention-shaped port among ordinary ports must
# not classify as a memory.
NOT_A_MEMORY = """\
module controller(
  input        clock,
  input        reset,
  input  [6:0] R0_addr,
  output       done
);
endmodule
"""


class DetectTest(unittest.TestCase):
    def test_bus_style(self):
        mems = detect.scan_text(BUS_STYLE)
        self.assertEqual(len(mems), 1)
        m = mems[0]
        self.assertEqual((m.name, m.rows, m.bits, m.addr_w), ("mem_128x32", 128, 32, 7))
        self.assertEqual(
            (m.read_ports, m.write_ports, m.rw_ports, m.mask_lanes), (1, 1, 0, 4)
        )
        functions = {p.name: p.function for p in m.pins}
        self.assertEqual(functions["R0_data"], "data_out")
        self.assertEqual(functions["W0_data"], "data_in")
        self.assertEqual(functions["W0_mask"], "mask")
        # The continuation-comma port is captured with its group's
        # direction.
        clk = next(p for p in m.pins if p.name == "W0_clk")
        self.assertEqual(clk.direction, "input")

    def test_subword_style(self):
        mems = detect.scan_text(SUBWORD_STYLE)
        self.assertEqual(len(mems), 1)
        m = mems[0]
        self.assertEqual((m.rows, m.bits, m.mask_lanes), (1024, 32, 4))
        self.assertEqual((m.read_ports, m.write_ports), (1, 1))
        functions = {p.name: p.function for p in m.pins}
        self.assertEqual(functions["R0_data_2"], "data_out")
        self.assertEqual(functions["W0_data_2"], "data_in")
        self.assertEqual(functions["W0_mask_3"], "mask")

    def test_rw_style(self):
        mems = detect.scan_text(RW_STYLE)
        self.assertEqual(len(mems), 1)
        m = mems[0]
        self.assertEqual((m.rows, m.bits, m.rw_ports), (4, 25, 1))
        functions = {p.name: p.function for p in m.pins}
        self.assertEqual(functions["RW0_wmode"], "wmode")
        self.assertEqual(functions["RW0_wdata_0"], "data_in")
        self.assertEqual(functions["RW0_rdata_0"], "data_out")

    def test_non_memory_rejected(self):
        self.assertEqual(detect.scan_text(NOT_A_MEMORY), [])

    def test_multiple_modules_in_one_text(self):
        text = BUS_STYLE + NOT_A_MEMORY + RW_STYLE
        names = [m.name for m in detect.scan_text(text)]
        self.assertEqual(names, ["mem_128x32", "cache_tags"])

    def test_behavioral_model_recorded(self):
        mems = detect.scan_text(BUS_STYLE, source_file="rtl/mems.v")
        self.assertEqual(
            mems[0].behavioral_model,
            {
                "file": "rtl/mems.v",
                "module": "mem_128x32",
            },
        )

    def test_rw_port_with_plain_data_rejected(self):
        text = RW_STYLE.replace("RW0_wdata_0", "RW0_data_0")
        self.assertEqual(detect.scan_text(text), [])

    def test_port_group_without_clk_rejected(self):
        text = BUS_STYLE.replace("W0_clk", "W0_clock")
        self.assertEqual(detect.scan_text(text), [])

    def test_comments_in_port_list_ignored(self):
        text = BUS_STYLE.replace(
            "output [31:0] R0_data,",
            "output [31:0] R0_data,  // output data for read port\n"
            "  /* input for clock is per port */",
        )
        mems = detect.scan_text(text)
        self.assertEqual(len(mems), 1)
        self.assertEqual(mems[0].bits, 32)

    def test_commented_out_module_ignored(self):
        text = "/*\n" + BUS_STYLE + "*/\n" + RW_STYLE
        names = [m.name for m in detect.scan_text(text)]
        self.assertEqual(names, ["cache_tags"])

    def test_parameterized_width_disqualifies(self):
        text = BUS_STYLE.replace("[31:0]", "[WIDTH-1:0]")
        self.assertEqual(detect.scan_text(text), [])


if __name__ == "__main__":
    unittest.main()
