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

# Accepted RC: success and failed with no valid results.
accepted_rc = [0, 16]


class AutoTunerTestUtils:
    @staticmethod
    def get_exec_cmd():
        """
        Returns the execution command based on whether this is a coverage run or
        not.

        Note that you need to run coverage combine after the runs complete to
        get the coverage of the parent plus the child invocations
        """

        if "COVERAGE_RUN" in os.environ:
            exec = "coverage run --parallel-mode --omit=*/site-packages/*,*/dist-packages/*"
        else:  # pragma: no cover
            exec = "python3"
        return exec + " -m autotuner.distributed"


if __name__ == "__main__":  # pragma: no cover
    print(AutoTunerTestUtils.get_exec_cmd())
