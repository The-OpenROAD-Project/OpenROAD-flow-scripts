import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseTimeoutSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-timeout-{self.platform}"

        # 0.001 hour translates to 3.6 seconds, which will definitely cause failure.
        timeout_flags = ["--timeout 0.001", "--timeout_per_trial 0.001"]
        self.timeout_limit = 15  # 15 second upper limit
        self.commands = [
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --cpu_budget 1"
            f" --yes"
            f" {flag}"
            f" tune --samples 1"
            for flag in timeout_flags
        ]

    def test_timeout(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class asap7TimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_timeout(self):
        for command in self.commands:
            out = subprocess.run(
                command, shell=True, check=True, timeout=self.timeout_limit
            )
            successful = out.returncode == 0
            self.assertTrue(successful)


class sky130hdTimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_timeout(self):
        for command in self.commands:
            out = subprocess.run(
                command, shell=True, check=True, timeout=self.timeout_limit
            )
            successful = out.returncode == 0
            self.assertTrue(successful)


class ihpsg13g2TimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_timeout(self):
        for command in self.commands:
            out = subprocess.run(
                command, shell=True, check=True, timeout=self.timeout_limit
            )
            successful = out.returncode == 0
            self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
