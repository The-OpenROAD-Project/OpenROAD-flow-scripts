#!/usr/bin/env python3

import os


class TestUtils:
    @staticmethod
    def get_base_process_data():
        """Returns dict with process data"""
        return {
            "tech_nm": 7,
            "voltage": 0.7,
            "metal_prefix": "M",
            "metal_layer": "M4",
            "pin_width_nm": 24,
            "pin_pitch_nm": 48,
            "metal_track_pitch_nm": 48,
            "contacted_poly_pitch_nm": 54,
            "column_mux_factor": 1,
            "fin_pitch_nm": 27,
            "manufacturing_grid_nm": 1,
            "snap_width_nm": 190,
            "snap_height_nm": 1400,
        }

    @staticmethod
    def get_exec_name(exec_name):
        """
        Returns the exec name, which includes the coverage command, if
        coverage is enabled
        """

        if "COVERAGE_RUN" in os.environ:
            exec_cmd = "coverage run --parallel-mode " + exec_name
        else:  # pragma: nocover
            exec_cmd = exec_name
        return exec_cmd
