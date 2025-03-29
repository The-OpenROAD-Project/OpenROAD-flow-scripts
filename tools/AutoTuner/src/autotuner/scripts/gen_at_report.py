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
#
#
# Script to generate AutoTuner results table in Markdown format. The table lists
# the trial name, metric, run time, and order of finish.
#
# The data can either be extract from the AutoTuner log output or from the ORFS
# logs directory for the run.
#
# Usage: gen_at_report.py [-i <autotuner_log_file>|-d <orfs_log_directory>]
#                         -o <output_markdown_file>
#

import argparse
from at_log_extractor import ATLogExtractor
from at_dir_extractor import ATDirExtractor


class GenATReport:
    """AutoTuner Report Generator class"""

    def __init__(self):
        """
        Initializer sets up trial dictionary to store results as well as some
        RE's used to parse the log
        """

        self._trial_dict = {}

    @staticmethod
    def completion_callback(self, trial_name, completion_timestamp, run_time):
        """
        Trial completion callback takes the timestamp and run_time and adds
        it to the trial dictionary.
        """

        if trial_name in self._trial_dict:
            self._trial_dict[trial_name]["run_time"] = run_time
            self._trial_dict[trial_name]["completion_time"] = completion_timestamp
        else:
            print(f"Warning: couldn't find trial {trial_name}. Entering empty metrics")
            self._trial_dict[trial_name] = {
                "name": trial_name,
                "run_time": run_time,
                "metrics": {"metric": 9e99},
                "completion_time": completion_timestamp,
            }

    @staticmethod
    def result_callback(self, trial_name, metrics):
        """
        Result callback annotates the metrics for the trial in the trial
        dictionary
        """

        self._trial_dict[trial_name] = {
            "name": trial_name,
            "metrics": metrics,
        }

    def read_log_file(self, file_name):
        """Calls the log extractor to extract the data"""

        rep = ATLogExtractor(self, self.completion_callback, self.result_callback)
        rep.extract_file(file_name)

    def read_log_dir(self, dir_name):
        """Calls the log directory extractor to extract the data"""

        rep = ATDirExtractor(self, self.completion_callback, self.result_callback)
        rep.extract_dir(dir_name)

    def write_report_file(self, file_name):
        """Opens and writes the report file"""

        with open(file_name, "w") as outfh:
            self._write_report(outfh)

    def _write_report(self, outfh):
        """Writes the report file"""

        ct = 1
        outfh.write("|Trial|metric|Run Time (h:mm:ss)|Finish Order|\n")
        outfh.write("|-|-|-|-|\n")
        # sort by completion time to establish the trial finish order
        for trial_name, trial_data in sorted(
            self._trial_dict.items(), key=lambda item: float(item[1]["completion_time"])
        ):
            # Trials that have invalid configurations still are listed
            # but have no metrics
            if "metric" in trial_data["metrics"]:
                metric = trial_data["metrics"]["metric"]
            else:
                metric = 9e99
            outfh.write(f"|{trial_name}|{metric}|{trial_data['run_time']}|{ct}|\n")
            ct += 1

    @staticmethod
    def main():
        """Standalone test driver"""

        parser = argparse.ArgumentParser(prog="gen_at_report.py")
        parser.add_argument(
            "-i", "--input_file", help="extract results from AutoTuner log file"
        )
        parser.add_argument(
            "-d", "--dir_name", help="extract results from ORFS logs directory"
        )
        parser.add_argument(
            "-o", "--output_file", help="output Markdown file", required=True
        )
        args = parser.parse_args()
        rep = GenATReport()
        if args.input_file or args.dir_name:
            if args.input_file:
                rep.read_log_file(args.input_file)
            else:
                rep.read_log_dir(args.dir_name)
        rep.write_report_file(args.output_file)


if __name__ == "__main__":
    GenATReport.main()
