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
import time
from .autotuner_test_utils import AutoTunerTestUtils, accepted_rc

from contextlib import contextmanager

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src")
orfs_dir = os.path.join(cur_dir, "../../../flow")
os.chdir(src_dir)


@contextmanager
def managed_process(*args, **kwargs):
    """
    Runs process and ensures it is killed when the context is exited.
    """
    proc = subprocess.Popen(*args, **kwargs)
    try:
        yield proc
    finally:
        if proc.poll() is None:  # If the process is still running
            proc.kill()  # Forcefully kill it


class ResumeCheck(unittest.TestCase):
    # only test 1 platform/design.
    platform = "asap7"
    design = "gcd"
    samples = 5
    iterations = 2

    def setUp(self):
        self.config = os.path.join(
            orfs_dir, "designs", self.platform, self.design, "autotuner.json"
        )
        self.jobs = self.samples
        self.num_cpus = os.cpu_count()

        # How it works: Say we have 5 samples and 5 iterations.
        # If we want to limit to only 5 trials (and avoid any parallelism magic by Ray)
        #  We can set resources_per_trial = NUM_CORES/5 = 3.2 (fractional resources_per_trial are allowed!)

        # Cast to 1 decimal place
        res_per_trial = float("{:.1f}".format(self.num_cpus / self.samples))
        options = ["", "--resume"]
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.commands = [
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {self.config}"
            f" --jobs {self.jobs}"
            f" --experiment test-resume"
            f" tune --iterations {self.iterations} --samples {self.samples}"
            f" --resources_per_trial {res_per_trial}"
            f" {c}"
            for c in options
        ]

    def test_tune_resume(self):
        # Goal is to first run the first config (without resume) and then run the second config (with resume)
        # and check if the run is able to complete.

        # Run the first config asynchronously.
        print("Running the first config")
        with managed_process(self.commands[0], shell=True) as proc:
            time.sleep(120)

        # Keep trying to stop the ray cluster until it is stopped
        while 1:
            proc = subprocess.run("ray status", shell=True)
            no_nodes = proc.returncode != 0
            proc = subprocess.run("ray stop", shell=True)
            successful = proc.returncode in accepted_rc

            if no_nodes and successful:
                break
            time.sleep(10)

        # Run the second config to completion
        print("Running the second config")
        proc = subprocess.run(self.commands[1], shell=True)
        successful = proc.returncode in accepted_rc
        self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
