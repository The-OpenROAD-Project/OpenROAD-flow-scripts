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

import glob
import unittest
import subprocess
import os
import time
from .autotuner_test_utils import AutoTunerTestUtils, accepted_rc

from contextlib import contextmanager

cur_dir = os.path.dirname(os.path.abspath(__file__))


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
    experiment_name = "test-resume"

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.jobs = self.samples
        self.num_cpus = os.cpu_count()

        # Cast to 1 decimal place
        res_per_trial = float("{:.1f}".format(self.num_cpus / self.samples))
        options = ["", "--resume"]
        self.executable_command = AutoTunerTestUtils.get_exec_cmd()
        self.commands = [
            f"{self.executable_command}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {self.config}"
            f" --jobs {self.jobs}"
            f" --experiment {self.experiment_name}"
            f" tune --iterations {self.iterations} --samples {self.samples}"
            f" --resources_per_trial {res_per_trial}"
            f" {c}"
            for c in options
        ]

    def check_trial_times(self, iteration: int = 0) -> int:
        """
        Checks the nth iteration time of a trial.

        :param iteration: The iteration to check.
        :return: The latest modified UNIX time of the nth iteration.
                 If no folders are found, returns a default value of 9e99.
        """
        if iteration < 0 or iteration >= self.iterations:
            raise ValueError("Iteration must be between 0 and iterations - 1")

        experiment_dir = os.path.join(
            cur_dir,
            f"../../../flow/logs/{self.platform}/{self.design}/{self.experiment_name}-tune",
        )
        folders = glob.glob(os.path.join(experiment_dir, f"variant-*-or-{iteration}"))
        return max((os.path.getmtime(folder) for folder in folders), default=9e99)

    def test_tune_resume(self):
        # Goal is to first run the first config (without resume) and then run the second config (with resume)
        # and check if the run is able to complete.

        # Run the first config asynchronously.
        print("Running the first config")
        latest_modified_time = 0
        with managed_process(self.commands[0].split()) as proc:
            time.sleep(30)
            # Check if first config is complete
            while True:
                cur_modified_time = self.check_trial_times()
                print(f"Current modified time: {cur_modified_time}")
                print(f"Latest modified time: {latest_modified_time}")
                if abs(cur_modified_time - latest_modified_time) < 1e-3:
                    break
                latest_modified_time = cur_modified_time
                time.sleep(10)

        # Keep trying to stop the ray cluster until it is stopped
        while 1:
            proc = subprocess.run(
                "ray status", shell=True, capture_output=True, text=True
            )
            if proc.returncode != 0:
                print(f"Error running 'ray status': {proc.stderr}")
            no_nodes = proc.returncode != 0
            proc = subprocess.run(
                "ray stop", shell=True, capture_output=True, text=True
            )
            if proc.returncode not in accepted_rc:
                print(f"Error running 'ray stop': {proc.stderr}")
                raise RuntimeError("Failed to stop the ray cluster")
            successful = True

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
