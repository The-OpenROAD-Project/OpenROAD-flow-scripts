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

        ParamTestBase.setUp(self, "hercules_idecode")

    def get_exp_util(self, place_site, pdk_version, front_end):
        """Returns the expected value"""

        if front_end == "verific":
            if place_site in ["SC6T", "ra02h138_DST_45CPP"]:
                return 43
            return 48
        else:
            if place_site in ["SC6T", "ra02h138_DST_45CPP"]:
                if pdk_version == "0.15":
                    return 42
                return 44
            return 50

    def test_pdk_0p3_default(self):
        """
        Tests PDK 0.3 utilization
        """

        pdk_version = ""
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                exp_util = self.get_exp_util(place_site, pdk_version, front_end)
                self.execute_cmd(
                    "CORE_UTILIZATION",
                    exp_util,
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
                exp_util = self.get_exp_util(place_site, pdk_version, front_end)
                self.execute_cmd(
                    "CORE_UTILIZATION",
                    exp_util,
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
                exp_util = self.get_exp_util(place_site, pdk_version, front_end)
                self.execute_cmd(
                    "CORE_UTILIZATION",
                    exp_util,
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
                exp_util = self.get_exp_util(place_site, pdk_version, front_end)
                self.execute_cmd(
                    "CORE_UTILIZATION",
                    exp_util,
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
                exp_util = self.get_exp_util(place_site, pdk_version, front_end)
                self.execute_cmd(
                    "CORE_UTILIZATION",
                    exp_util,
                    place_site=place_site,
                    pdk_version=pdk_version,
                    front_end=front_end,
                )

    def test_flow_variant(self):
        """Tests that setting the flow variant uses the right frontend"""

        test_tag = "flow_variant default"
        cmd = self.build_cmd("SYNTH_HDL_FRONTEND")
        self.execute_cmd_int(cmd, test_tag, "slang")
        test_tag = "flow_variant verific"
        cmd = self.build_cmd("SYNTH_HDL_FRONTEND", flow_variant="verific")
        self.execute_cmd_int(cmd, test_tag, "verific")


if __name__ == "__main__":
    unittest.main()
