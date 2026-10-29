#!/usr/bin/env python3
"""A single-port RAM with declared pin names and write-mask lanes.

The ORFS asap7 backend builds the macro from the pins of the module it
replaces, so the views must carry those names and the mask bus, and a
memory without either must come out exactly as before.
"""

import io
import json
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from class_process import Process
from memory_config import MemoryConfig
from memory_factory import MemoryFactory
from timing_data import TimingData
from ram_liberty_exporter import RAMLibertyExporter
from lef_exporter import LefExporter
from test_utils import TestUtils
from orfs_asap7.generate import (
    ASAP7_TIMING_CONFIG,
    additional_height_for_pins,
    run_orfs_asap7,
    single_port_pins,
)

RW0_NAMES = {
    "clk": "RW0_clk",
    "ce": "RW0_en",
    "we": "RW0_wmode",
    "addr": "RW0_addr",
    "din": "RW0_wdata",
    "dout": "RW0_rdata",
    "mask": "RW0_wmask",
}


def rw0_pins(bits, addr_w, lanes):
    """memories.json pins for a firtool array_<depth>x<width> module."""
    pin = lambda name, direction, width, function: {
        "name": name,
        "direction": direction,
        "width": width,
        "port_id": "RW0",
        "function": function,
    }
    pins = [
        pin("RW0_addr", "input", addr_w, "addr"),
        pin("RW0_en", "input", 1, "en"),
        pin("RW0_clk", "input", 1, "clk"),
        pin("RW0_wmode", "input", 1, "wmode"),
        pin("RW0_wdata", "input", bits, "data_in"),
        pin("RW0_rdata", "output", bits, "data_out"),
    ]
    if lanes:
        pins.append(pin("RW0_wmask", "input", lanes, "mask"))
    return pins


class MaskedSinglePortRAMTest(unittest.TestCase):
    def setUp(self):
        self.process = Process(TestUtils.get_base_process_data())
        self.timing = TimingData(ASAP7_TIMING_CONFIG)

    def make(self, name, bits, rows, pin_names=None, lanes=0):
        extra = additional_height_for_pins(self.process, bits, rows, lanes)
        cfg = MemoryConfig(name, bits, rows, 1, extra, pin_names, lanes)
        return MemoryFactory.create(cfg, "RAM", "SP", self.process, self.timing)

    def test_declared_names_and_mask_reach_liberty_and_lef(self):
        ram = self.make("array_64x114", 114, 64, RW0_NAMES, 2)
        lib = io.StringIO()
        RAMLibertyExporter(ram).export(lib)
        lib = lib.getvalue()
        for pin in ("RW0_clk", "RW0_en", "RW0_wmode"):
            self.assertIn(f"pin({pin})", lib)
        for bus in ("RW0_addr", "RW0_wdata", "RW0_rdata", "RW0_wmask"):
            self.assertIn(f"bus({bus})", lib)
        self.assertIn("type (array_64x114_RW0_wmask)", lib)
        self.assertIn("bit_width : 2;", lib)
        self.assertNotIn("we_in", lib)
        self.assertNotIn("ce_in", lib)
        lef = io.StringIO()
        LefExporter(ram).export(lef)
        lef = lef.getvalue()
        self.assertIn("PIN RW0_wmask[0]", lef)
        self.assertIn("PIN RW0_wmask[1]", lef)
        self.assertNotIn("PIN RW0_wmask[2]", lef)
        self.assertIn("PIN RW0_rdata[113]", lef)

    def test_per_bit_mask_gets_a_track_per_pin(self):
        # 76 lanes on a 76-bit word: the pins outnumber the tracks the bit
        # cells alone would give the macro, so the height has to grow.
        ram = self.make("array_128x76", 76, 128, RW0_NAMES, 76)
        lef = io.StringIO()
        LefExporter(ram).export(lef)
        self.assertIn("PIN RW0_wmask[75]", lef.getvalue())

    def test_unmasked_default_names_are_unchanged(self):
        ram = self.make("spsram_256x32", 32, 256)
        lib = io.StringIO()
        RAMLibertyExporter(ram).export(lib)
        lib = lib.getvalue()
        for pin in ("we_in", "ce_in", "clk"):
            self.assertIn(f"pin({pin})", lib)
        for bus in ("addr_in", "wd_in", "rd_out"):
            self.assertIn(f"bus({bus})", lib)
        self.assertNotIn("w_mask_in", lib)

    def test_verilog_writes_lanes_under_the_mask(self):
        ram = self.make("array_64x114", 114, 64, RW0_NAMES, 2)
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "m.v")
            ram.write_verilog_file(path)
            v = Path(path).read_text()
            bb = os.path.join(d, "m.sv")
            ram.write_verilog_file(bb, True)
            sv = Path(bb).read_text()
        self.assertIn("parameter MASK_LANES = 2;", v)
        self.assertIn("parameter LANE_WIDTH = 57;", v)
        self.assertIn("if (RW0_wmask[j])", v)
        self.assertIn("input  [MASK_LANES-1:0]  RW0_wmask;", v)
        self.assertIn("input [1:0] RW0_wmask", sv)

    def test_mask_must_divide_the_word(self):
        with self.assertRaises(Exception):
            MemoryConfig("m", 114, 64, 1, 0, RW0_NAMES, 5)


