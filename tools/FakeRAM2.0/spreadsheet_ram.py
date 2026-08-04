#!/usr/bin/env python3

import re
import sys
import csv
import argparse
import importlib.util

from utils.timing_data import TimingData
from utils.memory_config import MemoryConfig
from utils.class_process import Process
from utils.run_utils import RunUtils
from utils.rw_port_group import RWPortGroup
from utils.ss_port_creator import SSPortCreator
from utils.ss_port_organizer import SSPortOrganizer
from utils.single_port_ssram import SinglePortSSRAM

# TODO
# support reg file

#
# Class to generate a single port RAM from customer-specific spreadsheet input
#
# Usage: spreadsheet_ram.py --config <fakeram_config> --physical <physical_csv>
#                           --mem_config <metrics_csv>
#                           --mapping <custom_mapping> --output_dir <output_dir>
#
# where
#   fakeram_config - standard FakeRAM2.0 JSON config
#   physical_csv - CSV file containing physical data such as size, pins (layer
#                  and rect) and obstructions
#   metrics_csv - CSV file containing power and timing characteristics
#   custom_mapping - Python3 file containing two mapping routines that are
#                    custom-specific (see below)
#   output_dir - output directory name
#


class SSRAMGenerator:
    """Container class for generating a spreadsheet-based memory"""

    def __init__(self, config_file, util_file):
        """Initializer"""
        self._import_custom_mappings(util_file)
        if config_file:
            # Use config to get voltage
            self._process = Process(RunUtils.get_config(config_file))

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

        get_key_map - returns a dictionary that maps the CSV column to a
                      dictionary that helps the SSRAMGenerator properly handle
                      the data in its own structures. The dictionary recognizes
                      the following keys:

                          key: name of the field in the functional or timing
                               data object
                          type: object type to convert into
                          conversion: optional field for unit conversion (csv
                                      value is multiplied by the specified value

            Example:
                key_map = {
                    "Num Words": { "key": "depth", "type": int },
                    "Num Bits": { "key": "width", "type": int },
                    "Num Banks": { "key": "banks", "type": int },
                    "Memory Name": { "key": "name", "type": str },
                    "cin (pf)":{ "key":  "cap_input_pf", "type": float },
                    "corner.Ts (ns)": { "key": "t_setup_ns", "type": float },
                    "corner.Th (ns)": { "key": "t_hold_ns", "type": float },
                    "corner.Ta (ns)": { "key": "access_time_ns", "type": float },
                    "corner.Tc (ns)": { "key": "cycle_time_ns", "type": float },
                    "Static Power (uW)": { "key": "standby_leakage_per_bank_mW", "type": float, "conversion": 1e-3 },
                    "Dynamic Power (uW/MHz)": { "key": "pin_dynamic_power_mW",  "type": float , "conversion": 1e-3},
                }
        """

        module_name = "spreadsheet_utils"
        spec = importlib.util.spec_from_file_location(module_name, file_name)
        self._util_module = importlib.util.module_from_spec(spec)
        sys.modules[module_name] = self._util_module
        spec.loader.exec_module(self._util_module)
        self._pin_type_map = self._util_module.get_pin_type_map()
        self._key_map = self._util_module.get_key_map()

    def create_memory(self, mem_config, physical):
        """Extracts the data from the CSV files and returns the memory object"""

        # Get the physical data and organize it
        phys_data = self.read_physical_file(physical)
        pin_org = SSPortOrganizer(self._pin_type_map)
        pin_org.organize_ports(phys_data)
        num_pins = len(phys_data["pin_data"])

        # Get the metrics data and organize it
        macro_metrics = self.read_metrics_file(mem_config, phys_data["name"])
        timing_data = TimingData(macro_metrics)
        mem_config = MemoryConfig.from_json(macro_metrics)

        mem = SinglePortSSRAM(mem_config, self._process, timing_data, num_pins)
        self.set_logical_pins(mem, pin_org)
        port_creator = SSPortCreator(mem, self._pin_type_map)
        port_creator.create_ports(phys_data["pin_data"])
        if "obs" in phys_data:
            port_creator.create_obs(phys_data["obs"])
        mem.get_physical_data().set_extents(
            float(phys_data["width"]), float(phys_data["height"])
        )
        # snap to grid to sync up the physical data fields
        mem.get_physical_data().snap_to_grid(1, 1)
        return mem

    def read_physical_file(self, file_name):
        """
        Reads the physical data CSV file and returns a dictionary that includes
        the pin and obstruction data
        """

        macro_data = {"pin_data": {}, "obs": []}
        with open(file_name, "r", encoding="utf-8-sig") as csv_fh:
            reader = csv.DictReader(csv_fh)
            is_first = True
            for row in reader:
                # MACRO,SIZE_WIDTH,SIZE_HEIGHT,SOURCE,PIN,USE,LAYER,x1,y1,x2,y2
                if is_first:
                    macro_data["name"] = row["MACRO"]
                    macro_data["width"] = row["SIZE_WIDTH"]
                    macro_data["height"] = row["SIZE_HEIGHT"]
                    is_first = False
                source = row["SOURCE"]
                if source == "PIN":
                    pin_data = {
                        "name": row["PIN"],
                        "use": row["USE"],
                        "layer": row["LAYER"],
                        "rect": [
                            float(row["x1"]),
                            float(row["y1"]),
                            float(row["x2"]),
                            float(row["y2"]),
                        ],
                    }
                    if pin_data["name"] not in macro_data["pin_data"]:
                        macro_data["pin_data"][pin_data["name"]] = pin_data
                    else:  # pragma: no cover
                        raise Exception(
                            "{} had multiple pin shapes".format(pin_data["name"])
                        )
                elif source == "OBS":
                    obs_data = {
                        "layer": row["LAYER"],
                        "layer_attr": None,
                        "rect": [
                            float(row["x1"]),
                            float(row["y1"]),
                            float(row["x2"]),
                            float(row["y2"]),
                        ],
                    }
                    macro_data["obs"].append(obs_data)
                else:
                    print(
                        "Skipping {} since source is {}".format(
                            row["PIN"], row["SOURCE"]
                        )
                    )
        return macro_data

    def get_size_keys(self):
        """Returns the keys that map to depth and width"""

        depth_key = width_key = None
        for key, val in self._key_map.items():
            if val.get("key") == "depth":
                depth_key = key
            elif val.get("key") == "width":
                width_key = key
        return (depth_key, width_key)

    def read_metrics_file(self, file_name, macro_name):
        """
        Reads the metrics CSV file to extract the power and timing data.

        Returns a dictionary that has been normalized to our expected metrics
        and Process/TimingData names

        The depth and width are present on the first row and apply to all
        subsequent rows until they are set again on a subsequent row.
        Effectively, the cells should have been merged, but weren't.
        """
        macro_metrics = {}
        depth = width = None
        depth_key, width_key = self.get_size_keys()
        with open(file_name, "r", encoding="utf-8-sig") as csv_fh:
            reader = csv.DictReader(csv_fh)
            for row in reader:
                if row[depth_key]:
                    depth = row[depth_key]
                if row[width_key]:
                    width = row[width_key]
                if row["memory_name"] == macro_name:
                    row[depth_key] = depth
                    row[width_key] = width
                    for csv_key, metric_key_data in self._key_map.items():
                        if csv_key in row and row[csv_key] != "N/A":
                            metric_key = metric_key_data["key"]
                            metric_type_fn = metric_key_data["type"]
                            metric_conv_factor = metric_key_data.get("conversion", 1)
                            macro_metrics[metric_key] = (
                                metric_type_fn(row[csv_key]) * metric_conv_factor
                            )
        return macro_metrics

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

    @staticmethod
    def main():
        """Main driver"""
        parser = argparse.ArgumentParser(
            description="Create a set of memory colllateral from a spreadsheet input"
        )
        parser.add_argument(
            "--config",
            help="Input configuration file containing technology parameters",
            required=True,
        )
        parser.add_argument(
            "--mem_config",
            help="CSV file containing technical parameters such as size, timing, power",
            required=True,
        )
        parser.add_argument(
            "--physical",
            help="CSV file containing physical data such as pin locations and layers",
            required=True,
        )
        parser.add_argument(
            "--mapping", help="Custom Python mapping file", required=True
        )
        parser.add_argument(
            "--output_dir",
            action="store",
            help="Output directory ",
            required=False,
            default="results",
        )

        args = parser.parse_args()
        rep = SSRAMGenerator(args.config, args.mapping)
        mem = rep.create_memory(args.mem_config, args.physical)
        RunUtils.write_memory(mem, args.output_dir)


if __name__ == "__main__":
    SSRAMGenerator.main()
