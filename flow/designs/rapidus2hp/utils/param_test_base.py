#!/usr/bin/env python3

import os
import re
import subprocess
import unittest


class ParamTestBase(unittest.TestCase):
    """Base class for testing params"""

    def setUp(self, design_name):
        """
        Sets up common member variables.
        Assumes we're running in flow directory
        """

        self._platform = "rapidus2hp"
        self._design = design_name
        self._design_dir = os.path.join("designs", self._platform, self._design)
        self._cmd_base = f"make DESIGN_CONFIG={self._design_dir}/config.mk"
        self._design_full_dir = os.path.join(os.getcwd(), self._design_dir)
        # Handle different make output
        #   param: value
        #   param = value
        self._result_re = re.compile(r"\S+\s*(?:=|:)\s*(\S+)?")
        self._front_end_list = ["", "slang", "verific"]
        self._ibm_site_list = ["", "SC6T", "SC8T"]
        self._synopsys_site_list = ["", "ra02h138_DST_45CPP", "ra02h184_HST_45CPP"]
        self._layer_stack_list = ["", "14LM", "16LM", "18LM", "20LM"]

    def get_track_height(self, place_site):
        """Returns the track height for the place site"""

        if place_site.startswith("SC"):
            return place_site[2:]
        if place_site == "ra02h138_DST_45CPP":
            return "6T"
        return "8T"

    def build_cmd(
        self,
        param_name,
        place_site=None,
        pdk_version=None,
        front_end=None,
        flow_variant=None,
        layer_stack=None,
    ):
        """Builds the command to execute"""

        str_buf = [self._cmd_base]
        if place_site and place_site != "":
            str_buf.append(f"PLACE_SITE={place_site}")
        if pdk_version and pdk_version != "":
            str_buf.append(f"RAPIDUS_PDK_VERSION={pdk_version}")
        if front_end and front_end == "verific":
            str_buf.append(f"SYNTH_HDL_FRONTEND={front_end}")
        if layer_stack and layer_stack != "":
            str_buf.append(f"LAYER_STACK_OPTION={layer_stack}")
        if flow_variant and flow_variant != "":
            str_buf.append(f"FLOW_VARIANT={flow_variant}")
        str_buf.append(f"print-{param_name}")
        return " ".join(str_buf)

    def execute_cmd(
        self,
        param_name,
        exp_result,
        place_site=None,
        pdk_version=None,
        front_end=None,
        layer_stack=None,
        debug=False,
    ):
        """
        Executes command
        """

        test_tag = f"'{place_site}' '{pdk_version}' '{front_end}'"
        cmd = self.build_cmd(
            param_name,
            place_site=place_site,
            pdk_version=pdk_version,
            front_end=front_end,
            layer_stack=layer_stack,
        )
        if debug:
            print(cmd)
        self.execute_cmd_int(cmd, test_tag, exp_result)

    def execute_cmd_int(self, cmd, test_tag, exp_result):
        """
        Executes command
          check if return code is 0
          check if value matches expected result
        """

        out = subprocess.run(
            cmd, check=True, shell=True, capture_output=True, text=True
        )
        self.assertEqual(out.returncode, 0, f"Return code for {test_tag} is non-zero")
        stdout_str = out.stdout.rstrip()
        result = self._result_re.match(stdout_str)
        self.assertIsNotNone(result, f"RE result {test_tag} is None")
        value = result.group(1)
        if isinstance(exp_result, int):
            value = int(value)
        self.assertEqual(value, exp_result, f"Results for {test_tag} don't match")
