import unittest
import subprocess
import os
from autotuner_test_utils import AutoTunerTestUtils


class RefFileCheck(unittest.TestCase):
    """
    Tests situations where a referenced file (SDC or FastRoute) is not
    defined in the AutoTuner config
    """

    def setUp(self):
        self._cur_dir = os.path.dirname(os.path.abspath(__file__))
        src_dir = os.path.join(self._cur_dir, "../src")
        os.chdir(src_dir)

        self._exec = AutoTunerTestUtils.get_exec_cmd()

    def _execute_autotuner(self, platform, design, config_file, error_code=None):
        full_path = os.path.abspath(os.path.join(self._cur_dir, config_file))

        cmd = f"{self._exec} --design {design} --platform {platform} --config {full_path} tune --samples 1"

        out = subprocess.run(cmd, shell=True, text=True, capture_output=True)
        failed = out.returncode != 0
        self.assertTrue(failed, f"AT run with {config_file} passed")
        if error_code:
            self.assertTrue(
                error_code in out.stdout,
                f"Didn't find error code {error_code} in output '{out.stdout}'",
            )

    def test_asap_gcd_no_sdc(self):
        """
        Tests when SDC file is not defined, which is an error for all
        platforms and designs
        """

        platform = "asap7"
        design = "gcd"
        config_file = "files/no_sdc_ref.json"
        error_code = "[ERROR TUN-0020] No SDC reference"
        self._execute_autotuner(platform, design, config_file, error_code)

    def test_asap_gcd_no_fr(self):
        """
        Tests when FastRoute file is not defined, which is not an error for
        asap platform. This test fails anyway
        """

        platform = "asap7"
        design = "gcd"
        config_file = "files/no_fr_ref.json"
        self._execute_autotuner(platform, design, config_file)

    def test_ihp_gcd_no_fr(self):
        """
        Tests when FastRoute file is not defined, which is not an error for
        any non-asap7 platform.
        """

        platform = "ihp-sg13g2"
        design = "gcd"
        config_file = "files/no_fr_ref.json"
        error_code = "[ERROR TUN-0021] No FastRoute Tcl"
        self._execute_autotuner(platform, design, config_file, error_code)


if __name__ == "__main__":
    unittest.main()
