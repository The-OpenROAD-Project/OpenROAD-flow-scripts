import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseTuneSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-tune-{self.platform}"
        self.command = (
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" tune --samples 5"
        )

    def test_tune(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class ASAP7TuneSmokeTest(BaseTuneSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_tune(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class SKY130HDTuneSmokeTest(BaseTuneSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_tune(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class IHPSG13G2TuneSmokeTest(BaseTuneSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_tune(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
