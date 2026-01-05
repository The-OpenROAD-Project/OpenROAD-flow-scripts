#!/usr/bin/env python3

import os
import re
import subprocess
import unittest

class TestParams(unittest.TestCase):
    """ Unit test for checking correct Makefile settings """
    
    def setUp(self):
        """ Sets up test variables """
        
        self._cmd_base = "make DESIGN_CONFIG=designs/rapidus2hp/cva6/config.mk"
        self._pwd = os.getcwd()
        self._design_dir = os.path.join(self._pwd, "designs/rapidus2hp/cva6")
        self._result_re = re.compile(r"\S+\s+\=\s+(\S+)")
        self._ibm_site_list = ["", "SC6T", "SC8T"]
        self._synopsys_site_list = ["", "ra02h138_DST_45CPP", "ra02h138_DST_45CPP"]

    def _get_track_height(self, place_site):
        """ Returns the track height for the place site """
        
        if place_site.startswith("SC"):
            return place_site[2:]
        if place_site == "ra02h138_DST_45CPP":
            return "6T"
        return "8T"
            
    def test_pdk_0p2_default(self):
        """ Tests PDK 0.2 SDC file - should be default for both 6T and 8T """
        
        exp_value = os.path.join(self._design_dir, "constraint.sdc")
        for place_site in self._ibm_site_list:
            if place_site == "":
                cmd = f"{self._cmd_base} print-SDC_FILE"
            else:
                cmd = f"{self._cmd_base} PLACE_SITE={place_site} print-SDC_FILE"
            out = subprocess.run(cmd, check=True, shell=True,
                                 capture_output=True, text=True)
            self.assertEqual(out.returncode, 0)
            result = self._result_re.match(out.stdout)
            self.assertIsNotNone(result)
            value = result.group(1)
            self.assertEqual(value, exp_value)

    def test_pdk_0p2(self):
        """ Tests PDK 0.2 SDC file - should be default for both 6T and 8T """
        exp_value = os.path.join(self._design_dir, "constraint.sdc")
        for place_site in self._ibm_site_list:
            if place_site == "":
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.2 print-SDC_FILE"
            else:
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.2 PLACE_SITE={place_site} print-SDC_FILE"
            out = subprocess.run(cmd, check=True, shell=True,
                                 capture_output=True, text=True)
            self.assertEqual(out.returncode, 0)
            result = self._result_re.match(out.stdout)
            self.assertIsNotNone(result)
            value = result.group(1)
            self.assertEqual(value, exp_value)

    def test_pdk_0p2a(self):
        """
        Tests PDK 0.2a SDC file
        6T: constraint_0.2a_6T.sdc
        8T: constraint_0.2a_8T.sdc
        """
        
        for place_site in self._synopsys_site_list:
            if place_site == "":
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.2a print-SDC_FILE"
                exp_value = os.path.join(self._design_dir, "constraint_0.2a_8T.sdc")
            else:
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.2a PLACE_SITE={place_site} print-SDC_FILE"
                track_height = self._get_track_height(place_site)
                exp_value = os.path.join(self._design_dir,
                                         f"constraint_0.2a_{track_height}.sdc")
            out = subprocess.run(cmd, check=True, shell=True,
                                 capture_output=True, text=True)
            self.assertEqual(out.returncode, 0)
            result = self._result_re.match(out.stdout)
            self.assertIsNotNone(result)
            value = result.group(1)
            self.assertEqual(value, exp_value)

    def test_pdk_0p3(self):
        """
        Tests PDK 0.3 SDC file
        6T: constraint_0.3_6T.sdc
        8T: constraint_0.3_8T.sdc
        """
        
        for place_site in self._synopsys_site_list:
            if place_site == "":
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.3 print-SDC_FILE"
                exp_value = os.path.join(self._design_dir, "constraint_0.3_8T.sdc")
            else:
                cmd = f"{self._cmd_base} RAPIDUS_PDK_VERSION=0.3 PLACE_SITE={place_site} print-SDC_FILE"
                track_height = self._get_track_height(place_site)
                exp_value = os.path.join(self._design_dir,
                                         f"constraint_0.3_{track_height}.sdc")
            out = subprocess.run(cmd, check=True, shell=True,
                                 capture_output=True, text=True)
            self.assertEqual(out.returncode, 0)
            result = self._result_re.match(out.stdout)
            self.assertIsNotNone(result)
            value = result.group(1)
            self.assertEqual(value, exp_value)
            
if __name__ == "__main__":
    unittest.main()
    

    
