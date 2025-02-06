import unittest
import subprocess
import os
import json

cur_dir = os.path.dirname(os.path.abspath(__file__))


class BaseSweepSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.abspath(
            os.path.join(cur_dir, "../src/autotuner/distributed-sweep-example.json")
        )
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
            "python3 -m autotuner.distributed"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --jobs {self.jobs}"
            f" sweep"
        )

    def test_sweep(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        out = subprocess.run(self.command, shell=True, check=True)
        successful = out.returncode == 0
        self.assertTrue(successful)


class asap7SweepSmokeTest(BaseSweepSmokeTest):
    platform = "asap7"
    design = "gcd"


class sky130hdSweepSmokeTest(BaseSweepSmokeTest):
    platform = "sky130hd"
    design = "gcd"


class ihpsg13g2SweepSmokeTest(BaseSweepSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
