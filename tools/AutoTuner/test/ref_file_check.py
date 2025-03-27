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
    # only test 1 platform/design.
    platform = "asap7"
    design = "gcd"

    def setUp(self):
        configs = [
            "../../test/files/no_sdc_ref.json",
            "../../test/files/no_fr_ref.json",
        ]
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.commands = [
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {c}"
            f" tune --samples 1"
            for c in configs
        ]

    # Make this a test case
    def test_files(self):
        for c in self.commands:
            out = subprocess.run(c, shell=True)
            failed = out.returncode != 0
            self.assertTrue(failed)


if __name__ == "__main__":
    unittest.main()
