#!/usr/bin/env python3

import sys
import argparse

from utils.run_utils import RunUtils
from utils.class_process import Process
from utils.memory_config import MemoryConfig
from utils.memory_factory import MemoryFactory
from utils.timing_data import TimingData


def get_args() -> argparse.Namespace:
    """
    Get command line arguments
    """
    parser = argparse.ArgumentParser(
        description="""
    This project is designed to generate black-boxed SRAMs for use in CAD
    flows where either an SRAM generator is not available or doesn't
    exist.  """
    )
    parser.add_argument("config", help="JSON configuration file")
    parser.add_argument(
        "--output_dir",
        action="store",
        help="Output directory ",
        required=False,
        default="results",
    )
    return parser.parse_args()


def main(args: argparse.Namespace):
    json_data = RunUtils.get_config(args.config)
    # Create a process object (shared by all srams)
    process = Process(json_data)
    timing_data = TimingData(json_data)

    memory_type = json_data.get("memory_type", "RAM")
    port_config = json_data.get("port_configuration", "SP")

    # Go through each sram and generate the lib, lef and v files
    for sram_data in json_data["srams"]:
        mem_config = MemoryConfig.from_json(sram_data)
        memory = MemoryFactory.create(
            mem_config, memory_type, port_config, process, timing_data
        )
        RunUtils.write_memory(memory, args.output_dir)


### Entry point
if __name__ == "__main__":
    args = get_args()
    main(args)
