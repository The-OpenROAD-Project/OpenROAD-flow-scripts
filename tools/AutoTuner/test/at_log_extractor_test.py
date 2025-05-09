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

import re
import io
import os
import sys
import unittest
import datetime
import subprocess

test_dir = os.path.abspath(os.path.dirname(__file__))
at_src_dir = os.path.join(test_dir, "..", "src", "autotuner")
sys.path.append(test_dir)
sys.path.append(at_src_dir)
from scripts.at_log_extractor import ATLogExtractor
from autotuner_test_utils import AutoTunerTestUtils


class ATLogExtractorTest(unittest.TestCase):
    """Tests ATLogExtractor methods"""

    def setUp(self):
        """
        Per-test setup defines the rep being tested and various example data
        """

        self._rep = ATLogExtractor(None, None, None)
        self._example_completed_data = [
            (
                "Trial variant-AutoTunerBase-1234-ray completed after 1 iterations at 2025-02-28 14:16:06. Total running time: 59s",
                "variant-AutoTunerBase-1234-ray",
                1740752166,
                "0:00:59",
            ),
            (
                "Trial variant-AutoTunerBase-5678-ray completed after 1 iterations at 2025-02-27 14:16:06. Total running time: 22min 1s",
                "variant-AutoTunerBase-5678-ray",
                1740665766,
                "0:22:01",
            ),
            (
                "Trial variant-AutoTunerBase-9101-ray completed after 1 iterations at 2025-02-20 14:56:06. Total running time: 3h 25min 0s",
                "variant-AutoTunerBase-9101-ray",
                1740063366.0,
                "3:25:00",
            ),
        ]
        self._example_result_data = [
            (
                """╭─────────────────────────────────────────────────────────────╮
│ Trial variant-AutoTunerBase-1234-ray result             │
├─────────────────────────────────────────────────────────────┤
│ time_this_iter_s                                    1209.53 │
│ time_total_s                                        1209.53 │
│ training_iteration                                        1 │
│ effective_clk_period                                 956.97 │
│ metric                                                95697 │
│ num_drc                                                   0 │
╰─────────────────────────────────────────────────────────────╯

""",
                {
                    "effective_clk_period": "956.97",
                    "metric": "95697",
                    "num_drc": "0",
                    "time_this_iter_s": "1209.53",
                    "time_total_s": "1209.53",
                    "training_iteration": "1",
                },
            )
        ]

    def test_get_timestamp(self):
        """Tests the get_timestamp method"""

        exp_timestamp = 1741109632
        datetime_obj = datetime.datetime.fromtimestamp(exp_timestamp)
        date_str = datetime_obj.date()
        time_str = datetime_obj.time()
        timestamp = self._rep._get_timestamp(date_str, time_str)
        self.assertEqual(timestamp, exp_timestamp)

    def test_read_result_table(self):
        """Tests the result table read method"""

        for test_data in self._example_result_data:
            fh = io.StringIO(test_data[0])
            metrics = self._rep._read_result_table(fh, "bogus")
            self.assertEqual(metrics, test_data[1])

    def test_add_completed_trial(self):
        """Tests the add_completed_trial method"""

        # callback gets past the expected values in the obj
        def completion_cbk(obj, trial_name, completion_timestamp, run_time):
            self.assertEqual(trial_name, obj[0])
            self.assertEqual(completion_timestamp, obj[1])
            self.assertEqual(run_time, obj[2])

        self._rep._completion_cbk = completion_cbk
        for test_data in self._example_completed_data:
            result = self._rep._trial_completed_re.match(test_data[0])
            self._rep._obj = (test_data[1], test_data[2], test_data[3])
            self._rep._add_completed_trial(result)

    def test_add_result(self):
        """Tests the add_result method"""

        # callback gets past the expected values in the obj
        def result_cbk(obj, trial_name, metrics):
            self.assertEqual(trial_name, obj[0])
            self.assertEqual(metrics, obj[1])

        ct = 0
        self._rep._result_cbk = result_cbk
        for test_data in self._example_result_data:
            trial_name = f"bogus{ct}"
            fh = io.StringIO(test_data[0])
            self._rep._obj = (trial_name, test_data[1])
            metrics = self._rep._add_result(fh, trial_name)
            ct += 1

    def test_get_runtime(self):
        """Tests the get_runtime method"""

        for test_data in self._example_completed_data:
            result = self._rep._trial_completed_re.match(test_data[0])
            run_time = self._rep._get_runtime(result)
            self.assertEqual(run_time, test_data[3])

    def test_flow(self):
        """Flow test executes the script directly"""

        input_file = os.path.join(test_dir, "files", "asap7_gcd.log")
        exp_result = "Trial variant-AutoTunerBase-85b217fd-ray metrics {'time_this_iter_s': '0.00001', 'time_total_s': '0.00001', 'training_iteration': '1'}\nTrial variant-AutoTunerBase-85b217fd-ray finished at 2025-02-28 18:44:21 with run time 0:00:04\nTrial variant-AutoTunerBase-87973fd5-ray metrics {'time_this_iter_s': '66.0177', 'time_total_s': '66.0177', 'training_iteration': '1', 'effective_clk_period': '413.749', 'metric': '41374.9', 'num_drc': '0'}\nTrial variant-AutoTunerBase-87973fd5-ray finished at 2025-02-28 18:45:26 with run time 0:01:08\nTrial variant-AutoTunerBase-dd480f52-ray metrics {'time_this_iter_s': '67.7458', 'time_total_s': '67.7458', 'training_iteration': '1', 'effective_clk_period': '356.868', 'metric': '35686.8', 'num_drc': '0'}\nTrial variant-AutoTunerBase-dd480f52-ray finished at 2025-02-28 18:45:26 with run time 0:01:09\nTrial variant-AutoTunerBase-075315ab-ray metrics {'time_this_iter_s': '66.4617', 'time_total_s': '66.4617', 'training_iteration': '1', 'effective_clk_period': '456.527', 'metric': '45652.7', 'num_drc': '0'}\nTrial variant-AutoTunerBase-075315ab-ray finished at 2025-02-28 18:45:29 with run time 0:01:11\nTrial variant-AutoTunerBase-c9b89a17-ray metrics {'time_this_iter_s': '67.4258', 'time_total_s': '67.4258', 'training_iteration': '1', 'effective_clk_period': '443.497', 'metric': '44349.7', 'num_drc': '0'}\nTrial variant-AutoTunerBase-c9b89a17-ray finished at 2025-02-28 18:45:31 with run time 0:01:13\n"
        script_path = os.path.join(at_src_dir, "scripts", "at_log_extractor.py")
        exec_name = AutoTunerTestUtils.get_exec_cmd(False)
        cmd = exec_name + " " + script_path + " -i " + input_file
        out = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self.assertEqual(out.stdout, exp_result)


if __name__ == "__main__":
    unittest.main()
