import unittest
import subprocess
import os
import time
import uuid

from contextlib import contextmanager

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
orfs_dir = os.path.join(cur_dir, "../../../flow")
os.chdir(src_dir)


@contextmanager
def managed_process(*args, **kwargs):
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
        # This means at any one time, there will be 5 trials.
        # If we want to only run 5 trials:
        #  We can set resources_per_trial = NUM_CORES/5 = 3.2
        # Yes fractional resources_per_trial is allowed.

        # Cast to 1 decimal place
        res_per_trial = float("{:.1f}".format(self.num_cpus / self.samples))
        self.uuid = str(uuid.uuid4())[:8]
        options = ["", "--resume"]
        self.commands = [
            f"python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {self.config}"
            f" --experiment {self.uuid}"
            f" --jobs {self.jobs}"
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

        # Close all ray instances
        subprocess.run("ray stop", shell=True)

        # Run the second config to completion
        print("Running the second config")
        proc = subprocess.run(self.commands[1], shell=True)
        successful = proc.returncode == 0
        self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
