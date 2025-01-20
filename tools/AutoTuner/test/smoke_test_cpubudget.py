import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src/autotuner")
os.chdir(src_dir)


class BaseCPUBudgetSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(
            cur_dir,
            f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json",
        )
        self.experiment = f"smoke-test-cpubudget-{self.platform}"

        cpu_budget = 1
        self.expected_timeout = cpu_budget / os.cpu_count()

        self.command = (
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --cpu_budget 1"
            f" --yes"
            f" tune --samples 1000"
        )

    def test_cpu_budget(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class asap7CPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            out = subprocess.run(
                self.command, shell=True, check=True, timeout=self.expected_timeout
            )
            successful = out.returncode == 0
        except subprocess.TimeoutExpired:
            successful = False
        self.assertFalse(successful)


class sky130hdCPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            out = subprocess.run(
                self.command, shell=True, check=True, timeout=self.expected_timeout
            )
            successful = out.returncode == 0
        except subprocess.TimeoutExpired:
            successful = False
        self.assertFalse(successful)


class ihpsg13g2CPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            out = subprocess.run(
                self.command, shell=True, check=True, timeout=self.expected_timeout
            )
            successful = out.returncode == 0
        except subprocess.TimeoutExpired:
            successful = False
        self.assertFalse(successful)


if __name__ == "__main__":
    unittest.main()
