#!/usr/bin/env python3

import os
import json
from pathlib import Path


class RunUtils:
    @staticmethod
    def get_config(config_file):
        """Load the JSON configuration file"""

        with open(config_file, "r") as fid:
            raw = [line.strip() for line in fid if not line.strip().startswith("#")]
        json_data = json.loads("\n".join(raw))
        return json_data

    @staticmethod
    def ensure_results_dir(output_dir, memory_name):
        """Ensures that the results directory exists"""

        p = str(Path(output_dir).expanduser().resolve(strict=False))
        results_dir = os.sep.join([p, memory_name])
        if not os.path.exists(results_dir):
            os.makedirs(results_dir)
        return results_dir

    @staticmethod
    def get_output_file_names(memory_name, output_dir):
        """
        Returns the full paths to the output file names using the memory name
        as the base name
        """

        results_dir = RunUtils.ensure_results_dir(output_dir, memory_name)
        lib_file_name = os.path.join(results_dir, memory_name + ".lib")
        lef_file_name = os.path.join(results_dir, memory_name + ".lef")
        verilog_file_name = os.path.join(results_dir, memory_name + ".v")
        sv_blackbox_file_name = os.path.join(results_dir, memory_name + ".sv")
        return (lib_file_name, lef_file_name, verilog_file_name, sv_blackbox_file_name)

    @staticmethod
    def write_memory(memory, output_dir):
        """Generates the output file names and then writes the files"""

        (lib_file_name, lef_file_name, verilog_file_name, sv_blackbox_file_name) = (
            RunUtils.get_output_file_names(memory.get_name(), output_dir)
        )
        RunUtils.write_all(
            memory,
            lib_file_name,
            lef_file_name,
            verilog_file_name,
            sv_blackbox_file_name,
        )

    @staticmethod
    def write_all(
        memory, lib_file_name, lef_file_name, verilog_file_name, sv_blackbox_file_name
    ):
        """Writes the files"""

        memory.write_liberty_file(lib_file_name)
        memory.write_lef_file(lef_file_name)
        memory.write_verilog_file(verilog_file_name)
        memory.write_verilog_file(sv_blackbox_file_name, True)
