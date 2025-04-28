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
from .autotuner_test_utils import AutoTunerTestUtils, accepted_rc

cur_dir = os.path.dirname(os.path.abspath(__file__))
orfs_dir = os.path.join(cur_dir, "../../../flow")


class BaseAlgoEvalSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        design_path = f"../../../flow/designs/{self.platform}/{self.design}"
        self.config = os.path.join(cur_dir, f"{design_path}/autotuner.json")
        self.experiment = f"smoke-test-algo-eval-{self.platform}"
        self.reference = os.path.join(cur_dir, f"{design_path}/metadata-base-at.json")
        # note for ppa-improv, you need to also add in reference file (--reference)
        _algo = ["hyperopt", "ax", "optuna", "pbt", "random"]
        _eval = ["default", "ppa-improv"]
        self.matrix = [(a, e) for a in _algo for e in _eval]
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.commands = [
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" tune --samples 5"
            f" --algorithm {a} --eval {e}"
            f" --reference {self.reference}"
            for a, e in self.matrix
        ]

    def make_base(self):
        commands = [
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk clean_all",
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk EQUIVALENCE_CHECK=0",
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk update_metadata_autotuner",
        ]
        for command in commands:
            out = subprocess.run(command, shell=True)
            self.assertTrue(out.returncode in accepted_rc)

    def test_algo_eval(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        # Run `make` to get baseline metrics (metadata-base-ok.json)
        self.make_base()
        for command in self.commands:
            print(command)
            out = subprocess.run(command, shell=True)
            successful = out.returncode in accepted_rc
            self.assertTrue(successful)


class asap7AlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "asap7"
    design = "gcd"


class ihpsg13g2AlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


class sky130hdAlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "sky130hd"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
