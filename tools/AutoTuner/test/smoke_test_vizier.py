import unittest
import subprocess
import os
from datetime import datetime

cur_dir = os.path.dirname(os.path.abspath(__file__))


class BaseVizierSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-tune-{self.platform}-{datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}"
        self.command = (
            "python3 -m autotuner.vizier"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --iteration 1 --suggestions 1"
        )

    def test_vizier(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class ASAP7VizierSmokeTest(BaseVizierSmokeTest):
    platform = "asap7"
    design = "gcd"


class SKY130HDVizierSmokeTest(BaseVizierSmokeTest):
    platform = "sky130hd"
    design = "gcd"


class IHPSG13G2VizierSmokeTest(BaseVizierSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
