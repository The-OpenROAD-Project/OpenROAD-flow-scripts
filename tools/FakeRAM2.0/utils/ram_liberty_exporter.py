#!/usr/bin/env python3

from liberty_exporter import LibertyExporter


class RAMLibertyExporter(LibertyExporter):
    """RAM Liberty Exporter"""

    def __init__(self, memory):
        """Initializer"""
        LibertyExporter.__init__(self, memory)

    def write_cell(self, out_fh):
        """
        Writes the Liberty cell

        Difference is that we pass True to the rw_pin_set writer to indicate
        that this is a RAM.
        """

        name = self._memory.get_name()
        self.write_memory_section(out_fh)
        clk_pin_name = None
        for rw_port_group in self._memory.get_rw_port_groups():
            self.write_rw_pin_set(out_fh, name, rw_port_group, True)
            if not clk_pin_name:
                clk_pin_name = rw_port_group.get_clock_name()
        for bus_name, bus_data in self._memory.get_misc_busses().items():
            self.write_generic_bus(out_fh, name, bus_name, clk_pin_name)
        for port_name in sorted(self._memory.get_misc_ports()):
            self.write_pin(out_fh, name, port_name, clk_pin_name)

    def write_memory_section(self, out_fh):
        """Writes the memory section to the output stream"""

        out_fh.write("    memory() {\n")
        out_fh.write("        type : ram;\n")
        out_fh.write("        address_width : %d;\n" % self._memory.get_addr_width())
        out_fh.write("        word_width : %d;\n" % self._memory.get_width())
        out_fh.write("    }\n")
