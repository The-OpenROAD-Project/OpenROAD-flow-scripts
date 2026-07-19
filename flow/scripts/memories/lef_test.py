#!/usr/bin/env python3
import re
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import detect
import lef
import pdk_asap7
from detect_test import BUS_STYLE


class LefTest(unittest.TestCase):
    def setUp(self):
        self.params = pdk_asap7.ASAP7
        self.mem = detect.scan_text(BUS_STYLE)[0]
        self.lef = lef.emit_lef(self.mem, self.params)
        m = re.search(r"SIZE ([\d.]+) BY ([\d.]+) ;", self.lef)
        self.width, self.height = float(m.group(1)), float(m.group(2))

    def test_macro_block_with_foreign(self):
        self.assertIn("MACRO mem_128x32", self.lef)
        self.assertIn("FOREIGN mem_128x32 0 0 ;", self.lef)
        self.assertIn("SYMMETRY X Y R90 ;", self.lef)
        self.assertIn("CLASS BLOCK ;", self.lef)
        self.assertIn("END LIBRARY", self.lef)

    def test_size_snapped_to_grid(self):
        for value in (self.width, self.height):
            steps = value / self.params.grid_um
            self.assertAlmostEqual(steps, round(steps), places=3)

    def test_per_bit_signal_pins(self):
        for bit in (0, 31):
            self.assertIn(f"PIN W0_data[{bit}]", self.lef)
            self.assertIn(f"PIN R0_data[{bit}]", self.lef)
        self.assertIn("PIN R0_clk", self.lef)
        self.assertIn("PIN W0_clk", self.lef)
        # Pads on the pin layer, abutment-shaped, direction per pin.
        block = self.lef[self.lef.index("PIN R0_data[0]") :]
        block = block[: block.index("END R0_data[0]")]
        self.assertIn("DIRECTION OUTPUT ;", block)
        self.assertIn("SHAPE ABUTMENT ;", block)
        self.assertIn(f"LAYER {self.params.pin_layer} ;", block)

    def test_power_ground_straps_interleaved(self):
        vdd = self.lef[self.lef.index("PIN VDD") : self.lef.index("END VDD")]
        vss = self.lef[self.lef.index("PIN VSS") : self.lef.index("END VSS")]
        self.assertIn("USE POWER ;", vdd)
        self.assertIn("USE GROUND ;", vss)
        self.assertIn(f"LAYER {self.params.pg_layer} ;", vdd)
        vdd_ys = [
            float(m.group(2)) for m in re.finditer(r"RECT ([\d.]+) ([\d.]+)", vdd)
        ]
        vss_ys = [
            float(m.group(2)) for m in re.finditer(r"RECT ([\d.]+) ([\d.]+)", vss)
        ]
        self.assertGreater(len(vdd_ys), 1)
        self.assertGreater(len(vss_ys), 1)
        self.assertAlmostEqual(vss_ys[0], 0.0)
        self.assertAlmostEqual(vdd_ys[0], self.params.pg_vdd_offset_um)
        self.assertAlmostEqual(vdd_ys[1] - vdd_ys[0], self.params.pg_strap_pitch_um)

    def test_all_shapes_inside_macro(self):
        for m in re.finditer(r"RECT\s+([\d.]+) ([\d.]+) ([\d.]+) ([\d.]+) ;", self.lef):
            x0, y0, x1, y1 = (float(g) for g in m.groups())
            self.assertLess(x0, x1)
            self.assertLess(y0, y1)
            self.assertGreaterEqual(x0, 0.0)
            self.assertGreaterEqual(y0, 0.0)
            self.assertLessEqual(x1, self.width)
            self.assertLessEqual(y1, self.height)

    def test_obs_covers_footprint_on_all_layers(self):
        obs_start = self.lef.index("\n  OBS")
        obs = self.lef[obs_start : self.lef.index("\n  END\n", obs_start)]
        for layer in self.params.obs_device_layers + self.params.obs_metal_layers:
            self.assertIn(f"LAYER {layer} ;", obs)
        self.assertIn(f"RECT 0 0 {self.width:.3f} {self.height:.3f} ;", obs)


if __name__ == "__main__":
    unittest.main()
