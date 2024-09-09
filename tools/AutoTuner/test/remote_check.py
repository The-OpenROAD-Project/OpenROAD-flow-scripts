import unittest
import subprocess
import os
import time

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
orfs_dir = os.path.join(cur_dir, "../../../flow")
os.chdir(src_dir)


class RemoteCheck(unittest.TestCase):
    # only test 1 platform/design.
    platform = "asap7"
    design = "gcd"
    samples = 5
    iterations = 1

    def setUp(self):
        self.config = os.path.join(
            orfs_dir, "designs", self.platform, self.design, "autotuner.json"
        )
        self.jobs = self.samples

        self.commands = (
            f"python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {self.config}"
            f" --experiment test_remote"
            f" tune --iterations {self.iterations} --samples {self.samples}"
        )

    def test_tune_remote(self):
        # Successful if you can start the docker compose commands and run the autotuner command.
        pass


if __name__ == "__main__":
    unittest.main()
