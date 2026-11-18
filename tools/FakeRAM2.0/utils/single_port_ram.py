#!/usr/bin/env python3
#
# The Verilog, LEF and Liberty output for the single port RAM matches the
# previous implementation for backward compatibility
#

from class_memory import Memory
from ram import RAM
from single_port_ram_verilog_exporter import SinglePortRAMVerilogExporter
from single_port_ram_liberty_exporter import SinglePortRAMLibertyExporter
from rw_port_group import RWPortGroup


class SinglePortRAM(RAM):
    """
    Class for single port RAM

    RAM has the following pins/busses

    output [DATA_WIDTH-1:0]  rd_out
    input  [ADDR_WIDTH-1:0]  addr_in
    input                    we_in
    input  [DATA_WIDTH-1:0]  wd_in
    input                    clk
    input                    ce_in
    """

    def __init__(self, mem_config, process_data, timing_data):
        """
        Initializer

        Parameters:
        mem_config (MemoryConfig): memory parameter container
        process_data (Process): process data container
        timing_data (TimingData): timing data container
        """
        RAM.__init__(self, mem_config, process_data, timing_data)
        rw_port_group = RWPortGroup()
        names = mem_config.get_pin_names()
        rw_port_group.set_write_enable_name(names.get("we", "we_in"))
        rw_port_group.set_address_bus_name(names.get("addr", "addr_in"))
        rw_port_group.set_data_input_bus_name(names.get("din", "wd_in"))
        rw_port_group.set_data_output_bus_name(names.get("dout", "rd_out"))
        rw_port_group.set_clock_name(names.get("clk", "clk"))
        if self.mask_lanes:
            rw_port_group.set_write_mask_bus(
                names.get("mask", "w_mask_in"), self.mask_lanes
            )
        self.add_rw_port_group(rw_port_group)
        self.add_misc_port(names.get("ce", "ce_in"))
        self.create_ports()

    def get_num_pins(self):
        """Returns the total number of logical pins"""
        # rd_out (#bits) + wd_in (#bits) + addr_in (#addr_width) + we_in/ce_in/clk
        return (2 * self.get_width()) + self.get_addr_width() + 3 + self.mask_lanes

    def write_verilog_file(self, out_file_name, is_blackbox=False):
        """
        Writes a verilog file

        If is_blackbox is set, it writes just the port declarations and a
        blackbox pragma. Otherwise, it writes the full RTL.
        """
        exporter = SinglePortRAMVerilogExporter(self)
        exporter.export_file(out_file_name, is_blackbox)

    def write_liberty_file(self, out_file_name):
        """Writes a Liberty file"""
        exporter = SinglePortRAMLibertyExporter(self)
        exporter.export_file(out_file_name)


if __name__ == "__main__":  # pragma: nocover
    Memory.main("RAM", "SP")
