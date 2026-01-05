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

        ParamTestBase.set_up(self, "cva6")

    def test_pdk_0p2_default(self):
        """Tests PDK 0.2 SDC file - should be default for both 6T and 8T"""

        pdk_version = ""
        exp_sdc = os.path.join(self._design_full_dir, "constraint.sdc")
        for front_end in self._front_end_list:
            for place_site in self._ibm_site_list:
                self.execute_cmd(
                    place_site, pdk_version, front_end, "SDC_FILE", exp_sdc
                )

    def test_pdk_0p2(self):
        """Tests PDK 0.2 SDC file - should be default for both 6T and 8T"""

        pdk_version = "0.2"
        exp_sdc = os.path.join(self._design_full_dir, "constraint.sdc")
        for front_end in self._front_end_list:
            for place_site in self._ibm_site_list:
                self.execute_cmd(
                    place_site, pdk_version, front_end, "SDC_FILE", exp_sdc
                )

    def test_pdk_0p2a(self):
        """
        Tests PDK 0.2a SDC file
        6T: constraint_0.2a_6T.sdc
        8T: constraint_0.2a_8T.sdc
        """

        pdk_version = "0.2a"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                if place_site == "":
                    track_height = "8T"
                else:
                    track_height = self.get_track_height(place_site)
                exp_sdc = os.path.join(
                    self._design_full_dir,
                    f"constraint_{pdk_version}_{track_height}.sdc",
                )
                self.execute_cmd(
                    place_site, pdk_version, front_end, "SDC_FILE", exp_sdc
                )

    def test_pdk_0p3(self):
        """
        Tests PDK 0.3 SDC file
        6T: constraint_0.3_6T.sdc
        8T: constraint_0.3_8T.sdc
        """

        pdk_version = "0.3"
        for front_end in self._front_end_list:
            for place_site in self._synopsys_site_list:
                if place_site == "":
                    track_height = "8T"
                else:
                    track_height = self.get_track_height(place_site)
                exp_sdc = os.path.join(
                    self._design_full_dir, f"constraint_0.3_{track_height}.sdc"
                )
                self.execute_cmd(
                    place_site, pdk_version, front_end, "SDC_FILE", exp_sdc
                )


if __name__ == "__main__":
    unittest.main()
