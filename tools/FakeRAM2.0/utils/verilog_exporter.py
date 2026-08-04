#!/usr/bin/env python3

from exporter import Exporter


class VerilogExporter(Exporter):
    """
    Verilog exporter base

    The blackbox support is required since yosys doesn't pipe the RAM module
    definition when using Verific. yosys-slang doesn't require the definition.
    """

    def __init__(self, memory):
        """Initializer"""

        Exporter.__init__(self, memory)

    def export_file(self, file_name, is_blackbox=False):
        """
        Exports the verilog content to a file.

        If is_blackbox, only write the port definitions. Otherwise, write the
        full RTL
        """

        with open(file_name, "w") as out_fh:
            self.export(out_fh, is_blackbox)

    def export(self, out_fh, is_blackbox=False):
        """
        Exports the verilog content to an output stream.

        If is_blackbox, only write the port definitions. Otherwise, write the
        full RTL
        """
        if is_blackbox:
            self.export_blackbox(out_fh)
        else:
            self.export_module(out_fh)

    # -------------- Utilities --------------
    def write_module_header(self, out_fh):
        """Writes the module header"""

        mem = self.get_memory()
        out_fh.write(f"module {mem.get_name()}\n")
        out_fh.write("(\n")
        clk_pin_name = mem.get_rw_port_groups()[0].get_clock_name()
        for index, rw_port_group in enumerate(mem.get_rw_port_groups()):
            self.write_rw_port_decl_set(rw_port_group, out_fh, index)
        self.write_misc_decl_set(mem, out_fh)
        out_fh.write("\n);\n")
        out_fh.write(f"    parameter DATA_WIDTH = {mem.get_width()};\n")
        out_fh.write(f"    parameter ADDR_WIDTH = {mem.get_addr_width()};\n")
        out_fh.write("\n")
        for rw_port_group in mem.get_rw_port_groups():
            self.write_rw_port_defn_set(rw_port_group, out_fh)
        self.write_misc_defn_set(mem, out_fh)
        out_fh.write("\n")
        out_fh.write(
            f"    // Memory array: {mem.get_depth()} words of {mem.get_width()} bits\n"
        )
        out_fh.write("    reg [DATA_WIDTH-1:0] mem [0:(1 << ADDR_WIDTH)-1];\n")
        out_fh.write("\n")

    def write_always(self, out_fh):
        """Writes the always section for the memory"""

        for rw_port_group in self.get_memory().get_rw_port_groups():
            self.write_rw_port_always(rw_port_group, out_fh)

    def write_rw_port_decl_set(self, rw_port_group, out_fh, index):
        """
        Writes the RW port group declarations

        index is used to determine if we need to add a comma and a new line
        since we don't write it out for the clock pin in case this rw_port_group
        is the last one
        """

        if index != 0:
            out_fh.write(",\n")
        if rw_port_group.get_write_enable_name():
            out_fh.write(f"    {rw_port_group.get_write_enable_name()},\n")
        if rw_port_group.get_address_bus_name():
            out_fh.write(f"    {rw_port_group.get_address_bus_name()},\n")
        if rw_port_group.get_data_input_bus_name():
            out_fh.write(f"    {rw_port_group.get_data_input_bus_name()},\n")
        if rw_port_group.get_data_output_bus_name():
            out_fh.write(f"    {rw_port_group.get_data_output_bus_name()},\n")
        if rw_port_group.get_clock_name():
            out_fh.write(f"    {rw_port_group.get_clock_name()}")
        for port_name in rw_port_group.get_related_pins():
            out_fh.write(f"    {port_name}")
        for bus_name in rw_port_group.get_related_busses():
            out_fh.write(f"    {bus_name}")
            

    def write_misc_decl_set(self, mem, out_fh):
        """Write the misc bus/port declarations"""

        for bus_name, bus_data in mem.get_misc_busses().items():
            out_fh.write(f"\n,   {bus_name}")
        for pin in sorted(mem.get_misc_ports()):
            out_fh.write(f"\n,   {pin}")

    def write_rw_port_defn_set(self, rw_port_group, out_fh):
        """Writes the RW port group definitions"""

        suffix = rw_port_group.get_suffix()
        out_fh.write(f"    // Port {suffix.upper()}\n")
        if rw_port_group.get_write_enable_name():
            out_fh.write(
                f"    input  wire                     {rw_port_group.get_write_enable_name()};\n"
            )
        if rw_port_group.get_address_bus_name():
            out_fh.write(
                f"    input  wire [ADDR_WIDTH-1:0]    {rw_port_group.get_address_bus_name()};\n"
            )
        if rw_port_group.get_data_input_bus_name():
            out_fh.write(
                f"    input  wire [DATA_WIDTH-1:0]    {rw_port_group.get_data_input_bus_name()};\n"
            )
        if rw_port_group.get_data_output_bus_name():
            out_fh.write(
                f"    output reg  [DATA_WIDTH-1:0]    {rw_port_group.get_data_output_bus_name()};\n"
            )
        if rw_port_group.get_clock_name():
            out_fh.write(
                f"    input  wire                     {rw_port_group.get_clock_name()};\n"
            )
        for pin_name in rw_port_group.get_related_pins():
            out_fh.write(
                f"    input  wire                     {pin_name};\n"
            )
        for bus_name,bus_data in rw_port_group.get_related_busses().items():
            out_fh.write(
                f"    input  wire [{bus_data['msb']}:{bus_data['lsb']}] {bus_name};\n"
            )
            
        out_fh.write("\n")

    def write_misc_defn_set(self, mem, out_fh):
        """Write the misc bus/port definitions"""

        for bus_name, bus_data in mem.get_misc_busses().items():
            out_fh.write(
                f"    input wire [{bus_data['msb']}:{bus_data['lsb']}] {bus_name};\n"
            )
        for pin in sorted(mem.get_misc_ports()):
            out_fh.write(f"    input wire                     {pin};\n")

    def export_bb_header(self, out_fh):
        """Writes the SystemVerilog blackbox header"""

        out_fh.write("(* blackbox *)\n")
        out_fh.write("module {} (\n".format(self.get_memory().get_name()))

    def export_bb_footer(self, out_fh):
        """Writes the SystemVerilog blackbox footer"""

        out_fh.write(");\n")
        out_fh.write("endmodule\n")

    def export_bb_port_decl_set(self, rw_port_group, out_fh, index):
        """Writes the SystemVerilog port declarations"""

        mem = self.get_memory()
        addr_bus_msb = mem.get_addr_bus_msb()
        data_bus_msb = mem.get_data_bus_msb()
        if index != 0:
            out_fh.write(",\n")
        if rw_port_group.get_write_enable_name():
            out_fh.write(f"    input {rw_port_group.get_write_enable_name()},\n")
        if rw_port_group.get_address_bus_name():
            out_fh.write(
                f"    input [{addr_bus_msb}:0] {rw_port_group.get_address_bus_name()},\n"
            )
        if rw_port_group.get_data_input_bus_name():
            out_fh.write(
                f"    input [{data_bus_msb}:0] {rw_port_group.get_data_input_bus_name()},\n"
            )
        if rw_port_group.get_data_output_bus_name():
            out_fh.write(
                f"    output reg [{data_bus_msb}:0] {rw_port_group.get_data_output_bus_name()},\n"
            )
        for pin_name in rw_port_group.get_related_pins():
            out_fh.write(
                f"    input {pin_name},\n"
            )
        for bus_name, bus_data in rw_port_group.get_related_busses().items():
            out_fh.write(
                f"    input [{bus_data['msb']}:{bus_data['lsb']}] {bus_name},\n"
            )
        if rw_port_group.get_clock_name():
            out_fh.write(f"    input {rw_port_group.get_clock_name()}")

    def export_blackbox(self, out_fh):
        """Writes the blackbox content to the output stream"""

        self.export_bb_header(out_fh)
        for index, rw_port_group in enumerate(self.get_memory().get_rw_port_groups()):
            self.export_bb_port_decl_set(rw_port_group, out_fh, index)
        for bus_name, bus_data in self.get_memory().get_misc_busses().items():
            out_fh.write(
                f",\n    input [{bus_data['msb']}:{bus_data['lsb']}] {bus_name}"
            )
        for pin in sorted(self.get_memory().get_misc_ports()):
            out_fh.write(f",\n    input {pin}")
        out_fh.write("\n")
        self.export_bb_footer(out_fh)
