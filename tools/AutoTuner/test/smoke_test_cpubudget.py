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

        # Tests should fail with such a low budget.
        cpu_budget = 1
        self.expected_timeout = cpu_budget / os.cpu_count() * 3600

        self.command = (
            "python3 distributed.py"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --experiment {self.experiment}"
            f" --config {self.config}"
            f" --cpu_budget 1"
            f" --yes"
            f" tune --samples 1"
        )
        self.command = self.command.split()

    def test_cpu_budget(self):
        raise NotImplementedError(
            "This method needs to be implemented in the derivative classes."
        )


class asap7CPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "asap7"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            _ = subprocess.run(
                self.command,
                stderr=subprocess.PIPE,
                timeout=self.expected_timeout,
            )
            failed = False
        except subprocess.TimeoutExpired:
            failed = True
        self.assertTrue(failed)


class sky130hdCPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "sky130hd"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            _ = subprocess.run(
                self.command,
                stderr=subprocess.PIPE,
                timeout=self.expected_timeout,
            )
            failed = False
        except subprocess.TimeoutExpired:
            failed = True
        self.assertTrue(failed)


class ihpsg13g2CPUBudgetSmokeTest(BaseCPUBudgetSmokeTest):
    platform = "ihp-sg13g2"
    design = "gcd"

    def test_cpu_budget(self):
        try:
            _ = subprocess.run(
                self.command,
                stderr=subprocess.PIPE,
                timeout=self.expected_timeout,
            )
            failed = False
        except subprocess.TimeoutExpired:
            failed = True
        self.assertTrue(failed)


if __name__ == "__main__":
    unittest.main()
