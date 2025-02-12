import unittest
import subprocess
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))


class RefFileCheck(unittest.TestCase):
    # only test 1 platform/design.
    platform = "asap7"
    design = "gcd"

    def setUp(self):
        configs = [
            os.path.join(cur_dir, "../../test/files/no_sdc_ref.json"),
            os.path.join(cur_dir, "../../test/files/no_fr_ref.json"),
        ]
        self.commands = [
            f"python3 -m autotuner.distributed"
            f" --design {self.design}"
            f" --platform {self.platform}"
            f" --config {c}"
            f" --yes"
            f" tune --samples 1"
            for c in configs
        ]

    def test_files(self):
        for c in self.commands:
            out = subprocess.run(c, shell=True)
            failed = out.returncode != 0
            self.assertTrue(failed)


if __name__ == "__main__":
    unittest.main()
