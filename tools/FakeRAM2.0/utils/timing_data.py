#!/usr/bin/env python3


class TimingData:
    """Class to hold timing-related data used in Liberty file generation"""

    def __init__(self, json_data=None):
        """
        Initializer sets the timing data attributes if they are defined in the
        JSON data passed in. Otherwise, it uses the ASAP7 defaults
        """

        self._asap7_defaults = {
            "t_setup_ns": 0.050,
            # arbitrary 50ps setup
            "t_hold_ns": 0.050,
            # arbitrary 50ps hold
            "standby_leakage_per_bank_mW": 0.1289,
            "access_time_ns": 0.2183,
            "pin_dynamic_power_mW": 0.0013449,
            "cap_input_pf": 0.005,
            "cycle_time_ns": 0.1566,
            "fo4_ps": 9.0632,
        }

        for attr_name, value in self._asap7_defaults.items():
            if json_data and attr_name in json_data:
                setattr(self, attr_name, float(json_data[attr_name]))
            else:
                setattr(self, attr_name, value)

        # TODO: Arbitrary indices for the NLDM table. This is used for Clk->Q
        # arcs as well as setup/hold times. We only have a single value for
        # these, there are two options.
        #     1. adding some sort of static variation of the single value for
        #        each table entry,
        #     2. use the same value so all interpolated values are the same.
        # The 1st is more realistic but depend on good variation values which
        # is process specific and I don't have a strategy for determining decent
        # variation values without breaking NDA so right now we have no
        # variations.
        #
        # The table indices are main min/max values for interpolation. The tools
        # typically don't like extrapolation so a large range is nice, but makes
        # the single value strategy described above even more unrealistic.
        #
        # convert from ps to fs
        self.fo4 = float(self.fo4_ps) / 1e3

        # convert from mW to W
        self.clkpin_dynamic_power = self.pin_dynamic_power_mW * 1e3
        self.leakage = self.standby_leakage_per_bank_mW * 1e3
        self.pin_dynamic = self.pin_dynamic_power_mW * 1e1

        # arbitrary (1x fo4, fear that 0 would cause issues)
        self.min_slew = 1 * self.fo4
        # arbitrary (25x fo4 as ~100x fanout ... i know that is not really how
        # it works)
        self.max_slew = 25 * self.fo4

        self.min_driver_in_cap = self.cap_input_pf
        # arbitrary (1x driver, fear that 0 would cause issues)
        self.min_load = 1 * self.min_driver_in_cap
        # arbitrary (100x driver)
        self.max_load = 100 * self.min_driver_in_cap

        # input pin transition with between 1xfo4 and 100xfo4
        self.slew_indices = "%.3f, %.3f" % (self.min_slew, self.max_slew)
        # output capacitance table between a 1x and 32x inverter
        self.load_indices = "%.3f, %.3f" % (self.min_load, self.max_load)

    def get_setup_time(self):
        """Returns the setup time in ns"""
        return self.t_setup_ns

    def get_hold_time(self):
        """Returns the hold time in ns"""
        return self.t_hold_ns

    def get_access_time(self):
        """Returns the access time in ns"""
        return self.access_time_ns

    def get_cycle_time(self):
        """Returns the cycle time in ns"""
        return self.cycle_time_ns

    def get_fo4(self):
        """Returns the fo4 in fs"""
        return self.fo4

    def get_fo4_ps(self):
        """Returns the fo4 in ps"""
        return self.fo4_ps

    def get_clkpin_dynamic_power(self):
        """Returns the clkpin dynamic power in W"""
        return self.clkpin_dynamic_power

    def get_leakage_power(self):
        """Returns the standby leakage power in W"""
        return self.leakage

    def get_leakage_power_per_bank(self):
        """Returns the standby leakage power per bank in mW"""
        return self.standby_leakage_per_bank_mW

    def get_pin_dynamic_power(self):
        """Returns the pin dynamic power in mW * 10"""
        return self.pin_dynamic

    def get_pin_dynamic_power_mw(self):
        """Returns the pin dynamic power in mW"""
        return self.pin_dynamic_power_mW

    def get_min_slew(self):
        """Returns the min slew"""
        return self.min_slew

    def get_max_slew(self):
        """Returns the max slew"""
        return self.max_slew

    def get_min_driver_input_cap(self):
        """Returns the minimum driver input capacitance in pF"""
        # TODO: consolidate min_driver_in_cap and cap_input_pf
        return self.min_driver_in_cap

    def get_input_cap(self):
        """Returns the input capacitance in pF"""
        # TODO: consolidate min_driver_in_cap and cap_input_pf
        return self.cap_input_pf

    def get_min_load(self):
        """Returns the min load in pF"""
        return self.min_load

    def get_max_load(self):
        """Returns the max load in pF"""
        return self.max_load

    def get_slew_indices_str(self):
        """Returns the slew indices string"""
        return self.slew_indices

    def get_load_indices_str(self):
        """Returns the load indices string"""
        return self.load_indices
