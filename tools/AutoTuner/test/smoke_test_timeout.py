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
        self.timeout_limit = 60  # 60 second upper limit (Ray needs time to shutdown)
        self.commands = [
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}-{idx}"
            f" --config {self.config}"
            f" --yes"
            f" {flag}"
            f" tune --samples 1"
            for idx, flag in enumerate(timeout_flags)
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
                command, shell=True, check=False, timeout=self.timeout_limit
            )
            failed = out.returncode == 1
            self.assertTrue(failed)


class sky130hdTimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_timeout(self):
        for command in self.commands:
            out = subprocess.run(
                command, shell=True, check=False, timeout=self.timeout_limit
            )
            failed = out.returncode == 1
            self.assertTrue(failed)


class ihpsg13g2TimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_timeout(self):
        for command in self.commands:
            out = subprocess.run(
                command, shell=True, check=False, timeout=self.timeout_limit
            )
            failed = out.returncode == 1
            self.assertTrue(failed)


if __name__ == "__main__":
    unittest.main()
