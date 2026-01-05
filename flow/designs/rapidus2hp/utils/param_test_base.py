#!/usr/bin/env python3

import os
import re
import subprocess
import unittest


class ParamTestBase(unittest.TestCase):
    """Base class for testing params"""

    def set_up(self, design_name):
        """
        Sets up common member variables.
        Assumes we're running in flow directory
        """

        self._platform = "rapidus2hp"
        self._design = design_name
        self._design_dir = os.path.join("designs", self._platform, self._design)
        self._design_full_dir = os.path.join(os.getcwd(), self._design_dir)
        self._cmd_base = f"make DESIGN_CONFIG={self._design_dir}/config.mk"
        self._result_re = re.compile(r"\S+\s+\=\s+(\S+)")
        self._front_end_list = ["", "slang", "verific"]
        self._ibm_site_list = ["", "SC6T", "SC8T"]
        self._synopsys_site_list = ["", "ra02h138_DST_45CPP", "ra02h138_DST_45CPP"]

    def get_track_height(self, place_site):
        """Returns the track height for the place site"""

        if place_site.startswith("SC"):
            return place_site[2:]
        if place_site == "ra02h138_DST_45CPP":
            return "6T"
        return "8T"

    def build_cmd(self, place_site, pdk_version, front_end, param_name):
        """Builds the command to execute"""

        str_buf = [self._cmd_base]
        if place_site != "":
            str_buf.append(f"PLACE_SITE={place_site}")
        if pdk_version != "":
            str_buf.append(f"RAPIDUS_PDK_VERSION={pdk_version}")
        if front_end == "verific":
            str_buf.append(f"SYNTH_HDL_FRONTEND={front_end}")
        str_buf.append(f"print-{param_name}")
        return " ".join(str_buf)

    def execute_cmd(self, place_site, pdk_version, front_end, param_name, exp_result):
        """
        Executes command
          check if return code is 0
          check if value matches expected result
        """

        test_tag = f"'{place_site}' '{pdk_version}' '{front_end}'"
        cmd = self.build_cmd(place_site, pdk_version, front_end, param_name)
        out = subprocess.run(
            cmd, check=True, shell=True, capture_output=True, text=True
        )
        self.assertEqual(out.returncode, 0, f"Return code for {test_tag} is non-zero")
        result = self._result_re.match(out.stdout)
        self.assertIsNotNone(result, f"RE result {test_tag} is None")
        value = result.group(1)
        if isinstance(exp_result, int):
            value = int(value)
        self.assertEqual(value, exp_result, f"Results for {test_tag} don't match")
