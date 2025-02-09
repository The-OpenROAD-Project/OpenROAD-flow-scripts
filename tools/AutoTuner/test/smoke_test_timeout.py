import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))


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
        self.commands = [
            "python3 -m autotuner.distributed"
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
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        for command in self.commands:
            out = subprocess.run(command, shell=True, check=False)
            failed = out.returncode != 0
            self.assertTrue(failed)


class asap7TimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "asap7"
    design = "gcd"


class sky130hdTimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "sky130hd"
    design = "gcd"


class ihpsg13g2TimeoutSmokeTest(BaseTimeoutSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
