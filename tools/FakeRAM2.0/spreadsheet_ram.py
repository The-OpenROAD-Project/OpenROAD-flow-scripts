#!/usr/bin/env python3

import sys
import importlib.util

from utils.rw_port_group import RWPortGroup

#
# Class to generate a single port RAM from customer-specific spreadsheet input
#


class SSRAMGenerator:
    """Container class for generating a spreadsheet-based memory"""

    def __init__(self, util_file):
        """Initializer"""
        self._import_custom_mappings(util_file)

    def _import_custom_mappings(self, file_name):
        """
        Import custom maps into the self._util_module

        file must contain the following methods:

        get_pin_type_map - returns a dictionary that maps a pin name or bus name
                           string to a string that indicates the type of the pin
                           or bus. Recognized values include: address_bus,
                           data_bus, output_bus, write_enable, clock, power,
                           ground

            Example:
                pin_type_map = {
                    "addr_in": "address_bus",
                    "data_in": "data_bus",
                    "rd_out": "output_bus",
                    "we_in": "write_enable",
                    "clk": "clock",
                    "VSS": "ground",
                    "VDD": "power",
                }

        """

        module_name = "spreadsheet_utils"
        spec = importlib.util.spec_from_file_location(module_name, file_name)
        self._util_module = importlib.util.module_from_spec(spec)
        sys.modules[module_name] = self._util_module
        spec.loader.exec_module(self._util_module)
        self._pin_type_map = self._util_module.get_pin_type_map()

    def set_logical_pins(self, mem, pin_org):
        """Sets the pins to be used for Verilog and Liberty output"""

        for suffix, src in pin_org.get_rw_groups().items():
            rw_port_group = RWPortGroup()
            rw_port_group.set_suffix(suffix)
            for pin_type, port_data in src.items():
                pin_name = port_data["name"]
                if pin_type == "clock":
                    rw_port_group.set_clock_name(pin_name)
                elif pin_type == "address_bus":
                    rw_port_group.set_address_bus_name(pin_name)
                elif pin_type == "data_bus":
                    rw_port_group.set_data_input_bus_name(pin_name)
                elif pin_type == "output_bus":
                    rw_port_group.set_data_output_bus_name(pin_name)
                elif pin_type == "write_enable":
                    rw_port_group.set_write_enable_name(pin_name)
                else:
                    if "msb" in port_data:
                        rw_port_group.add_related_bus(port_data)
                    else:
                        rw_port_group.add_related_pin(pin_name)
            mem.add_rw_port_group(rw_port_group)
        for src in pin_org.get_misc_busses():
            mem.add_misc_bus(src)
        for src in pin_org.get_misc_ports():
            if src["type"] not in ["power", "ground"]:
                mem.add_misc_port(src["name"])
