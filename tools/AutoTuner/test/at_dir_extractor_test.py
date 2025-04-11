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
from scripts.at_dir_extractor import ATDirExtractor
from autotuner_test_utils import AutoTunerTestUtils


class ATDirExtractorTest(unittest.TestCase):
    """Tests ATDirExtractor methods"""

    def setUp(self):
        """
        Per-test setup defines the rep being tested and various example data
        """

        self._rep = ATDirExtractor(None, None, None)

    def test_flow(self):
        """Flow test executes the script directly"""

        dir_name = os.path.join(test_dir, "files", "tune-cce4569e")
        exp_result = "Trial variant-AutoTunerBase-075315ab-ray metrics {'metric': 45652.7, 'effective_clk_period': 456.52660000000003, 'num_drc': 0, 'done': True, 'training_iteration': 1, 'trial_id': '075315ab', 'date': '2025-02-28_18-45-29', 'timestamp': 1740768329, 'time_this_iter_s': 66.46166968345642, 'time_total_s': 66.46166968345642, 'pid': 3638, 'hostname': '047ec088fde6', 'node_ip': '172.17.0.2', 'config': {'_SDC_CLK_PERIOD': 473.2410618568929, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 1, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 0, '_FR_LAYER_ADJUST': 0.13110212203998772, 'PLACE_DENSITY_LB_ADDON': 0.03452145105773252, 'CTS_CLUSTER_SIZE': 84, 'CTS_CLUSTER_DIAMETER': 186}, 'time_since_restore': 66.46166968345642, 'iterations_since_restore': 1}\nTrial variant-AutoTunerBase-075315ab-ray finished at 2025-02-28 18:45:29 with run time 00:01:06\nTrial variant-AutoTunerBase-c9b89a17-ray metrics {'metric': 44349.7, 'effective_clk_period': 443.4968, 'num_drc': 0, 'done': True, 'training_iteration': 1, 'trial_id': 'c9b89a17', 'date': '2025-02-28_18-45-31', 'timestamp': 1740768331, 'time_this_iter_s': 67.42584133148193, 'time_total_s': 67.42584133148193, 'pid': 3945, 'hostname': '047ec088fde6', 'node_ip': '172.17.0.2', 'config': {'_SDC_CLK_PERIOD': 449.5242250663756, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 1, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 1, '_FR_LAYER_ADJUST': 0.15849402425181552, 'PLACE_DENSITY_LB_ADDON': 0.17873876655922555, 'CTS_CLUSTER_SIZE': 158, 'CTS_CLUSTER_DIAMETER': 60}, 'time_since_restore': 67.42584133148193, 'iterations_since_restore': 1}\nTrial variant-AutoTunerBase-c9b89a17-ray finished at 2025-02-28 18:45:31 with run time 00:01:07\nTrial variant-AutoTunerBase-dd480f52-ray metrics {'metric': 35686.8, 'effective_clk_period': 356.8677, 'num_drc': 0, 'done': True, 'training_iteration': 1, 'trial_id': 'dd480f52', 'date': '2025-02-28_18-45-26', 'timestamp': 1740768326, 'time_this_iter_s': 67.7457926273346, 'time_total_s': 67.7457926273346, 'pid': 2886, 'hostname': '047ec088fde6', 'node_ip': '172.17.0.2', 'config': {'_SDC_CLK_PERIOD': 233.75674387733073, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 1, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 1, '_FR_LAYER_ADJUST': 0.28857429823519476, 'PLACE_DENSITY_LB_ADDON': 0.15872338201602781, 'CTS_CLUSTER_SIZE': 28, 'CTS_CLUSTER_DIAMETER': 291}, 'time_since_restore': 67.7457926273346, 'iterations_since_restore': 1}\nTrial variant-AutoTunerBase-dd480f52-ray finished at 2025-02-28 18:45:26 with run time 00:01:07\nTrial variant-AutoTunerBase-87973fd5-ray metrics {'metric': 41374.9, 'effective_clk_period': 413.74916, 'num_drc': 0, 'done': True, 'training_iteration': 1, 'trial_id': '87973fd5', 'date': '2025-02-28_18-45-26', 'timestamp': 1740768326, 'time_this_iter_s': 66.01769185066223, 'time_total_s': 66.01769185066223, 'pid': 2975, 'hostname': '047ec088fde6', 'node_ip': '172.17.0.2', 'config': {'_SDC_CLK_PERIOD': 416.7950151956536, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 2, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 1, '_FR_LAYER_ADJUST': 0.21077117188315186, 'PLACE_DENSITY_LB_ADDON': 0.13859111392097342, 'CTS_CLUSTER_SIZE': 174, 'CTS_CLUSTER_DIAMETER': 61}, 'time_since_restore': 66.01769185066223, 'iterations_since_restore': 1}\nTrial variant-AutoTunerBase-87973fd5-ray finished at 2025-02-28 18:45:26 with run time 00:01:06\nTrial variant-AutoTunerBase-85b217fd-ray metrics {'metric': 9e+99, 'effective_clk_period': '-', 'num_drc': '-', 'done': True, 'training_iteration': 1, 'trial_id': '85b217fd', 'date': '2025-02-28_18-44-21', 'timestamp': 1740768261, 'time_this_iter_s': 6.198883056640625e-06, 'time_total_s': 6.198883056640625e-06, 'pid': 3095, 'hostname': '047ec088fde6', 'node_ip': '172.17.0.2', 'config': {'_SDC_CLK_PERIOD': 207.66851891516706, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 0, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 1, '_FR_LAYER_ADJUST': 0.19970414187072266, 'PLACE_DENSITY_LB_ADDON': 0.005515654817257154, 'CTS_CLUSTER_SIZE': 34, 'CTS_CLUSTER_DIAMETER': 174}, 'time_since_restore': 6.198883056640625e-06, 'iterations_since_restore': 1}\nTrial variant-AutoTunerBase-85b217fd-ray finished at 2025-02-28 18:44:21 with run time 00:00:00\n"
        script_path = os.path.join(at_src_dir, "scripts", "at_dir_extractor.py")
        exec_name = AutoTunerTestUtils.get_exec_cmd(False)
        cmd = exec_name + " " + script_path + " -d " + dir_name
        out = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        self.assertEqual(out.returncode, 0)
        self.assertEqual(out.stdout, exp_result)


if __name__ == "__main__":
    unittest.main()
