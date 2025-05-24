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
import sys
import argparse
from datetime import datetime
from at_extractor_base import ATExtractorBase


class ATLogExtractor(ATExtractorBase):
    """Class to extract AutoTuner results from the AutoTuner output"""

    def __init__(self, obj, completion_cbk, result_cbk):
        """Initializes RE's to parse log file"""

        super().__init__(obj, completion_cbk, result_cbk)
        self._trial_completed_re = re.compile(
            "Trial\s+(\S+)\s+completed\s+after\s+\d+\s+iterations\s+at\s+(\S+)\s+(\S+)\.\s+Total\s+running\s+time\:\s+((\d+)h\s+)?((\d+)min\s+)?(\d+)s"
        )
        self._trial_result_table_start_re = re.compile("Trial\s+(\S+)\s+result")
        self._trial_result_table_metric_re = re.compile("\s+(\w+)\s+(-?\d+(\.\d+)?)\s+")

    def extract_file(self, file_name):
        """Opens and reads the log file to populate the trial dictionary"""

        with open(file_name, "r") as fh:
            self._extract(fh)

    ### Private API

    def _get_timestamp(self, date_str, time_str):
        """Converts the date and time strings to a timestamp"""

        date_time_str = f"{date_str} {time_str}"
        date_time_obj = datetime.strptime(date_time_str, "%Y-%m-%d %H:%M:%S")
        return date_time_obj.timestamp()

    def _read_result_table(self, fh, trial_name):
        """Reads the metrics from the results table and returns it in a dict"""

        metrics = {}
        line = fh.readline()
        while line:
            if line == "\n":
                return metrics
            result = self._trial_result_table_metric_re.search(line)
            if result:
                metric_name = result.group(1)
                metric_value = result.group(2)
                metrics[metric_name] = metric_value
            line = fh.readline()

    def _add_completed_trial(self, result):
        """Extracts results from RE and adds data to trial dictionary"""

        trial_name = result.group(1)
        completion_date = result.group(2)
        completion_time = result.group(3)
        run_time = self._get_runtime(result)
        completion_timestamp = self._get_timestamp(completion_date, completion_time)
        self._completion_cbk(self._obj, trial_name, completion_timestamp, run_time)

    def _add_result(self, fh, trial_name):
        """Extracts results from table and calls result callback"""

        metrics = self._read_result_table(fh, trial_name)
        self._result_cbk(self._obj, trial_name, metrics)

    def _extract(self, fh):
        """Parses the stream and extracts the data"""

        for line in fh:
            result = self._trial_completed_re.match(line)
            if result:
                self._add_completed_trial(result)
            else:
                result = self._trial_result_table_start_re.search(line)
                if result:
                    trial_name = result.group(1)
                    self._add_result(fh, trial_name)

    def _get_runtime(self, result):
        """
        Returns the runtime string in h:mm:ss format, based on the RE match
        input
        """

        runtime_hr = runtime_min = runtime_sec = 0
        # 4 is the optional wrapper around hours
        # 5 is the hours
        if result.group(4):
            runtime_hr = int(result.group(5))
        # 6 is the optional wrapper around mins
        # 7 is the minutes
        if result.group(6):
            runtime_min = int(result.group(7))
        runtime_sec = int(result.group(8))
        run_time = f"{runtime_hr}:{runtime_min:02}:{runtime_sec:02}"
        return run_time

    @staticmethod
    def main():  # pragma: nocover
        """Standalone test driver"""

        parser = argparse.ArgumentParser(prog="at_log_extractor.py")
        parser.add_argument(
            "-i", "--input_file", help="log file from AutoTuner", required=True
        )
        args = parser.parse_args()
        rep = ATLogExtractor(
            None,
            ATExtractorBase.sample_completion_callback,
            ATExtractorBase.sample_results_callback,
        )
        rep.extract_file(args.input_file)


if __name__ == "__main__":  # pragma: nocover
    ATLogExtractor.main()
    sys.exit(0)
