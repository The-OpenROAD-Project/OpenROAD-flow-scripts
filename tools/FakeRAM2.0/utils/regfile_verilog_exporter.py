#!/usr/bin/env python3

from verilog_exporter import VerilogExporter


class RegFileVerilogExporter(VerilogExporter):
    """Reg file verilog exporter"""

    def __init__(self, memory):
        """Initializer"""
        VerilogExporter.__init__(self, memory)

    def export_module(self, out_fh):
        """Exports the verilog module to the output stream"""

        self.write_module_header(out_fh)
        self.write_always(out_fh)
        out_fh.write("endmodule\n")

    def write_rw_port_always(self, rw_port_group, out_fh):
        """Writes the always @ section for the port group"""

        suffix = rw_port_group.get_suffix()
        clk_pin_name = rw_port_group.get_clock_name()
        out_fh.write(f"    // Synchronous Port {suffix.upper()}\n")
        out_fh.write(f"     always @(posedge {clk_pin_name}) begin\n")
        out_fh.write(f"        if ({rw_port_group.get_write_enable_name()}) begin\n")
        out_fh.write(
            f"            mem[{rw_port_group.get_address_bus_name()}] <= {rw_port_group.get_data_input_bus_name()};\n"
        )
        out_fh.write("        end\n")
        out_fh.write(
            f"        {rw_port_group.get_data_output_bus_name()} <= mem[{rw_port_group.get_address_bus_name()}];  // Read occurs after write (read-after-write OK)\n"
        )
        out_fh.write("    end\n")
        out_fh.write("\n")
