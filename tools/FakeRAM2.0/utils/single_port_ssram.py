#!/usr/bin/env python3
#

from class_memory import Memory
from ram import RAM
from rw_port_group import RWPortGroup


class SinglePortSSRAM(RAM):
    """
    Class for single port spreadsheet RAM
    """

    def __init__(self, mem_config, process_data, timing_data, num_pins):
        # num pins has to be set prior to the super init since the super init
        # calls get_num_pins
        self._num_pins = num_pins
        process_data.set_calc_dimensions(False)
        RAM.__init__(self, mem_config, process_data, timing_data)

    def get_num_pins(self):
        return self._num_pins

    def write_verilog_file(self, out_file_name, is_blackbox=False):
        """
        Writes a verilog file

        If is_blackbox is set, it writes just the port declarations and a
        blackbox pragma. Otherwise, ignore since we don't know what's in the
        RTL implementation
        """
        if not is_blackbox:
            print("Warning: non-blackbox verilog not supported for spreadsheet input")
            is_blackbox = True
        RAM.write_verilog_file(self, out_file_name, True)
