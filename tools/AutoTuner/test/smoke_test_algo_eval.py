import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
orfs_dir = os.path.join(cur_dir, "../../../flow")


class BaseAlgoEvalSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        design_path = f"../../../flow/designs/{self.platform}/{self.design}"
        self.config = os.path.join(cur_dir, f"{design_path}/autotuner.json")
        self.experiment = f"smoke-test-algo-eval-{self.platform}"
        self.reference = os.path.join(cur_dir, f"{design_path}/metadata-base-at.json")
        # note for ppa-improv, you need to also add in reference file (--reference)
        _algo = ["hyperopt", "ax", "optuna", "pbt", "random"]
        _eval = ["default", "ppa-improv"]
        self.matrix = [(a, e) for a in _algo for e in _eval]
        self.commands = [
            f"python3 -m autotuner.distributed"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --yes"
            f" tune --samples 5"
            f" --algorithm {a} --eval {e}"
            f" --reference {self.reference}"
            for a, e in self.matrix
        ]

    def make_base(self):
        commands = [
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk clean_all",
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk EQUIVALENCE_CHECK=0",
            f"make -C {orfs_dir} DESIGN_CONFIG=./designs/{self.platform}/{self.design}/config.mk update_metadata_autotuner",
        ]
        for command in commands:
            out = subprocess.run(command, shell=True, check=True)
            self.assertTrue(out.returncode == 0)

    def test_algo_eval(self):
        if not (self.platform and self.design):
            raise unittest.SkipTest("Platform and design have to be defined")
        # Run `make` to get baseline metrics (metadata-base-ok.json)
        self.make_base()
        for command in self.commands:
            print(command)
            out = subprocess.run(command, shell=True, check=True)
            successful = out.returncode == 0
            self.assertTrue(successful)


class asap7AlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "asap7"
    design = "gcd"


class ihpsg13g2AlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"


class sky130hdAlgoEvalSmokeTest(BaseAlgoEvalSmokeTest):
    platform = "sky130hd"
    design = "gcd"


if __name__ == "__main__":
    unittest.main()
