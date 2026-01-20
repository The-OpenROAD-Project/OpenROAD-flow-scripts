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

        ParamTestBase.set_up(self, "jpeg")

    def get_exp_sdc(self, place_site, pdk_version):
        """Returns the expected SDC file path"""

        if pdk_version in ["", "0.2a"]:
            if pdk_version == "":
                pdk_version = "0.2a"
            if place_site in ["", "ra02h184_HST_45CPP"]:
                return os.path.join(
                    self._design_full_dir, f"jpeg_encoder15_{pdk_version}_8T.sdc"
                )
        if pdk_version in ["0.15", "0.3"]:
            return os.path.join(
                self._design_full_dir, f"jpeg_encoder15_{pdk_version}.sdc"
            )
        return os.path.join(self._design_full_dir, "jpeg_encoder15_7nm.sdc")

    def test_pdk_0p2a_default(self):
        """
        Tests PDK 0.2a utilization
        """

        front_end = ""
        pdk_version = ""
        for place_site in self._synopsys_site_list:
            exp_sdc = self.get_exp_sdc(place_site, pdk_version)
            self.execute_cmd(place_site, pdk_version, front_end, "SDC_FILE", exp_sdc)

    def test_pdk_0p2(self):
        """
        Tests PDK 0.2 utilization
        """

        front_end = ""
        pdk_version = "0.2"
        for place_site in self._ibm_site_list:
            exp_sdc = self.get_exp_sdc(place_site, pdk_version)
            self.execute_cmd(place_site, pdk_version, front_end, "SDC_FILE", exp_sdc)

    def test_pdk_0p2a(self):
        """
        Tests PDK 0.2a utilization
        """

        front_end = ""
        pdk_version = "0.2a"
        for place_site in self._synopsys_site_list:
            exp_sdc = self.get_exp_sdc(place_site, pdk_version)
            self.execute_cmd(place_site, pdk_version, front_end, "SDC_FILE", exp_sdc)

    def test_pdk_0p15(self):
        """
        Tests PDK 0.15 utilization
        """

        front_end = ""
        pdk_version = "0.15"
        for place_site in self._synopsys_site_list:
            exp_sdc = self.get_exp_sdc(place_site, pdk_version)
            self.execute_cmd(place_site, pdk_version, front_end, "SDC_FILE", exp_sdc)

    def test_pdk_0p3(self):
        """
        Tests PDK 0.3 utilization
        """

        front_end = ""
        pdk_version = "0.3"
        for place_site in self._synopsys_site_list:
            exp_sdc = self.get_exp_sdc(place_site, pdk_version)
            self.execute_cmd(place_site, pdk_version, front_end, "SDC_FILE", exp_sdc)


if __name__ == "__main__":
    unittest.main()
