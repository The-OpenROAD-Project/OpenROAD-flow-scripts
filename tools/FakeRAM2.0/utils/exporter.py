#!/usr/bin/env python3


class Exporter:
    """Base class for all exporters. Contains common code"""

    def __init__(self, memory):
        """Initializer"""
        self._memory = memory

    def get_memory(self):
        """Returns the memory for this exporter"""
        return self._memory

    def export_file(self, file_name):
        """Exports the contents to the specified file"""
        with open(file_name, "w") as out_fh:
            self.export(out_fh)
