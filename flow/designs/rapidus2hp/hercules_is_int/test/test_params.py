#!/usr/bin/env python3

import os
import sys
import unittest

if __name__ == "__main__":
    util_dir = os.path.join(
        os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
        "utils",
    )
    sys.path.insert(0, util_dir)
from param_test_base import ParamTestBase


class TestParams(ParamTestBase):
    """Unit test for checking correct Makefile settings"""

    def setUp(self):
        """Sets up test variables"""

        ParamTestBase.set_up(self, "hercules_is_int")

    def get_exp_util(self, place_site, front_end, pdk_version):
        """Returns the expected value"""

        if pdk_version == "0.3":
            return 56
        if front_end == "verific":
            if place_site in ["SC6T", "ra02h138_DST_45CPP"]:
                return 30
            return 54
        else:
            if place_site in ["SC6T", "ra02h138_DST_45CPP"]:
                return 30
            return 52

    def test_pdk_0p2a_default(self):
        """
        Tests PDK 0.2a utilization
        """

        pdk_version = ""
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_util = self.get_exp_util(place_site, front_end, pdk_version)
                self.execute_cmd(
                    place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
                )

    def test_pdk_0p2(self):
        """
        Tests PDK 0.2 utilization
        """

        pdk_version = "0.2"
        for front_end in self._front_end_list:
            for place_site in self._ibm_site_list:
                exp_util = self.get_exp_util(place_site, front_end, pdk_version)
                self.execute_cmd(
                    place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
                )

    def test_pdk_0p2a(self):
        """
        Tests PDK 0.2a utilization
        """

        pdk_version = "0.2a"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_util = self.get_exp_util(place_site, front_end, pdk_version)
                self.execute_cmd(
                    place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
                )

    def test_pdk_0p15(self):
        """
        Tests PDK 0.15 utilization
        """

        pdk_version = "0.15"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_util = self.get_exp_util(place_site, front_end, pdk_version)
                self.execute_cmd(
                    place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
                )

    def test_pdk_0p3(self):
        """
        Tests PDK 0.3 utilization
        """

        pdk_version = "0.3"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_util = self.get_exp_util(place_site, front_end, pdk_version)
                self.execute_cmd(
                    place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
                )


if __name__ == "__main__":
    unittest.main()
