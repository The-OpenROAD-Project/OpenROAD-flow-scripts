import unittest
import subprocess
import os
import json

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseSweepSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = "distributed-sweep-example.json"
        # make sure this json only has 1 key called "CTS_CLUSTER_SIZE" and 4 possible values
        with open(self.config) as f:
            contents = json.load(f)
            assert len(contents.keys()) == 1, "Must be size 1"
            assert "CTS_CLUSTER_SIZE" in contents, "Must have key CTS_CLUSTER_SIZE"
            assert (
                contents["CTS_CLUSTER_SIZE"]["minmax"][1]
                - contents["CTS_CLUSTER_SIZE"]["minmax"][0]
            ) / contents["CTS_CLUSTER_SIZE"][
                "step"
            ] == 4, "Must have only 4 possible values"

        # limit jobs because ray.get() does not terminate if jobs > number of samples
        core = os.cpu_count()
        self.jobs = 4 if core >= 4 else core
        self.experiment = f"smoke-test-sweep-{self.platform}"
        self.command = (
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --jobs {self.jobs}"
            f" sweep"
        )

    def test_sweep(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class ASAP7SweepSmokeTest(BaseSweepSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_sweep(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class SKY130HDSweepSmokeTest(BaseSweepSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_sweep(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class IHPSG13G2SweepSmokeTest(BaseSweepSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_sweep(self):
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


if __name__ == "__main__":
    unittest.main()
