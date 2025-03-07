#!/usr/bin/env python3
#############################################################################
##
## Copyright (c) 2024, Precision Innovations Inc.
## All rights reserved.
##
## BSD 3-Clause License
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and/or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
###############################################################################

import os
import sys
import unittest
import subprocess

test_dir = os.path.abspath(os.path.dirname(__file__))
at_src_dir = os.path.join(test_dir, "..", "src", "autotuner")
sys.path.append(test_dir)
sys.path.append(at_src_dir)
from scripts.gen_at_report import GenATReport
from autotuner_test_utils import AutoTunerTestUtils


class GenATReportTest(unittest.TestCase):
    """Tests GenATReport methods"""

    def setUp(self):
        """
        Per-test setup defines the rep being tested and various example data
        """

        self._rep = GenATReport()
        self._exec = AutoTunerTestUtils.get_exec_cmd(False)
        self._script_path = os.path.join(at_src_dir, "scripts", "gen_at_report.py")
        self._exp_dir_results = {
            "variant-AutoTunerBase-075315ab-ray": {
                "name": "variant-AutoTunerBase-075315ab-ray",
                "metrics": {
                    "metric": 45652.7,
                    "effective_clk_period": 456.52660000000003,
                    "num_drc": 0,
                    "done": True,
                    "training_iteration": 1,
                    "trial_id": "075315ab",
                    "date": "2025-02-28_18-45-29",
                    "timestamp": 1740768329,
                    "time_this_iter_s": 66.46166968345642,
                    "time_total_s": 66.46166968345642,
                    "pid": 3638,
                    "hostname": "047ec088fde6",
                    "node_ip": "172.17.0.2",
                    "config": {
                        "_SDC_CLK_PERIOD": 473.2410618568929,
                        "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT": 1,
                        "CELL_PAD_IN_SITES_DETAIL_PLACEMENT": 0,
                        "_FR_LAYER_ADJUST": 0.13110212203998772,
                        "PLACE_DENSITY_LB_ADDON": 0.03452145105773252,
                        "CTS_CLUSTER_SIZE": 84,
                        "CTS_CLUSTER_DIAMETER": 186,
                    },
                    "time_since_restore": 66.46166968345642,
                    "iterations_since_restore": 1,
                },
                "run_time": "00:01:06",
                "completion_time": 1740768329,
            },
            "variant-AutoTunerBase-c9b89a17-ray": {
                "name": "variant-AutoTunerBase-c9b89a17-ray",
                "metrics": {
                    "metric": 44349.7,
                    "effective_clk_period": 443.4968,
                    "num_drc": 0,
                    "done": True,
                    "training_iteration": 1,
                    "trial_id": "c9b89a17",
                    "date": "2025-02-28_18-45-31",
                    "timestamp": 1740768331,
                    "time_this_iter_s": 67.42584133148193,
                    "time_total_s": 67.42584133148193,
                    "pid": 3945,
                    "hostname": "047ec088fde6",
                    "node_ip": "172.17.0.2",
                    "config": {
                        "_SDC_CLK_PERIOD": 449.5242250663756,
                        "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT": 1,
                        "CELL_PAD_IN_SITES_DETAIL_PLACEMENT": 1,
                        "_FR_LAYER_ADJUST": 0.15849402425181552,
                        "PLACE_DENSITY_LB_ADDON": 0.17873876655922555,
                        "CTS_CLUSTER_SIZE": 158,
                        "CTS_CLUSTER_DIAMETER": 60,
                    },
                    "time_since_restore": 67.42584133148193,
                    "iterations_since_restore": 1,
                },
                "run_time": "00:01:07",
                "completion_time": 1740768331,
            },
            "variant-AutoTunerBase-dd480f52-ray": {
                "name": "variant-AutoTunerBase-dd480f52-ray",
                "metrics": {
                    "metric": 35686.8,
                    "effective_clk_period": 356.8677,
                    "num_drc": 0,
                    "done": True,
                    "training_iteration": 1,
                    "trial_id": "dd480f52",
                    "date": "2025-02-28_18-45-26",
                    "timestamp": 1740768326,
                    "time_this_iter_s": 67.7457926273346,
                    "time_total_s": 67.7457926273346,
                    "pid": 2886,
                    "hostname": "047ec088fde6",
                    "node_ip": "172.17.0.2",
                    "config": {
                        "_SDC_CLK_PERIOD": 233.75674387733073,
                        "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT": 1,
                        "CELL_PAD_IN_SITES_DETAIL_PLACEMENT": 1,
                        "_FR_LAYER_ADJUST": 0.28857429823519476,
                        "PLACE_DENSITY_LB_ADDON": 0.15872338201602781,
                        "CTS_CLUSTER_SIZE": 28,
                        "CTS_CLUSTER_DIAMETER": 291,
                    },
                    "time_since_restore": 67.7457926273346,
                    "iterations_since_restore": 1,
                },
                "run_time": "00:01:07",
                "completion_time": 1740768326,
            },
            "variant-AutoTunerBase-87973fd5-ray": {
                "name": "variant-AutoTunerBase-87973fd5-ray",
                "metrics": {
                    "metric": 41374.9,
                    "effective_clk_period": 413.74916,
                    "num_drc": 0,
                    "done": True,
                    "training_iteration": 1,
                    "trial_id": "87973fd5",
                    "date": "2025-02-28_18-45-26",
                    "timestamp": 1740768326,
                    "time_this_iter_s": 66.01769185066223,
                    "time_total_s": 66.01769185066223,
                    "pid": 2975,
                    "hostname": "047ec088fde6",
                    "node_ip": "172.17.0.2",
                    "config": {
                        "_SDC_CLK_PERIOD": 416.7950151956536,
                        "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT": 2,
                        "CELL_PAD_IN_SITES_DETAIL_PLACEMENT": 1,
                        "_FR_LAYER_ADJUST": 0.21077117188315186,
                        "PLACE_DENSITY_LB_ADDON": 0.13859111392097342,
                        "CTS_CLUSTER_SIZE": 174,
                        "CTS_CLUSTER_DIAMETER": 61,
                    },
                    "time_since_restore": 66.01769185066223,
                    "iterations_since_restore": 1,
                },
                "run_time": "00:01:06",
                "completion_time": 1740768326,
            },
            "variant-AutoTunerBase-85b217fd-ray": {
                "name": "variant-AutoTunerBase-85b217fd-ray",
                "metrics": {
                    "metric": 9e99,
                    "effective_clk_period": "-",
                    "num_drc": "-",
                    "done": True,
                    "training_iteration": 1,
                    "trial_id": "85b217fd",
                    "date": "2025-02-28_18-44-21",
                    "timestamp": 1740768261,
                    "time_this_iter_s": 6.198883056640625e-06,
                    "time_total_s": 6.198883056640625e-06,
                    "pid": 3095,
                    "hostname": "047ec088fde6",
                    "node_ip": "172.17.0.2",
                    "config": {
                        "_SDC_CLK_PERIOD": 207.66851891516706,
                        "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT": 0,
                        "CELL_PAD_IN_SITES_DETAIL_PLACEMENT": 1,
                        "_FR_LAYER_ADJUST": 0.19970414187072266,
                        "PLACE_DENSITY_LB_ADDON": 0.005515654817257154,
                        "CTS_CLUSTER_SIZE": 34,
                        "CTS_CLUSTER_DIAMETER": 174,
                    },
                    "time_since_restore": 6.198883056640625e-06,
                    "iterations_since_restore": 1,
                },
                "run_time": "00:00:00",
                "completion_time": 1740768261,
            },
        }
        self._exp_log_results = {
            "variant-AutoTunerBase-85b217fd-ray": {
                "name": "variant-AutoTunerBase-85b217fd-ray",
                "metrics": {
                    "time_this_iter_s": "0.00001",
                    "time_total_s": "0.00001",
                    "training_iteration": "1",
                },
                "run_time": "0:00:04",
                "completion_time": 1740768261.0,
            },
            "variant-AutoTunerBase-87973fd5-ray": {
                "name": "variant-AutoTunerBase-87973fd5-ray",
                "metrics": {
                    "time_this_iter_s": "66.0177",
                    "time_total_s": "66.0177",
                    "training_iteration": "1",
                    "effective_clk_period": "413.749",
                    "metric": "41374.9",
                    "num_drc": "0",
                },
                "run_time": "0:01:08",
                "completion_time": 1740768326.0,
            },
            "variant-AutoTunerBase-dd480f52-ray": {
                "name": "variant-AutoTunerBase-dd480f52-ray",
                "metrics": {
                    "time_this_iter_s": "67.7458",
                    "time_total_s": "67.7458",
                    "training_iteration": "1",
                    "effective_clk_period": "356.868",
                    "metric": "35686.8",
                    "num_drc": "0",
                },
                "run_time": "0:01:09",
                "completion_time": 1740768326.0,
            },
            "variant-AutoTunerBase-075315ab-ray": {
                "name": "variant-AutoTunerBase-075315ab-ray",
                "metrics": {
                    "time_this_iter_s": "66.4617",
                    "time_total_s": "66.4617",
                    "training_iteration": "1",
                    "effective_clk_period": "456.527",
                    "metric": "45652.7",
                    "num_drc": "0",
                },
                "run_time": "0:01:11",
                "completion_time": 1740768329.0,
            },
            "variant-AutoTunerBase-c9b89a17-ray": {
                "name": "variant-AutoTunerBase-c9b89a17-ray",
                "metrics": {
                    "time_this_iter_s": "67.4258",
                    "time_total_s": "67.4258",
                    "training_iteration": "1",
                    "effective_clk_period": "443.497",
                    "metric": "44349.7",
                    "num_drc": "0",
                },
                "run_time": "0:01:13",
                "completion_time": 1740768331.0,
            },
        }

        self._exp_dir_report = """|Trial|metric|Run Time (h:mm:ss)|Finish Order|
|-|-|-|-|
|variant-AutoTunerBase-85b217fd-ray|9e+99|00:00:00|1|
|variant-AutoTunerBase-dd480f52-ray|35686.8|00:01:07|2|
|variant-AutoTunerBase-87973fd5-ray|41374.9|00:01:06|3|
|variant-AutoTunerBase-075315ab-ray|45652.7|00:01:06|4|
|variant-AutoTunerBase-c9b89a17-ray|44349.7|00:01:07|5|
"""

        self._exp_log_report = """|Trial|metric|Run Time (h:mm:ss)|Finish Order|
|-|-|-|-|
|variant-AutoTunerBase-85b217fd-ray|9e+99|0:00:04|1|
|variant-AutoTunerBase-87973fd5-ray|41374.9|0:01:08|2|
|variant-AutoTunerBase-dd480f52-ray|35686.8|0:01:09|3|
|variant-AutoTunerBase-075315ab-ray|45652.7|0:01:11|4|
|variant-AutoTunerBase-c9b89a17-ray|44349.7|0:01:13|5|
"""

    def test_read_log_dir(self):
        """Tests the read_log_dir method"""

        dir_name = os.path.join(test_dir, "files", "tune-cce4569e")
        self._rep.read_log_dir(dir_name)
        self.assertEqual(self._rep._trial_dict, self._exp_dir_results)

    def test_read_log_file(self):
        """Tests the read_log_file method"""

        input_file = os.path.join(test_dir, "files", "asap7_gcd.log")
        self._rep.read_log_file(input_file)
        self.assertEqual(self._rep._trial_dict, self._exp_log_results)

    def _compare_results(self, results_file, exp_results):
        """
        Compares the results by reading file content into buffer and comparing
        it to expected result string
        """

        with open(results_file, "r") as fh:
            results = fh.read()
            self.assertEqual(results, exp_results)

    def _clean_results(self, result_file):
        """Removes the result file if it exists"""

        if os.path.exists(result_file):
            os.remove(result_file)

    def test_log_flow(self):
        """Flow test executes the script directly in log mode"""

        input_file = os.path.join(test_dir, "files", "asap7_gcd.log")
        result_file = os.path.join(test_dir, "results_log.md")
        self._clean_results(result_file)
        cmd = (
            self._exec
            + " "
            + self._script_path
            + " -i "
            + input_file
            + " -o "
            + result_file
        )
        out = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self._compare_results(result_file, self._exp_log_report)
        self._clean_results(result_file)

    def test_dir_flow(self):
        """Flow test executes the script directly in dir mode"""

        dir_name = os.path.join(test_dir, "files", "tune-cce4569e")
        result_file = os.path.join(test_dir, "results_dir.md")
        self._clean_results(result_file)
        cmd = (
            self._exec
            + " "
            + self._script_path
            + " -d "
            + dir_name
            + " -o "
            + result_file
        )
        out = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self._compare_results(result_file, self._exp_dir_report)
        self._clean_results(result_file)


if __name__ == "__main__":
    unittest.main()
