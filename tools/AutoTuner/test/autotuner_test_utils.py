#!/usr/bin/env python3

import os


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
