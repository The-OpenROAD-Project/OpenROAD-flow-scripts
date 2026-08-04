#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from class_process import Process


class ProcessTest(unittest.TestCase):
    """Unit test for Process class"""

    def setUp(self):
        """Sets up base_data with example config data"""

        self._base_data = {
            "tech_nm": 7,
            "voltage": 0.7,
            "metal_prefix": "M",
            "metal_layer": "M4",
            "pin_width_nm": 24,
            "pin_pitch_nm": 48,
            "metal_track_pitch_nm": 48,
            "contacted_poly_pitch_nm": 54,
            "column_mux_factor": 1,
            "fin_pitch_nm": 27,
            "manufacturing_grid_nm": 1,
            "snap_width_nm": 190,
            "snap_height_nm": 1400,
        }

    def test_process(self):
        """Tests process fields based on example config"""

        process = Process(self._base_data)
        self.assertIsNotNone(process)
        self.assertEqual(process.get_tech_nm(), self._base_data["tech_nm"])
        self.assertTrue(isinstance(process.get_voltage(), float))
        self.assertEqual(process.get_voltage(), self._base_data["voltage"])
        self.assertEqual(process.get_metal_prefix(), self._base_data["metal_prefix"])
        self.assertEqual(process.get_metal_layer(), self._base_data["metal_layer"])
        self.assertEqual(process.get_pin_width_nm(), self._base_data["pin_width_nm"])
        self.assertEqual(process.get_pin_pitch_nm(), self._base_data["pin_pitch_nm"])
        self.assertEqual(
            process.get_metal_track_pitch_nm(), self._base_data["metal_track_pitch_nm"]
        )
        self.assertEqual(
            process.get_contacted_poly_pitch(),
            self._base_data["contacted_poly_pitch_nm"],
        )
        self.assertEqual(process.get_fin_pitch(), self._base_data["fin_pitch_nm"])
        self.assertEqual(
            process.get_manufacturing_grid_nm(),
            self._base_data["manufacturing_grid_nm"],
        )
        self.assertEqual(process.get_snap_width_nm(), self._base_data["snap_width_nm"])
        self.assertEqual(
            process.get_snap_height_nm(), self._base_data["snap_height_nm"]
        )
        # check nm -> um
        self.assertEqual(process.get_tech_um(), process.get_tech_nm() / 1000.0)
        self.assertEqual(
            process.get_pin_width_um(), process.get_pin_width_nm() / 1000.0
        )
        self.assertEqual(
            process.get_pin_pitch_um(), process.get_pin_pitch_nm() / 1000.0
        )
        self.assertEqual(
            process.get_metal_track_pitch_um(),
            process.get_metal_track_pitch_nm() / 1000.0,
        )
        self.assertEqual(
            process.get_manufacturing_grid_um(),
            process.get_manufacturing_grid_nm() / 1000.0,
        )
        self.assertEqual(
            process.get_column_mux_factor(), self._base_data["column_mux_factor"]
        )

    def test_process_optional_snap(self):
        """Tests defaulting when snap_width and snap_height are not defined"""

        process_data = self._base_data.copy()
        del process_data["snap_width_nm"]
        del process_data["snap_height_nm"]
        process = Process(process_data)
        self.assertEqual(process.get_tech_nm(), self._base_data["tech_nm"])
        self.assertEqual(process.get_voltage(), float(self._base_data["voltage"]))
        self.assertEqual(process.get_metal_prefix(), self._base_data["metal_prefix"])
        self.assertEqual(process.get_metal_layer(), self._base_data["metal_layer"])
        self.assertEqual(process.get_pin_width_nm(), self._base_data["pin_width_nm"])
        self.assertEqual(process.get_pin_pitch_nm(), self._base_data["pin_pitch_nm"])
        self.assertEqual(
            process.get_metal_track_pitch_nm(), self._base_data["metal_track_pitch_nm"]
        )
        self.assertEqual(
            process.get_contacted_poly_pitch(),
            self._base_data["contacted_poly_pitch_nm"],
        )
        self.assertEqual(process.get_fin_pitch(), self._base_data["fin_pitch_nm"])
        self.assertEqual(
            process.get_manufacturing_grid_nm(),
            self._base_data["manufacturing_grid_nm"],
        )
        self.assertEqual(process.get_snap_width_nm(), 1)
        self.assertEqual(process.get_snap_height_nm(), 1)
        self.assertEqual(process.get_x_offset(), process.get_pin_pitch_um())
        self.assertEqual(process.get_y_offset(), process.get_pin_pitch_um())
        self.assertEqual(
            process.get_y_step(),
            process.get_y_offset()
            - (process.get_y_offset() % process.get_manufacturing_grid_um())
            + (process.get_pin_width_um() / 2.0),
        )

    def test_process_misaligned_pin_mfg_grid_pitch(self):
        """
        Tests detection that pin pitch is not a multiple of the metal track
        pitch
        """
        process_data = self._base_data.copy()
        process_data["pin_pitch_nm"] = 54
        process_data["metal_track_pitch_nm"] = 6
        process_data["manufacturing_grid_nm"] = 5

        with self.assertRaises(Exception):
            process = Process(process_data)

    def test_process_misaligned_pin_track_pitch(self):
        """
        Tests detection that pin pitch is not a multiple of the metal track
        pitch
        """

        process_data = self._base_data.copy()
        process_data["pin_pitch_nm"] = 54
        process_data["metal_track_pitch_nm"] = 5

        with self.assertRaises(Exception):
            process = Process(process_data)

    def test_bitcell_override(self):
        """Tests when bitcell size overrides computation"""

        process_data = self._base_data.copy()
        process_data["bitcell_width_um"] = 123.0
        process_data["bitcell_height_um"] = 456.0
        process = Process(process_data)

        self.assertTrue(process.has_defined_bitcell_size())
        (bitcell_width, bitcell_height) = process.get_bitcell_dimensions()
        self.assertEqual(bitcell_width, process_data["bitcell_width_um"])
        self.assertEqual(bitcell_height, process_data["bitcell_height_um"])

    def test_y_step_calc(self):
        """
        Tests y_step calculation

        y_step = pin_pitch (snapped to grid) + pin_width / 2
        """

        process = Process(self._base_data)
        process._calc_y_step()
        # 0.048 + (0.024 / 2) = 0.06
        self.assertEqual(process.get_y_step(), 0.06)

        # change to different pitch that previously didn't get snapped right
        # and try again
        base_data = self._base_data.copy()
        base_data["metal_track_pitch_nm"] = 23
        base_data["pin_pitch_nm"] = 2 * base_data["metal_track_pitch_nm"]
        base_data["pin_width_nm"] = 12
        process = Process(base_data)
        # 0.046 + (0.024 / 2) = 0.06
        process._calc_y_step()
        self.assertEqual(process.get_y_step(), 0.052)


if __name__ == "__main__":
    unittest.main()
