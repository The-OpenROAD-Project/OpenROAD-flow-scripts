#!/usr/bin/env python3

import re
import os
import math
import shutil
import unittest
import subprocess
from collections import Counter
from test_utils import TestUtils


class FlowTest(unittest.TestCase):
    """Flow test for fakeram"""

    def setUp(self):
        """Sets up paths and REs to validate results"""

        self._test_dir = os.path.abspath(os.path.dirname(__file__))
        self._script_dir = os.path.abspath(os.path.join(self._test_dir, ".."))
        self._exec = os.path.join(self._script_dir, "run.py")
        self._results_dir = os.path.join(self._test_dir, "results")
        if os.path.isdir(self._results_dir):
            shutil.rmtree(self._results_dir)
        self._macro_re = re.compile(r"^MACRO\s+(\S+)")
        self._size_re = re.compile(r"^\s+SIZE\s+(\S+)\s+BY\s+(\S+)")
        self._start_pin_re = re.compile(r"^\s+PIN\s+(\S+)")
        self._macro_name_re = re.compile(r"\S+_(\d+)x(\d+)")
        self._pin_dir_re = re.compile(r"^\s*DIRECTION\s+(\S+)")

    def _getLefPin(self, fh, pin_name):
        """Extracts data for given LEF pin and returns it in a dict"""

        pin_data = {}
        end_line = "  END " + pin_name
        while True:
            line = fh.readline()
            if not line:  # pragma: no cover
                return pin_data
            line = line.rstrip()
            if line == end_line:
                return pin_data
            elif line == "    PORT":
                line = fh.readline()
                pin_data["layer"] = line.split()[1]
                line = fh.readline()
                pin_data["rect"] = list(map(float, line.split()[1:-1]))
            else:
                result = self._pin_dir_re.match(line)
                if result:
                    pin_data["dir"] = result.group(1)

    def _getLefData(self, ram_file):
        """Extracts data from LEF and returns it in a dict"""

        lef_data = {"pins": {}}
        with open(ram_file, "r") as fh:
            for line in fh:
                result = self._macro_re.match(line)
                if result:
                    lef_data["macro_name"] = result.group(1)
                else:
                    result = self._size_re.match(line)
                    if result:
                        lef_data["width"] = float(result.group(1))
                        lef_data["height"] = float(result.group(2))
                    else:
                        result = self._start_pin_re.match(line)
                        if result:
                            pin_name = result.group(1)
                            lef_data["pins"][pin_name] = self._getLefPin(fh, pin_name)
        return lef_data

    def _checkPinShape(
        self, mem_name, pin_name, pin_data, current_x, current_y, pin_width, layer_name
    ):
        self.assertEqual(
            pin_data["layer"],
            layer_name,
            f"{mem_name} {pin_name}'s layer is not {layer_name}: {pin_data['layer']}",
        )
        expected_rect = [
            current_x,
            round(current_y, 3),
            current_x + pin_width,
            round(current_y + pin_width, 3),
        ]
        self.assertListEqual(
            expected_rect,
            pin_data["rect"],
            f"{mem_name} {pin_name}'s rect is not {expected_rect}: {pin_data['rect']}",
        )

    def _checkLef(self, ram_file, mem_width, mem_depth):
        """Checks the LEF data against expected values for a given RAM"""

        lef_data = self._getLefData(ram_file)
        macro_name = lef_data["macro_name"]
        self.assertEqual(macro_name, "fakeram7_2048x39")
        self.assertAlmostEqual(lef_data["width"], 20.33, places=3)
        self.assertAlmostEqual(lef_data["height"], 166.6, places=3)
        pin_layer = "M4"
        pin_width = 0.024  # from config
        pin_spacing = 1.776  # config pin_pitch * calculated track count
        pin_group_spacing = 1.008  # config pin pitch * extra tracks
        read_pin_ct = write_pin_ct = mem_depth
        write_enable_ct = read_enable_ct = clk_ct = 1
        addr_pin_ct = math.log2(mem_width)
        power_pin_ct = 2
        total_pin_ct = (
            read_pin_ct
            + write_pin_ct
            + write_enable_ct
            + read_enable_ct
            + clk_ct
            + addr_pin_ct
            + power_pin_ct
        )
        self.assertEqual(len(lef_data["pins"].keys()), total_pin_ct)
        read_pins = [key for key in lef_data["pins"] if key.startswith("rd_out")]
        write_pins = [key for key in lef_data["pins"] if key.startswith("wd_in")]
        addr_pins = [key for key in lef_data["pins"] if key.startswith("addr_in")]
        self.assertEqual(len(read_pins), read_pin_ct)
        self.assertEqual(len(write_pins), write_pin_ct)
        self.assertEqual(len(addr_pins), addr_pin_ct)
        total_inputs = (
            read_pin_ct + write_enable_ct + read_enable_ct + clk_ct + addr_pin_ct
        )
        total_outputs = write_pin_ct
        total_inouts = power_pin_ct
        dir_counts = Counter(entry["dir"] for entry in lef_data["pins"].values())
        self.assertEqual(total_inputs, dir_counts["INPUT"])
        self.assertEqual(total_outputs, dir_counts["OUTPUT"])
        self.assertEqual(total_inouts, dir_counts["INOUT"])
        ct = 0
        current_x = 0
        current_y = pin_width * 2
        for pin_name in read_pins:
            self._checkPinShape(
                macro_name,
                pin_name,
                lef_data["pins"][pin_name],
                current_x,
                current_y,
                pin_width,
                pin_layer,
            )
            ct += 1
            current_y += pin_spacing
        current_y += pin_group_spacing
        for pin_name in write_pins:
            self._checkPinShape(
                macro_name,
                pin_name,
                lef_data["pins"][pin_name],
                current_x,
                current_y,
                pin_width,
                pin_layer,
            )
            ct += 1
            current_y += pin_spacing
        current_y += pin_group_spacing
        for pin_name in addr_pins:
            self._checkPinShape(
                macro_name,
                pin_name,
                lef_data["pins"][pin_name],
                current_x,
                current_y,
                pin_width,
                pin_layer,
            )
            current_y += pin_spacing
        current_y += pin_group_spacing
        self._checkPinShape(
            macro_name,
            "we_in",
            lef_data["pins"]["we_in"],
            current_x,
            current_y,
            pin_width,
            pin_layer,
        )
        current_y += pin_spacing
        self._checkPinShape(
            macro_name,
            "clk",
            lef_data["pins"]["clk"],
            current_x,
            current_y,
            pin_width,
            pin_layer,
        )
        current_y += pin_spacing
        self._checkPinShape(
            macro_name,
            "ce_in",
            lef_data["pins"]["ce_in"],
            current_x,
            current_y,
            pin_width,
            pin_layer,
        )
        current_y += pin_spacing
        # Skip checking power pins

    def _checkResultsDir(self):
        """Checks that the expected RAMs were generated"""
        expected_ram_list = [
            "fakeram7_2048x39",
            "fakeram7_256x32",
            "fakeram7_256x34",
            "fakeram7_64x21",
            "fakeram_256x128",
            "fakeram_256x64",
            "fakeram_32x46",
            "fakeram_512x8",
            "fakeram_64x20",
            "fakeram_64x22",
        ]
        self.assertTrue(os.path.isdir(self._results_dir))
        self.assertListEqual(sorted(os.listdir(self._results_dir)), expected_ram_list)
        ct = 0
        for ram_name in expected_ram_list:
            lef_file = os.path.join(self._results_dir, ram_name, ram_name + ".lef")
            verilog_file = os.path.join(self._results_dir, ram_name, ram_name + ".v")
            liberty_file = os.path.join(self._results_dir, ram_name, ram_name + ".lib")
            self.assertTrue(os.path.exists(lef_file), f"{lef_file} doesn't exist")
            self.assertTrue(
                os.path.exists(verilog_file), f"{verilog_file} doesn't exist"
            )
            self.assertTrue(
                os.path.exists(liberty_file), f"{liberty_file} doesn't exist"
            )
            if ct == 0:
                results = self._macro_name_re.match(ram_name)
                mem_width = int(results.group(1))
                mem_depth = int(results.group(2))
                self._checkLef(lef_file, mem_width, mem_depth)
            ct += 1

    def test_example_input(self):
        """Tests the example input run"""

        exec_cmd = TestUtils.get_exec_name(self._exec)
        cmd = (
            exec_cmd
            + " "
            + os.path.join(self._script_dir, "example_input_file.cfg")
            + " --output_dir "
            + self._results_dir
        )
        out = subprocess.run(cmd, check=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self._checkResultsDir()


if __name__ == "__main__":
    unittest.main()
