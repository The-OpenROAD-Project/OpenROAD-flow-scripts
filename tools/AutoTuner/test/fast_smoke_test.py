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


class FastSmokeTest(unittest.TestCase):
    platform = "asap7"
    design = "gcd"

    def setUp(self):
        self.tune_config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.sweep_config = os.path.join(
            cur_dir,
            "./files/fast-at-sweep.json",
        )
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.tune_command = (
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment fast-smoke-test-tune"
            f" --config {self.tune_config}"
            f" tune --samples 1"
        )
        self.sweep_command = (
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment fast-smke-test-sweep"
            f" --config {self.sweep_config}"
            f" sweep"
        )

    def test(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")

        tune_process = subprocess.Popen(self.tune_command, shell=True)
        sweep_process = subprocess.Popen(self.sweep_command, shell=True)

        tune_returncode = tune_process.wait()
        sweep_returncode = sweep_process.wait()

        self.assertEqual(tune_returncode, 0, "Tune command failed")
        self.assertEqual(sweep_returncode, 0, "Sweep command failed")



if __name__ == "__main__":
    unittest.main()
