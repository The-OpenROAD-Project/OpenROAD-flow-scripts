import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseTuneTimeoutTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-timeout-{self.platform}"

        # 0.01 hour translates to 36 seconds, which will definitely cause failure.
        timeout_flags = ["--timeout 0.05", "--timeout_per_trial 0.05"]
        self.commands = [
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" {flag}"
            f" tune --samples 1"
            for flag in timeout_flags
        ]

    def test_trial_timeout(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class ASAP7TuneTimeoutTest(BaseTuneTimeoutTest):
    platform = "asap7"
    design = "gcd"

    def test_trial_timeout(self):
        for command in self.commands:
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertFalse(successful)


class SKY130HDTuneTimeoutTest(BaseTuneTimeoutTest):
    platform = "sky130hd"
    design = "gcd"

    def test_trial_timeout(self):
        for command in self.commands:
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertFalse(successful)


class IHPSG13G2TuneTimeoutTest(BaseTuneTimeoutTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_trial_timeout(self):
        for command in self.commands:
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertFalse(successful)


if __name__ == "__main__":
    unittest.main()
