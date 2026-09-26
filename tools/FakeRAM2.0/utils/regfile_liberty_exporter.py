#!/usr/bin/env python3

from liberty_exporter import LibertyExporter


class RegFileLibertyExporter(LibertyExporter):
    """Reg file Liberty Exporter"""

    def __init__(self, memory):
        """Initializer"""
        LibertyExporter.__init__(self, memory)

    def write_cell(self, out_fh):
        """
        Writes the Liberty cell

        Difference is that we pass False to the rw_pin_set writer to indicate
        that this isn't a RAM.
        """

        name = self._memory.get_name()
        for rw_port_group in self._memory.get_rw_port_groups():
            self.write_rw_pin_set(out_fh, name, rw_port_group, False)
