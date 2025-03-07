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
import time
import argparse
import json
from at_extractor_base import ATExtractorBase


class ATDirExtractor(ATExtractorBase):
    def __init__(self, obj, completion_cbk, result_cbk):
        """Initializer"""

        super().__init__(obj, completion_cbk, result_cbk)

    def extract_dir(self, dir_name):
        """Extracts the data from the log directory"""

        for trial_name in os.listdir(dir_name):
            if trial_name.startswith("variant-AutoTunerBase-") and trial_name.endswith(
                "-ray"
            ):
                self._extract_dir(trial_name, os.path.join(dir_name, trial_name))

    def _extract_dir(self, trial_name, dir_name):
        """Extracts the data from the result.json file"""

        results_file = os.path.join(dir_name, "result.json")
        if os.path.exists(results_file):
            with open(results_file, "r") as fh:
                data = json.load(fh)
                metrics = data.copy()
                metrics["metric"] = round(metrics["metric"], 1)
                self._result_cbk(self._obj, trial_name, metrics)
                run_time = time.strftime(
                    "%H:%M:%S", time.gmtime(data["time_this_iter_s"])
                )
                self._completion_cbk(self._obj, trial_name, data["timestamp"], run_time)

    @staticmethod
    def main():
        """Standalone test driver"""
        parser = argparse.ArgumentParser(prog="at_dir_extractor.py")
        parser.add_argument(
            "-d",
            "--dir_name",
            help="ORFS log directory for  AutoTuner run",
            required=True,
        )
        args = parser.parse_args()
        rep = ATDirExtractor(
            None,
            ATExtractorBase.sample_completion_callback,
            ATExtractorBase.sample_results_callback,
        )
        rep.extract_dir(args.dir_name)


if __name__ == "__main__":
    ATDirExtractor.main()
    sys.exit(0)
