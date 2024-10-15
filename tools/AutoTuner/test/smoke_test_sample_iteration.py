import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseSampleIterationSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-sample-iteration-{self.platform}"
        self.matrix = [(5, 1), (1, 5), (2, 2), (1, 1)]
        self.commands = [
            f"python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" tune --samples {s} --iterations {i}"
            for s, i in self.matrix
        ]


class ASAP7SampleIterationSmokeTest(BaseSampleIterationSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_sample_iteration(self):
        for command in self.commands:
            print(command)
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertTrue(successful)


class SKY130HDSampleIterationSmokeTest(BaseSampleIterationSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_sample_iteration(self):
        for command in self.commands:
            print(command)
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertTrue(successful)


class IHPSG13G2SampleIterationSmokeTest(BaseSampleIterationSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_sample_iteration(self):
        for command in self.commands:
            print(command)
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
