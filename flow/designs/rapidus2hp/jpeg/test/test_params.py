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

        ParamTestBase.setUp(self, "jpeg")

    def get_exp_sdc(self, place_site, pdk_version):
        """Returns the expected SDC file path"""

        if pdk_version == "0.2a":
            if place_site in ["", "ra02h184_HST_45CPP"]:
                return os.path.join(
                    self._design_full_dir, f"jpeg_encoder15_{pdk_version}_8T.sdc"
                )
        if pdk_version == "0.15":
            if place_site in ["", "ra02h184_HST_45CPP"]:
                return os.path.join(
                    self._design_full_dir, f"jpeg_encoder15_{pdk_version}_8T.sdc"
                )
            return os.path.join(
                self._design_full_dir, f"jpeg_encoder15_{pdk_version}_6T.sdc"
            )
        if pdk_version in ["", "0.3"]:
            if pdk_version == "":
                pdk_version = "0.3"
            return os.path.join(
                self._design_full_dir, f"jpeg_encoder15_{pdk_version}.sdc"
            )
        return os.path.join(self._design_full_dir, "jpeg_encoder15_7nm.sdc")

    def test_pdk_0p3_default(self):
        """
        Tests PDK 0.3 utilization
        """

        pdk_version = ""
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_sdc = self.get_exp_sdc(place_site, pdk_version)
                self.execute_cmd(
                    "SDC_FILE",
                    exp_sdc,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_pdk_0p2(self):
        """
        Tests PDK 0.2 utilization
        """

        pdk_version = "0.2"
        for front_end in self._front_end_list:
            for place_site in self._ibm_site_list:
                exp_sdc = self.get_exp_sdc(place_site, pdk_version)
                self.execute_cmd(
                    "SDC_FILE",
                    exp_sdc,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_pdk_0p2a(self):
        """
        Tests PDK 0.2a utilization
        """

        pdk_version = "0.2a"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_sdc = self.get_exp_sdc(place_site, pdk_version)
                self.execute_cmd(
                    "SDC_FILE",
                    exp_sdc,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_pdk_0p15(self):
        """
        Tests PDK 0.15 utilization
        """

        pdk_version = "0.15"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_sdc = self.get_exp_sdc(place_site, pdk_version)
                self.execute_cmd(
                    "SDC_FILE",
                    exp_sdc,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_pdk_0p3(self):
        """
        Tests PDK 0.3 utilization
        """

        pdk_version = "0.3"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_sdc = self.get_exp_sdc(place_site, pdk_version)
                self.execute_cmd(
                    "SDC_FILE",
                    exp_sdc,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_flow_variant(self):
        """Tests that setting the flow variant uses the right frontend"""

        test_tag = "flow_variant default"
        cmd = self.build_cmd("SYNTH_HDL_FRONTEND")
        self.execute_cmd_int(cmd, test_tag, None)
        test_tag = "flow_variant verific"
        cmd = self.build_cmd("SYNTH_HDL_FRONTEND", flow_variant="verific")
        self.execute_cmd_int(cmd, test_tag, "verific")


if __name__ == "__main__":
    unittest.main()
