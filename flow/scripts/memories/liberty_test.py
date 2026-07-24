#!/usr/bin/env python3
import re
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import detect
import liberty
import pdk_asap7
from detect_test import BUS_STYLE, SUBWORD_STYLE


class LibertyTest(unittest.TestCase):
    def setUp(self):
        self.params = pdk_asap7.ASAP7
        self.mem = detect.scan_text(BUS_STYLE)[0]
        self.lib = liberty.emit_lib(self.mem, self.params)

    def test_bus_umbrella_with_per_bit_pins(self):
        # Both the bus() block and every per-bit pin must be present:
        # a bus without per-bit siblings makes yosys silently drop bit
        # connections at parent instances.
        self.assertIn('bus ("W0_data") {', self.lib)
        self.assertIn('type ("W0_data") {', self.lib)
        for bit in range(32):
            self.assertIn(f'pin ("W0_data[{bit}]")', self.lib)
            self.assertIn(f'pin ("R0_data[{bit}]")', self.lib)

    def test_output_bits_have_clocked_arcs(self):
        block = self.lib[self.lib.index('pin ("R0_data[31]")') :]
        block = block[: block.index('pin ("R0_data[30]")')]
        self.assertIn("timing_type : rising_edge;", block)
        self.assertIn('related_pin : "R0_clk";', block)

    def test_input_bits_have_setup_and_hold(self):
        block = self.lib[self.lib.index('pin ("W0_data[31]")') :]
        block = block[: block.index('pin ("W0_data[30]")')]
        self.assertIn("timing_type : setup_rising;", block)
        self.assertIn("timing_type : hold_rising;", block)
        self.assertIn("internal_power()", block)

    def test_clock_pins(self):
        for clk in ("R0_clk", "W0_clk"):
            block = self.lib[self.lib.index(f'pin ("{clk}")') :]
            block = block[: block.index("    }")]
            self.assertIn("clock : true;", block)
            self.assertIn("min_period", block)
        self.assertIn("min_clock_tree_path", self.lib)
        self.assertIn("max_clock_tree_path", self.lib)

    def test_power_uses_power_lut_template(self):
        # OpenSTA report_power -saif reads power templates from the
        # power-template registry; lu_table_template silently zeroes it.
        self.assertIn("power_lut_template(power_template)", self.lib)
        self.assertIn("rise_power(power_template)", self.lib)

    def test_platform_voltage(self):
        self.assertIn(
            f"nom_voltage                    : " f"{self.params.nom_voltage};", self.lib
        )

    def test_memory_group(self):
        self.assertIn("address_width : 7;", self.lib)
        self.assertIn("word_width : 32;", self.lib)

    def test_pre_layout_variant_has_ideal_clock(self):
        pre = liberty.emit_lib(self.mem, self.params, ck_insertion_ps=0.0)
        tree_values = re.findall(
            r"clock_tree_path;\s*cell_rise\(scalar\) {\s*" r'values\("([\d.]+)"\);', pre
        )
        self.assertTrue(tree_values)
        self.assertTrue(all(float(v) == 0.0 for v in tree_values))
        default_values = re.findall(
            r"clock_tree_path;\s*cell_rise\(scalar\) {\s*" r'values\("([\d.]+)"\);',
            self.lib,
        )
        self.assertTrue(all(float(v) > 0.0 for v in default_values))

    def test_subword_memory_emits_every_lane(self):
        mem = detect.scan_text(SUBWORD_STYLE)[0]
        lib = liberty.emit_lib(mem, self.params)
        for lane in range(4):
            self.assertIn(f'bus ("W0_data_{lane}")', lib)
            self.assertIn(f'pin ("W0_data_{lane}[7]")', lib)
            # Scalar mask lanes are plain pins with constraints.
            self.assertIn(f'pin ("W0_mask_{lane}")', lib)

    def test_scalar_output_pin_gets_clocked_arc(self):
        mem = detect.scan_text(
            SUBWORD_STYLE.replace("output [7:0] R0_data_0", "output       R0_data_0")
        )[0]
        lib = liberty.emit_lib(mem, self.params)
        block = lib[lib.index('pin ("R0_data_0")') :]
        block = block[: block.index('bus ("R0_data_1")')]
        self.assertIn("timing_type : rising_edge;", block)


if __name__ == "__main__":
    unittest.main()
