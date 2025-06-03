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
import json
from .autotuner_test_utils import AutoTunerTestUtils, accepted_rc

cur_dir = os.path.dirname(os.path.abspath(__file__))


class BaseSweepSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.abspath(
            os.path.join(cur_dir, "../src/autotuner/distributed-sweep-example.json")
        )
        # make sure this json only has 1 key called "CTS_CLUSTER_SIZE" and 4 possible values
        with open(self.config) as f:
            contents = json.load(f)
            assert len(contents.keys()) == 1, "Must be size 1"
            assert "CTS_CLUSTER_SIZE" in contents, "Must have key CTS_CLUSTER_SIZE"
            assert (
                contents["CTS_CLUSTER_SIZE"]["minmax"][1]
                - contents["CTS_CLUSTER_SIZE"]["minmax"][0]
            ) / contents["CTS_CLUSTER_SIZE"][
                "step"
            ] == 4, "Must have only 4 possible values"

        # limit jobs because ray.get() does not terminate if jobs > number of samples
        core = os.cpu_count()
        self.jobs = 4 if core >= 4 else core
        self.experiment = f"smoke-test-sweep-{self.platform}"
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.command = (
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --jobs {self.jobs}"
            f" sweep"
        )

    def test_sweep(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        out = subprocess.run(self.command, shell=True)
        successful = out.returncode in accepted_rc
        self.assertTrue(successful)


class asap7SweepSmokeTest(BaseSweepSmokeTest):
    platform = "asap7"
    design = "gcd"


class sky130hdSweepSmokeTest(BaseSweepSmokeTest):
    platform = "sky130hd"
    design = "gcd"


class ihpsg13g2SweepSmokeTest(BaseSweepSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
