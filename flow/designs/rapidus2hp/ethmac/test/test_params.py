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

        ParamTestBase.set_up(self, "ethmac")

    def test_pdk_0p2_default(self):
        """Tests PDK 0.2 Utilization - should be 70"""

        front_end = ""
        pdk_version = ""
        exp_util = 70
        for place_site in self._ibm_site_list:
            self.execute_cmd(
                place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
            )

    def test_pdk_0p2(self):
        """Tests PDK 0.2 Utilization - should be 70"""

        front_end = ""
        pdk_version = "0.2"
        exp_util = 70
        for place_site in self._ibm_site_list:
            self.execute_cmd(
                place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
            )

    def test_pdk_0p2a(self):
        """Tests PDK 0.2a Utilization - should be 70"""

        front_end = ""
        pdk_version = "0.2a"
        exp_util = 70
        for place_site in self._synopsys_site_list:
            self.execute_cmd(
                place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
            )

    def test_pdk_0p3(self):
        """Tests PDK 0.2a Utilization - should be 65"""

        front_end = ""
        pdk_version = "0.3"
        exp_util = 65
        for place_site in self._synopsys_site_list:
            self.execute_cmd(
                place_site, pdk_version, front_end, "CORE_UTILIZATION", exp_util
            )


if __name__ == "__main__":
    unittest.main()
