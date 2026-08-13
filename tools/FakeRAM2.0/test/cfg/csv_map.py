#!/usr/bin/env python3
#
# Contains python routines that get loaded into the FakeRAM spreadsheet
# generator, so that FakeRAM knows how to map data extracted from the CSV file
# to the appropriate data structures in FakeRAM


def get_pin_type_map():
    """Custom pin type mapping"""
    pin_type_map = {
        "addr_i": "address_bus",
        "din_i": "data_bus",
        "dout_o": "output_bus",
        "we_i": "write_enable",
        "clk": "clock",
        "VSS": "ground",
        "VDD": "power",
        "VDDA": "power",
    }
    return pin_type_map


def get_key_map():
    """Custom CSV key to SSRAM key, type, and special handling"""

    key_map = {
        "NumWords": {"key": "depth", "type": int},
        "NumBits": {"key": "width", "type": int},
        "NumBanks": {"key": "banks", "type": int},
        "memory_name": {"key": "name", "type": str},
        "pin cap (pf)": {"key": "cap_input_pf", "type": float},
        "setup time (ns)": {"key": "t_setup_ns", "type": float},
        "hold time (ns)": {"key": "t_hold_ns", "type": float},
        "access time (ns)": {"key": "access_time_ns", "type": float},
        "cycle time (ns)": {"key": "cycle_time_ns", "type": float},
        "static power (uW)": {
            "key": "standby_leakage_per_bank_mW",
            "type": float,
            "conversion": 1e-3,
        },
        "dynamic power (uW/MHz)": {
            "key": "pin_dynamic_power_mW",
            "type": float,
            "conversion": 1e-3,
        },
    }
    return key_map
