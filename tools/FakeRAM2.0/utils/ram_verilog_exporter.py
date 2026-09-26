#!/usr/bin/env python3

from verilog_exporter import VerilogExporter


class RAMVerilogExporter(VerilogExporter):
    """RAM verilog exporter"""

    def __init__(self, memory):
        """Initializer"""
        VerilogExporter.__init__(self, memory)

    def export_module(self, out_fh):
        """Exports the verilog module to the output stream"""

        clk_pin_name = self.get_memory().get_rw_port_groups()[0].get_clock_name()
        self.write_module_header(out_fh)
        out_fh.write("    // Registers for synchronous reads\n")
        out_fh.write("    reg [ADDR_WIDTH-1:0] addr_a_reg;\n")
        out_fh.write("    reg [ADDR_WIDTH-1:0] addr_b_reg;\n")
        out_fh.write("\n")
        out_fh.write("    integer i;\n")
        out_fh.write("\n")
        out_fh.write(f"    always @(posedge {clk_pin_name}) begin\n")
        self.write_always(out_fh)
        self.write_readback(out_fh)
        out_fh.write("    end\n")
        out_fh.write("endmodule\n")

    def write_rw_port_always(self, rw_port_group, out_fh):
        """Writes the always @ section for the port group"""

        suffix = rw_port_group.get_suffix()
        out_fh.write(f"        // ==== Port {suffix.upper()} write ====\n")
        out_fh.write(
            f"        if (^{rw_port_group.get_write_enable_name()} === 1'bx || ^{rw_port_group.get_address_bus_name()} === 1'bx) begin\n"
        )
        out_fh.write(
            "            // Unknown write enable or address ? corrupt entire memory\n"
        )
        out_fh.write("            for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1)\n")
        out_fh.write("                mem[i] <= {DATA_WIDTH{1'bx}};\n")
        out_fh.write(
            f"        end else if ({rw_port_group.get_write_enable_name()}) begin\n"
        )
        out_fh.write(
            f"            mem[{rw_port_group.get_address_bus_name()}] <= {rw_port_group.get_data_input_bus_name()};\n"
        )
        out_fh.write("        end\n")

    def write_readback(self, out_fh):
        """Writes the readback section for the memory"""

        out_fh.write("        // Synchronous readback\n")
        for rw_port_group in self.get_memory().get_rw_port_groups():
            self.write_rw_port_readback(rw_port_group, out_fh)

    def write_rw_port_readback(self, rw_port_group, out_fh):
        """Writes readback section for the port group"""

        out_fh.write(
            f"        {rw_port_group.get_address_bus_name()}_reg <= {rw_port_group.get_address_bus_name()};\n"
        )
        out_fh.write(
            f"        {rw_port_group.get_data_output_bus_name()} <= mem[{rw_port_group.get_address_bus_name()}_reg];\n"
        )
