#!/usr/bin/env python3

import os
import sys
import unittest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "utils")))
from timing_data import TimingData


class TimingDataTest(unittest.TestCase):
    """Unit test for TimingData class"""

    def setUp(self):
        pass

    def check_caps_loads(self, timing_data, input_cap):
        self.assertEqual(timing_data.get_input_cap(), input_cap)
        self.assertEqual(timing_data.get_min_driver_input_cap(), input_cap)
        min_load = timing_data.get_min_load()
        max_load = timing_data.get_max_load()
        self.assertEqual(min_load, input_cap)
        self.assertEqual(max_load, input_cap * 100)
        self.assertEqual(
            timing_data.get_load_indices_str(), f"{min_load:.3f}, {max_load:.3f}"
        )

    def check_fo4_vals(self, timing_data, fo4_ps):
        self.assertEqual(timing_data.get_fo4_ps(), fo4_ps)
        self.assertEqual(timing_data.get_fo4(), fo4_ps * 1e-3)
        min_slew = timing_data.get_min_slew()
        max_slew = timing_data.get_max_slew()
        self.assertEqual(min_slew, fo4_ps * 1e-3)
        self.assertEqual(max_slew, fo4_ps * 1e-3 * 25)
        self.assertEqual(
            timing_data.get_slew_indices_str(), f"{min_slew:.3f}, {max_slew:.3f}"
        )

    def check_leakage_vals(self, timing_data, mw_val):
        self.assertEqual(timing_data.get_leakage_power_per_bank(), mw_val)
        self.assertEqual(timing_data.get_leakage_power(), mw_val * 1e3)

    def check_pin_dynamic_power_vals(self, timing_data, mw_val):
        self.assertEqual(timing_data.get_clkpin_dynamic_power(), mw_val * 1e3)
        self.assertEqual(timing_data.get_pin_dynamic_power(), mw_val * 1e1)
        self.assertEqual(timing_data.get_pin_dynamic_power_mw(), mw_val)

    def test_asap7(self):
        """Tests process fields based on asap7 defaults"""

        timing_data = TimingData(None)
        self.assertIsNotNone(timing_data)
        self.assertEqual(
            timing_data.get_setup_time(), timing_data._asap7_defaults["t_setup_ns"]
        )
        self.assertEqual(
            timing_data.get_hold_time(), timing_data._asap7_defaults["t_hold_ns"]
        )
        self.assertEqual(
            timing_data.get_access_time(), timing_data._asap7_defaults["access_time_ns"]
        )
        self.assertEqual(
            timing_data.get_cycle_time(), timing_data._asap7_defaults["cycle_time_ns"]
        )
        self.check_leakage_vals(
            timing_data, timing_data._asap7_defaults["standby_leakage_per_bank_mW"]
        )
        self.check_pin_dynamic_power_vals(
            timing_data, timing_data._asap7_defaults["pin_dynamic_power_mW"]
        )
        self.check_caps_loads(timing_data, timing_data._asap7_defaults["cap_input_pf"])
        self.check_fo4_vals(timing_data, timing_data._asap7_defaults["fo4_ps"])

    def test_full_override(self):
        """Tests when all input values are overridden"""

        new_data = {
            "t_setup_ns": 0.99,
            "t_hold_ns": 0.123,
            "standby_leakage_per_bank_mW": 0.456,
            "access_time_ns": 0.9745,
            "pin_dynamic_power_mW": 3.1415,
            "cap_input_pf": 0.009,
            "cycle_time_ns": 0.664,
            "fo4_ps": 10.0,
        }
        timing_data = TimingData(new_data)
        self.assertIsNotNone(timing_data)
        self.assertEqual(timing_data.get_setup_time(), new_data["t_setup_ns"])
        self.assertEqual(timing_data.get_hold_time(), new_data["t_hold_ns"])
        self.assertEqual(timing_data.get_access_time(), new_data["access_time_ns"])
        self.assertEqual(timing_data.get_cycle_time(), new_data["cycle_time_ns"])
        self.check_leakage_vals(timing_data, new_data["standby_leakage_per_bank_mW"])
        self.check_pin_dynamic_power_vals(timing_data, new_data["pin_dynamic_power_mW"])
        self.check_caps_loads(timing_data, new_data["cap_input_pf"])
        self.check_fo4_vals(timing_data, new_data["fo4_ps"])

    def test_partial_override(self):
        """Tests when only some of the values are overridden"""

        new_data = {
            "t_setup_ns": 0.99,
            "t_hold_ns": 0.123,
        }
        timing_data = TimingData(new_data)
        self.assertIsNotNone(timing_data)
        self.assertEqual(timing_data.get_setup_time(), new_data["t_setup_ns"])
        self.assertEqual(timing_data.get_hold_time(), new_data["t_hold_ns"])
        self.assertEqual(
            timing_data.get_access_time(), timing_data._asap7_defaults["access_time_ns"]
        )
        self.assertEqual(
            timing_data.get_cycle_time(), timing_data._asap7_defaults["cycle_time_ns"]
        )
        self.check_leakage_vals(
            timing_data, timing_data._asap7_defaults["standby_leakage_per_bank_mW"]
        )
        self.check_pin_dynamic_power_vals(
            timing_data, timing_data._asap7_defaults["pin_dynamic_power_mW"]
        )
        self.check_caps_loads(timing_data, timing_data._asap7_defaults["cap_input_pf"])
        self.check_fo4_vals(timing_data, timing_data._asap7_defaults["fo4_ps"])


if __name__ == "__main__":
    unittest.main()
