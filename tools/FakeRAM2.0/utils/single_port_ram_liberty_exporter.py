#!/usr/bin/env python3

from ram_liberty_exporter import RAMLibertyExporter


class SinglePortRAMLibertyExporter(RAMLibertyExporter):
    """
    Liberty exporter for single port SRAM. It differs from the others due to
    pin differences, which were kept for backward compatibility
    """

    def __init__(self, memory):
        """Initializer"""
        RAMLibertyExporter.__init__(self, memory)

    def write_cell(self, out_fh):
        """Writes the Liberty cell"""

        name = self._memory.get_name()
        timing_data = self._memory.get_timing_data()
        rw_port_group = self._memory.get_rw_port_groups()[0]
        clk_pin_name = rw_port_group.get_clock_name()
        addr_bus_name = rw_port_group.get_address_bus_name()
        self.write_memory_section(out_fh)
        self.write_clk_pin(out_fh, clk_pin_name)
        self.write_output_bus(
            out_fh,
            name,
            rw_port_group.get_data_output_bus_name(),
            clk_pin_name,
            True,
            addr_bus_name,
        )
        self.write_pin(
            out_fh, name, rw_port_group.get_write_enable_name(), clk_pin_name
        )
        for pin in self._memory.get_misc_ports():
            self.write_pin(out_fh, name, pin, clk_pin_name)
        self.write_address_bus(out_fh, name, addr_bus_name, clk_pin_name)
        self.write_data_bus(
            out_fh,
            name,
            rw_port_group.get_data_input_bus_name(),
            rw_port_group.get_write_enable_name(),
            clk_pin_name,
            True,
            addr_bus_name,
        )
