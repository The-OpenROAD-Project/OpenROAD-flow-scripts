import unittest
import subprocess
import os
from .autotuner_test_utils import AutoTunerTestUtils

cur_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(cur_dir, "../src")
orfs_dir = os.path.join(cur_dir, "../../../flow")
os.chdir(src_dir)


class RefFileCheck(unittest.TestCase):
    # only test 1 platform/design.
    platform = "asap7"
    design = "gcd"

    def setUp(self):
        configs = [
            "../../test/files/no_sdc_ref.json",
            "../../test/files/no_fr_ref.json",
        ]
        self.exec = AutoTunerTestUtils.get_exec_cmd()
        self.commands = [
            f"{self.exec}"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {c}"
            f" tune --samples 1"
            for c in configs
        ]

    # Make this a test case
    def test_files(self):
        for c in self.commands:
            out = subprocess.run(c, shell=True)
            failed = out.returncode != 0
            self.assertTrue(failed)


if __name__ == "__main__":
    unittest.main()
