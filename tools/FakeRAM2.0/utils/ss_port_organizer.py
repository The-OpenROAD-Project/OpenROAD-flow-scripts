#!/usr/bin/env python3

import re
import sys


class SSPortOrganizer:
    def __init__(self, pin_type_map):
        self._rw_groups = {}
        self._misc_busses = []
        self._misc_ports = []
        self._port_dict = {}
        self._bus_name_re = re.compile(r"^(\S+)\[(\d+)\]")
        self._pin_type_map = pin_type_map

    def get_rw_groups(self):
        return self._rw_groups

    def get_misc_busses(self):
        return self._misc_busses

    def get_misc_ports(self):
        return self._misc_ports

    def _consolidate_ports(self, macro_data):
        for pin_name, pin_data in macro_data["pin_data"].items():
            result = self._bus_name_re.match(pin_name)
            if result:
                bus_name = result.group(1)
                bit_num = int(result.group(2))
                if bus_name in self._port_dict:
                    self._port_dict[bus_name]["lsb"] = min(
                        bit_num, self._port_dict[bus_name]["lsb"]
                    )
                    self._port_dict[bus_name]["msb"] = max(
                        bit_num, self._port_dict[bus_name]["msb"]
                    )
                else:
                    self._port_dict[bus_name] = {
                        "name": bus_name,
                        "msb": bit_num,
                        "lsb": bit_num,
                        "type": self.classify_pin(bus_name),
                    }
            else:
                if pin_name in self._port_dict:  # pragma: no cover
                    raise Exception(f"pin {pin_name} appears twice")
                pin_type = self.classify_pin(pin_name)
                # if the scalar port gets classified as a bus, that's not
                # correct, so set it to None
                if pin_type and pin_type.endswith("_bus"):
                    pin_type = None
                self._port_dict[pin_name] = {"name": pin_name, "type": pin_type}

    def classify_pin(self, pin_name):
        """
        Returns the pin classification to help identify whether the pin or bus
        is the address, data in, data out, write enable, clock or power pin or
        bus
        """
        if pin_name in self._pin_type_map:
            return self._pin_type_map[pin_name]
        for prefix, pin_type in self._pin_type_map.items():
            if pin_name.startswith(prefix):
                return pin_type
        return None

    def organize_ports(self, macro_data):
        self._consolidate_ports(macro_data)
        address_busses = [
            v for v in self._port_dict.values() if v.get("type") == "address_bus"
        ]
        if len(address_busses) > 1:
            for address_bus in address_busses:
                last_char = address_bus["name"][-1]
                self._rw_groups[last_char] = {}
            for port_name, port_data in self._port_dict.items():
                if port_data["type"] in [
                    "address_bus",
                    "clock",
                    "write_enable",
                    "output_bus",
                    "data_bus",
                    "toggle_power",
                    "self_time_bypass",
                    "mem_enable",
                    "write_margin_enable",
                    "write_margin_input",
                ]:
                    last_char = port_data["name"][-1]
                    self._rw_groups[last_char][port_data["type"]] = port_data
                elif "msb" in port_data:
                    self._misc_busses.append(port_data)
                else:
                    self._misc_ports.append(port_data)
        else:
            rw_group = {}
            self._rw_groups[""] = rw_group
            for port_name, port_data in self._port_dict.items():
                if port_data["type"] in [
                    "address_bus",
                    "clock",
                    "write_enable",
                    "output_bus",
                    "data_bus",
                ]:
                    rw_group[port_data["type"]] = port_data
                elif "msb" in port_data:
                    self._misc_busses.append(port_data)
                else:
                    self._misc_ports.append(port_data)
