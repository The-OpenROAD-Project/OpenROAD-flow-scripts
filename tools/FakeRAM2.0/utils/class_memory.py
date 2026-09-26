#!/usr/bin/env python3

import math
import argparse

from physical_data import PhysicalData
from lef_exporter import LefExporter
from named_object import NamedObject
from basic_port_creator import BasicPortCreator

################################################################################
# MEMORY CLASS
#
# This class stores the information about a specific memory that is being
# generated. This class takes in a process object, the information in one of
# the items in the "sram" list section of the json configuration file
################################################################################


class Memory(NamedObject):
    def __init__(self, mem_config, process, timing_data):
        """
        Initializer

        Stores the process and timing_data objects directly on the memory, so
        that they can be accessed by the appropriate exporters. The physical
        data stores anything related to LEF.
        """
        NamedObject.__init__(self, mem_config.get_name())

        self.process = process
        self.width_in_bits = mem_config.get_width_in_bits()
        self.depth = mem_config.get_depth()
        self.addr_width = math.ceil(math.log2(self.depth))
        self.num_banks = mem_config.get_num_banks()
        self.width_in_bytes = math.ceil(self.width_in_bits / 8.0)
        self.total_size = self.width_in_bytes * self.depth
        self.additional_height = mem_config.get_additional_height()
        self.timing_data = timing_data
        self.physical = PhysicalData()
        if self.process.calc_dimensions():
            width_um, height_um = self.process.get_macro_dimensions(
                self.width_in_bits, self.depth, self.num_banks, self.additional_height
            )
            self.physical.set_extents(width_um, height_um)
            self.physical.snap_to_grid(
                self.process.snap_width_nm, self.process.snap_height_nm
            )
            num_pins = self.get_num_pins()
            self.physical.set_pin_pitches(
                self.get_name(),
                num_pins,
                self.process.pin_pitch_um,
                self.process.y_offset,
            )

        # collection of logical connections
        #   rw_port_groups: write enable, address bus, data in bus,
        #                  data out bus, clock
        #   misc_busses: other busses
        #   misc_ports: other ports
        self._rw_port_groups = []
        self._misc_busses = {}
        self._misc_ports = set()

        #
        # port_name -> port object
        #
        self._port_dict = {}
        #
        # port_name -> port object
        #
        self._pg_port_dict = {}
        #
        # layer -> list of rects
        #
        self._obs_dict = {}

    def create_ports(self):
        creator = BasicPortCreator(self)
        creator.create_ports()

    def get_depth(self):
        """Returns the depth"""
        return self.depth

    def get_width(self):
        """Returns the width in bits"""
        return self.width_in_bits

    def get_num_banks(self):
        """Returns the number of banks"""
        return self.num_banks

    def get_width_in_bytes(self):
        """Returns the width in bytes"""
        return self.width_in_bytes

    def get_total_size(self):
        """Returns the total size in bytes"""
        return self.total_size

    def get_additional_height(self):
        """
        Returns the additional height to add in um

        Can be used when the number of pins exceeds the number of available
        tracks
        """
        return self.additional_height

    def get_data_bus_msb(self):
        """
        Returns the data bus MSB, which is one less than the data bus width
        """
        return self.get_width() - 1

    def get_addr_width(self):
        """Returns the address width"""
        return self.addr_width

    def get_addr_bus_msb(self):
        """
        Returns the address bus MSB, which is one less than the address bus
        width
        """

        return self.get_addr_width() - 1

    def get_process_data(self):
        """Returns the process data"""
        return self.process

    def get_timing_data(self):
        """Returns the timing data"""
        return self.timing_data

    def get_physical_data(self):
        """Returns the physical data"""
        return self.physical

    def add_rw_port_group(self, rw_port_group):
        """Adds a RW Port Group"""
        self._rw_port_groups.append(rw_port_group)

    def get_rw_port_groups(self):
        """Gets the RW Port Group List"""
        return self._rw_port_groups

    def get_num_rw_ports(self):
        """Returns the number of rw ports"""
        return len(self._rw_port_groups)

    def add_port(self, port):
        """Adds a port"""
        self._port_dict[port.get_name()] = port

    def get_port(self, port_name):
        """Returns the named port"""
        return self._port_dict.get(port_name, None)

    def get_ports(self):
        """Returns the port dictionary"""
        return self._port_dict

    def add_pg_port(self, port):
        """Adds a pg_port"""
        self._pg_port_dict[port.get_name()] = port

    def get_pg_port(self, port_name):
        """Returns the named pg_port"""
        return self._pg_port_dict.get(port_name, None)

    def get_pg_ports(self):
        """Returns the pg_port dictionary"""
        return self._pg_port_dict

    def add_misc_bus(self, bus):
        self._misc_busses[bus["name"]] = bus

    def get_misc_busses(self):
        return self._misc_busses

    def add_misc_port(self, port):
        self._misc_ports.add(port)

    def get_misc_ports(self):
        return self._misc_ports

    def add_obstruction(self, layer, rect, layer_attr=None):
        """Adds a obs"""
        if layer in self._obs_dict:
            self._obs_dict[layer]["rects"].append(rect)
        else:
            self._obs_dict[layer] = {"layer_attr": layer_attr, "rects": [rect]}

    def get_obstructions(self):
        """Returns the obs dict"""
        return self._obs_dict

    def dump_ports(self):
        for port_name, port in self.get_ports().items():
            print(port_name)

    def write_lef_file(self, out_file_name):
        """Writes the LEF content to a file"""

        exporter = LefExporter(self)
        exporter.export_file(out_file_name)

    @staticmethod
    def main(memory_type, port_config):  # pragma: nocover
        from run_utils import RunUtils
        from class_process import Process
        from timing_data import TimingData
        from memory_factory import MemoryFactory

        parser = argparse.ArgumentParser()
        parser.add_argument(
            "-c", "--config_file", help="FakeRAM config file", required=True
        )
        parser.add_argument(
            "-w", "--width", help="memory width in bits", type=int, required=True
        )
        parser.add_argument(
            "-d", "--depth", help="memory depth", type=int, required=True
        )
        parser.add_argument(
            "-b",
            "--banks",
            choices=[1, 2, 4],
            type=int,
            required=True,
            help="number of banks",
        )
        parser.add_argument("-n", "--name", help="memory name", required=True)
        parser.add_argument("-o", "--output_dir", default=".", help="Output directory")
        args = parser.parse_args()

        json_data = RunUtils.get_config(args.config_file)
        timing_data = TimingData(json_data)
        process_data = Process(json_data)
        memory = MemoryFactory.create(
            args.name,
            int(args.width),
            int(args.depth),
            int(args.banks),
            memory_type,
            port_config,
            process_data,
            timing_data,
        )
        RunUtils.write_memory(memory, args.output_dir)
