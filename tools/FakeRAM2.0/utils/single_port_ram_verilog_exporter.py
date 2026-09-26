#!/usr/bin/env python3

from verilog_exporter import VerilogExporter


class SinglePortRAMVerilogExporter(VerilogExporter):
    """
    Single port RAM verilog exporter. Differs from others for backward
    compatibility
    """

    def __init__(self, memory):
        """Initializer"""
        VerilogExporter.__init__(self, memory)

    def _get_names(self):
        mem = self.get_memory()
        rw_port_group = mem.get_rw_port_groups()[0]
        addr_bus = rw_port_group.get_address_bus_name()
        din_bus = rw_port_group.get_data_input_bus_name()
        dout_bus = rw_port_group.get_data_output_bus_name()
        we_pin = rw_port_group.get_write_enable_name()
        clk_pin = rw_port_group.get_clock_name()
        ce_pin = next(iter(mem.get_misc_ports()))
        return (addr_bus, din_bus, dout_bus, we_pin, clk_pin, ce_pin)

    def export_module(self, out_fh):
        """Exports the verilog module to the output stream"""

        mem = self.get_memory()
        addr_bus, din_bus, dout_bus, we_pin, clk_pin, ce_pin = self._get_names()
        out_fh.write(f"module {mem.get_name()}\n")
        self.write_module_ports(out_fh)
        out_fh.write("   reg    [BITS-1:0]        mem [0:WORD_DEPTH-1];\n")
        out_fh.write("\n")
        out_fh.write("   integer j;\n")
        out_fh.write("\n")
        out_fh.write(f"   always @(posedge {clk_pin})\n")
        out_fh.write("   begin\n")
        out_fh.write(f"      if ({ce_pin})\n")
        out_fh.write("      begin\n")
        out_fh.write(
            f"         //if (({we_pin} !== 1'b1 && {we_pin} !== 1'b0) && corrupt_mem_on_X_p)\n"
        )
        out_fh.write("         if (corrupt_mem_on_X_p &&\n")
        out_fh.write(f"             ((^{we_pin} === 1'bx) || (^{addr_bus} === 1'bx))\n")
        out_fh.write("            )\n")
        out_fh.write("         begin\n")
        out_fh.write(
            "            // WEN or ADDR is unknown, so corrupt entire array (using unsynthesizeable for loop)\n"
        )
        out_fh.write("            for (j = 0; j < WORD_DEPTH; j = j + 1)\n")
        out_fh.write("               mem[j] <= 'x;\n")
        out_fh.write(
            f'            $display("warning: {ce_pin}=1, {we_pin} is %b, {addr_bus} = %x in '
            + mem.get_name()
            + f'", {we_pin}, {addr_bus});\n'
        )
        out_fh.write("         end\n")
        out_fh.write(f"         else if ({we_pin})\n")
        out_fh.write("         begin\n")
        out_fh.write(f"            mem[{addr_bus}] <= {din_bus};\n")
        out_fh.write("         end\n")
        out_fh.write("         // read\n")
        out_fh.write(f"         {dout_bus} <= mem[{addr_bus}];\n")
        out_fh.write("      end\n")
        out_fh.write("      else\n")
        out_fh.write("      begin\n")
        out_fh.write(f"         // Make sure read fails if {ce_pin} is low\n")
        out_fh.write(f"         {dout_bus} <= 'x;\n")
        out_fh.write("      end\n")
        out_fh.write("   end\n")
        out_fh.write("\n")
        self.write_timing_check(out_fh)
        out_fh.write("endmodule\n")

    def write_module_ports(self, out_fh):
        """Writes the module port declarations"""

        mem = self.get_memory()
        addr_bus, din_bus, dout_bus, we_pin, clk_pin, ce_pin = self._get_names()
        out_fh.write("(\n")
        out_fh.write(f"   {dout_bus},\n")
        out_fh.write(f"   {addr_bus},\n")
        out_fh.write(f"   {we_pin},\n")
        out_fh.write(f"   {din_bus},\n")
        out_fh.write(f"   {clk_pin},\n")
        out_fh.write(f"   {ce_pin}\n")
        out_fh.write(");\n")
        out_fh.write(f"   parameter BITS = {mem.get_width()};\n")
        out_fh.write(f"   parameter WORD_DEPTH = {mem.get_depth()};\n")
        out_fh.write(f"   parameter ADDR_WIDTH = {mem.get_addr_width()};\n")
        out_fh.write(f"   parameter corrupt_mem_on_X_p = 1;\n")
        out_fh.write("\n")
        out_fh.write(f"   output reg [BITS-1:0]    {dout_bus};\n")
        out_fh.write(f"   input  [ADDR_WIDTH-1:0]  {addr_bus};\n")
        out_fh.write(f"   input                    {we_pin};\n")
        out_fh.write(f"   input  [BITS-1:0]        {din_bus};\n")
        out_fh.write(f"   input                    {clk_pin};\n")
        out_fh.write(f"   input                    {ce_pin};\n")
        out_fh.write("\n")

    def write_timing_check(self, out_fh):
        """Writes timing check placeholder data"""

        addr_bus, din_bus, dout_bus, we_pin, clk_pin, ce_pin = self._get_names()
        out_fh.write(
            "   // Timing check placeholders (will be replaced during SDF back-annotation)\n"
        )
        out_fh.write("   reg notifier;\n")
        out_fh.write("   specify\n")
        out_fh.write("      // Timing checks\n")
        out_fh.write(
            f"      $width     (posedge {clk_pin},            0, 0, notifier);\n"
        )
        out_fh.write(
            f"      $width     (negedge {clk_pin},            0, 0, notifier);\n"
        )
        out_fh.write(
            f"      $period    (posedge {clk_pin},            0,    notifier);\n"
        )
        out_fh.write(
            f"      $setuphold (posedge {clk_pin}, {we_pin},     0, 0, notifier);\n"
        )
        out_fh.write(
            f"      $setuphold (posedge {clk_pin}, {ce_pin},     0, 0, notifier);\n"
        )
        out_fh.write(
            f"      $setuphold (posedge {clk_pin}, {addr_bus},   0, 0, notifier);\n"
        )
        out_fh.write(
            f"      $setuphold (posedge {clk_pin}, {din_bus},     0, 0, notifier);\n"
        )
        out_fh.write("   endspecify\n")
        out_fh.write("\n")

    def export_blackbox(self, out_fh):
        """Exports the SystemVerilog blackbox to the output stream"""

        mem = self.get_memory()
        addr_bus, din_bus, dout_bus, we_pin, clk_pin, ce_pin = self._get_names()
        addr_bus_msb = mem.get_addr_bus_msb()
        data_bus_msb = mem.get_data_bus_msb()
        self.export_bb_header(out_fh)
        out_fh.write(f"   output reg [{data_bus_msb}:0] {dout_bus},\n")
        out_fh.write(f"   input [{addr_bus_msb}:0] {addr_bus},\n")
        out_fh.write(f"   input {we_pin},\n")
        out_fh.write(f"   input [{data_bus_msb}:0] {din_bus},\n")
        out_fh.write(f"   input {clk_pin},\n")
        out_fh.write(f"   input {ce_pin}\n")
        self.export_bb_footer(out_fh)
