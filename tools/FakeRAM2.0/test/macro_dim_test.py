#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from class_process import Process
from test_utils import TestUtils


class MacroDimTest(unittest.TestCase):
    """Unit test for get_macro_dimensions method"""

    def setUp(self):
        """Sets up process object used by test methods"""

        self._process = Process(TestUtils.get_base_process_data())
        # delta for use when comparing floats
        self._delta = 0.01

    def test_macro_dim(self):
        """
        Tests basic macro dimension calculation based on three bank
        configurations
        """

        banks = [1, 2, 4]
        base_height = 663.552
        base_width = 5.054
        for num_banks in banks:
            sram_data = {
                "width": 39,
                "depth": 2048,
                "banks": num_banks,
            }
            width, height = self._process.get_macro_dimensions(
                sram_data["width"], sram_data["depth"], sram_data["banks"], 0
            )
            exp_height = base_height / num_banks
            exp_width = base_width * num_banks
            self.assertFalse(self._process.has_defined_bitcell_size())
            self.assertAlmostEqual(height, exp_height, delta=self._delta)
            self.assertAlmostEqual(width, exp_width, delta=self._delta)

    def test_macro_dim_add_height(self):
        """
        Tests basic macro dimension calculation based on three bank
        configurations
        """

        banks = [1, 2, 4]
        base_height = 663.552
        base_width = 5.054
        for num_banks in banks:
            sram_data = {
                "width": 39,
                "depth": 2048,
                "banks": num_banks,
                "additional_height": 10,
            }
            width, height = self._process.get_macro_dimensions(
                sram_data["width"],
                sram_data["depth"],
                sram_data["banks"],
                sram_data["additional_height"],
            )
            exp_height = (base_height / num_banks) + sram_data["additional_height"]
            exp_width = base_width * num_banks
            self.assertFalse(self._process.has_defined_bitcell_size())
            self.assertAlmostEqual(height, exp_height, delta=self._delta)
            self.assertAlmostEqual(width, exp_width, delta=self._delta)

    def test_macro_dim_invalid_banks(self):
        """Tests detection that an invalid bank value was given"""

        sram_data = {
            "width": 39,
            "depth": 2048,
            "banks": 8,
        }
        with self.assertRaises(Exception):
            width, height = self._process.get_macro_dimensions(
                sram_data["width"], sram_data["depth"], sram_data["banks"], 0
            )

    def test_macro_dim_bitcell_override(self):
        """Tests when bitcell dimensions are provided"""

        process_data = TestUtils.get_base_process_data().copy()
        process_data["bitcell_width_um"] = 123.0
        process_data["bitcell_height_um"] = 456.0
        process = Process(process_data)

        sram_data = {
            "width": 32,
            "depth": 256,
            "banks": 1,
        }
        exp_width = 4723.2
        exp_height = 140083.2
        width, height = process.get_macro_dimensions(
            sram_data["width"], sram_data["depth"], sram_data["banks"], 0
        )
        self.assertTrue(process.has_defined_bitcell_size())
        bitcell_width, bitcell_height = process.get_bitcell_dimensions()
        self.assertEqual(bitcell_width, process_data["bitcell_width_um"])
        self.assertEqual(bitcell_height, process_data["bitcell_height_um"])
        self.assertAlmostEqual(width, exp_width, delta=self._delta)
        self.assertAlmostEqual(height, exp_height, delta=self._delta)

    def _dimensions(self, column_mux_factor, width, depth, banks):
        """Macro dimensions, column_mux_factor None leaves the key out"""

        process_data = TestUtils.get_base_process_data().copy()
        del process_data["column_mux_factor"]
        if column_mux_factor is not None:
            process_data["column_mux_factor"] = column_mux_factor
        return Process(process_data).get_macro_dimensions(width, depth, banks, 0)

    def test_macro_dim_column_mux_picked(self):
        """An absent column_mux_factor folds a deep memory square"""

        # sqrt(512 / 17) = 5.5, the nearest power of two is 4
        picked = self._dimensions(None, 17, 512, 1)
        self.assertEqual(picked, self._dimensions(4, 17, 512, 1))
        width, height = picked
        self.assertLessEqual(max(width, height) / min(width, height), 8.0)

    def test_macro_dim_column_mux_explicit(self):
        """An explicit column_mux_factor is kept, even when it is a sliver"""

        width, height = self._dimensions(1, 17, 512, 1)
        self.assertGreater(height / width, 50.0)

    def test_macro_dim_column_mux_after_banks(self):
        """The factor is picked for the array banking leaves"""

        # 4 banks make 2048x39 a 512x156 array: sqrt(512 / 156) = 1.8,
        # so 2, where sqrt(2048 / 39) = 7.2 would have given 8
        self.assertEqual(
            self._dimensions(None, 39, 2048, 4), self._dimensions(2, 39, 2048, 4)
        )


if __name__ == "__main__":
    unittest.main()
