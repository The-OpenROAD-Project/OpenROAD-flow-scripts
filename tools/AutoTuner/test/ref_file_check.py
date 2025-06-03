#############################################################################
##
## Copyright (c) 2024, Precision Innovations Inc.
## All rights reserved.
##
## BSD 3-Clause License
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and/or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
###############################################################################

import unittest
import subprocess
import os
from .autotuner_test_utils import AutoTunerTestUtils

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src")
orfs_dir = os.path.join(cur_dir, "../../../flow")
os.chdir(src_dir)


class RefFileCheck(unittest.TestCase):
    """
    Tests situations where a referenced file (SDC or FastRoute) is not
    defined in the AutoTuner config
    """

    def setUp(self):
        self._cur_dir = os.path.dirname(os.path.abspath(__file__))
        src_dir = os.path.join(self._cur_dir, "../src")
        os.chdir(src_dir)

        self._exec = AutoTunerTestUtils.get_exec_cmd()

    def _execute_autotuner(self, platform, design, config_file, error_code=None):
        full_path = os.path.abspath(os.path.join(self._cur_dir, config_file))

        cmd = f"{self._exec} --design {design} --platform {platform} --config {full_path} tune --samples 1"

        out = subprocess.run(cmd, shell=True, text=True, capture_output=True)
        failed = out.returncode != 0
        self.assertTrue(failed, f"AT run with {config_file} passed")
        if error_code:
            self.assertTrue(
                error_code in out.stdout,
                f"Didn't find error code {error_code} in output '{out.stdout}'",
            )

    def test_asap_gcd_no_sdc(self):
        """
        Tests when SDC file is not defined, which is an error for all
        platforms and designs
        """

        platform = "asap7"
        design = "gcd"
        config_file = "files/no_sdc_ref.json"
        error_code = "[ERROR TUN-0020] No SDC reference"
        self._execute_autotuner(platform, design, config_file, error_code)

    def test_asap_gcd_no_fr(self):
        """
        Tests when FastRoute file is not defined, which is not an error for
        asap platform. This test fails anyway
        """

        platform = "asap7"
        design = "gcd"
        config_file = "files/no_fr_ref.json"
        self._execute_autotuner(platform, design, config_file)

    def test_ihp_gcd_no_fr(self):
        """
        Tests when FastRoute file is not defined, which is not an error for
        any non-asap7 platform.
        """

        platform = "ihp-sg13g2"
        design = "gcd"
        config_file = "files/no_fr_ref.json"
        error_code = "[ERROR TUN-0021] No FastRoute Tcl"
        self._execute_autotuner(platform, design, config_file, error_code)


if __name__ == "__main__":
    unittest.main()