class SinglePortPinsTest(unittest.TestCase):
    def test_reads_names_and_lanes(self):
        names, lanes = single_port_pins({"pins": rw0_pins(114, 6, 2)})
        self.assertEqual(names, RW0_NAMES)
        self.assertEqual(lanes, 2)

    def test_unmasked_port(self):
        names, lanes = single_port_pins({"pins": rw0_pins(66, 8, 0)})
        self.assertNotIn("mask", names)
        self.assertEqual(lanes, 0)

    def test_separate_ports_are_not_single_port(self):
        pins = rw0_pins(32, 5, 0)
        pins[0]["port_id"] = "R0"
        self.assertIsNone(single_port_pins({"pins": pins}))

    def test_synthesized_pins_are_not_single_port(self):
        self.assertIsNone(single_port_pins({"pins": []}))


class BackendTest(unittest.TestCase):
    def test_emits_views_named_by_the_module(self):
        inventory = {
            "version": 1,
            "platform": "asap7",
            "memories": [
                {
                    "name": "array_64x114",
                    "rows": 64,
                    "bits": 114,
                    "addr_w": 6,
                    "read_ports": 0,
                    "write_ports": 0,
                    "rw_ports": 1,
                    "mask_lanes": 2,
                    "port_convention": "firtool",
                    "pins": rw0_pins(114, 6, 2),
                    "idiomatic": True,
                    "reason": "meets ASAP7 macro floors",
                },
                {
                    "name": "diff_rat_state_bank_704x776",
                    "rows": 704,
                    "bits": 776,
                    "idiomatic": False,
                    "reason": "1 combinational read port(s)",
                },
            ],
        }
        with tempfile.TemporaryDirectory() as d:
            inv = Path(d) / "memories.json"
            inv.write_text(json.dumps(inventory))
            out = Path(d) / "memories"
            self.assertEqual(run_orfs_asap7("asap7", out, inv), 0)
            self.assertEqual(
                sorted(p.name for p in out.iterdir()),
                [
                    "array_64x114.lef",
                    "array_64x114.lib",
                    "array_64x114_pre_layout.lib",
                    "blackboxes.txt",
                ],
            )
            lib = (out / "array_64x114.lib").read_text()
            self.assertIn("cell(array_64x114)", lib)
            self.assertIn("bus(RW0_wmask)", lib)
            self.assertIn("pin(RW0_en)", lib)
            # `<module> <area>`: synthesis costs the blackbox by its area
            [line] = (out / "blackboxes.txt").read_text().splitlines()
            module, area = line.split()
            self.assertEqual(module, "array_64x114")
            self.assertGreater(float(area), 0)

    def test_declared_separate_ports_are_refused(self):
        pins = rw0_pins(32, 5, 0)
        for p in pins:
            p["port_id"] = "R0" if p["function"] in ("data_out",) else "W0"
        inventory = {
            "version": 1,
            "memories": [
                {
                    "name": "ram_32x32",
                    "rows": 32,
                    "bits": 32,
                    "port_convention": "firtool",
                    "pins": pins,
                    "idiomatic": True,
                }
            ],
        }
        with tempfile.TemporaryDirectory() as d:
            inv = Path(d) / "memories.json"
            inv.write_text(json.dumps(inventory))
            self.assertEqual(run_orfs_asap7("asap7", Path(d) / "out", inv), 1)


if __name__ == "__main__":
    unittest.main()
