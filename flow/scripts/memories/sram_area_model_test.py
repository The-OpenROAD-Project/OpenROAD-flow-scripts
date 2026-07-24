#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import sram_area_model


class AreaModelTest(unittest.TestCase):
    def test_anchor_order_of_magnitude(self):
        # A 256x32 single-port array: storage ~246 µm² + peripheral;
        # published 7 nm SP-SRAM IP of this size lands well under
        # 1000 µm².
        area = sram_area_model.sram_area_um2(256, 32)
        self.assertGreater(area, 300.0)
        self.assertLess(area, 1000.0)

    def test_monotonic_in_bits(self):
        small = sram_area_model.sram_area_um2(64, 32)
        large = sram_area_model.sram_area_um2(256, 32)
        self.assertLess(small, large)

    def test_ports_increase_area(self):
        sp = sram_area_model.sram_area_um2(256, 32)
        mp = sram_area_model.sram_area_um2(256, 32, read_ports=2, write_ports=2)
        self.assertLess(sp, mp)

    def test_mask_lanes_increase_area(self):
        unmasked = sram_area_model.sram_area_um2(256, 32)
        masked = sram_area_model.sram_area_um2(256, 32, write_mask_lanes=4)
        self.assertLess(unmasked, masked)
        # Zero lanes reproduces the unmasked model exactly.
        self.assertEqual(
            unmasked, sram_area_model.sram_area_um2(256, 32, write_mask_lanes=0)
        )

    def test_node_scaling_is_quadratic(self):
        at7 = sram_area_model.sram_area_um2(256, 32, tech_nm=7)
        at14 = sram_area_model.sram_area_um2(256, 32, tech_nm=14)
        self.assertAlmostEqual(at14 / at7, 4.0, places=6)

    def test_leakage_anchor(self):
        # 8 Kb at ~100 pW/bit plus one port's sense amps.
        leak = sram_area_model.sram_leakage_pw(256, 32)
        self.assertAlmostEqual(leak, 256 * 32 * 100.0 + 5000.0)

    def test_dynamic_energy_scales_with_columns(self):
        narrow = sram_area_model.sram_dynamic_pj_per_access(256, 8)
        wide = sram_area_model.sram_dynamic_pj_per_access(256, 64)
        self.assertLess(narrow, wide)

    def test_dimensions_respect_aspect_ratio(self):
        w, h = sram_area_model.sram_dimensions_um(5000.0, aspect_ratio=0.5)
        self.assertAlmostEqual(w * h, 5000.0, places=6)
        self.assertAlmostEqual(h / w, 0.5, places=6)

    def test_input_validation(self):
        with self.assertRaises(ValueError):
            sram_area_model.sram_area_um2(0, 32)
        with self.assertRaises(ValueError):
            sram_area_model.sram_area_um2(256, 32, read_ports=-1)
        with self.assertRaises(ValueError):
            sram_area_model.sram_leakage_pw(256, 32, ports=0)
        with self.assertRaises(ValueError):
            sram_area_model.sram_dimensions_um(-1.0)


if __name__ == "__main__":
    unittest.main()
