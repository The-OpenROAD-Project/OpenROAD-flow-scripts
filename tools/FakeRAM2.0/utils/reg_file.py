#!/usr/bin/env python3

from class_memory import Memory
from regfile_verilog_exporter import RegFileVerilogExporter
from regfile_liberty_exporter import RegFileLibertyExporter


class RegFile(Memory):
    """Base class for Reg files"""

    def __init__(self, mem_config, process_data, timing_data):
        """
        Initializer

        Parameters:
        mem_config (MemoryConfig): memory parameter container
        process_data (Process): process data container
        timing_data (TimingData): timing data container
        """

        Memory.__init__(self, mem_config, process_data, timing_data)

    def write_verilog_file(self, out_file_name, is_blackbox=False):
        """
        Writes the verilog content to a file

        If is_blackbox, then write the port declarations only. Otherwise, write
        the full RTL
        """

        exporter = RegFileVerilogExporter(self)
        exporter.export_file(out_file_name, is_blackbox)

    def write_liberty_file(self, out_file_name):
        """Writes the Liberty content to a file"""

        exporter = RegFileLibertyExporter(self)
        exporter.export_file(out_file_name)
