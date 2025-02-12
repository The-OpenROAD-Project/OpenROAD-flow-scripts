import unittest
import subprocess
import os
from autotuner_test_utils import AutoTunerTestUtils

cur_dir = os.path.dirname(os.path.abspath(__file__))


class BaseTuneSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-tune-{self.platform}"
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.command = (
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" tune --samples 5"
        )

    def test_tune(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class asap7TuneSmokeTest(BaseTuneSmokeTest):
    platform = "asap7"
    design = "gcd"


class sky130hdTuneSmokeTest(BaseTuneSmokeTest):
    platform = "sky130hd"
    design = "gcd"


class ihpsg13g2TuneSmokeTest(BaseTuneSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
