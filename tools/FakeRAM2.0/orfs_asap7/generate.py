"""ORFS asap7 backend: emit .lib/.lef views for the memories AUTO_MEMORIES converts.

The input is memories.json, ORFS's inventory. Every converted memory
carries the pin list of the module the flow blackboxes, and the macro has
to expose exactly those pins or the blackboxed module never links to its
liberty view. So the macro is built from the declared pins: a single
read-write port -- clock, address, enable, write mode, data in, data out
and an optional write mask with one lane per mask bit -- becomes a
single-port RAM whose ports carry the module's names.

A memory whose pins were synthesized by the detector rather than read off
the module (port_convention "") has no such names and gets FakeRAM's
historical single-port pins, which is what earlier ORFS releases emitted.
"""

import json
import math
import sys
from pathlib import Path

from utils.class_process import Process
from utils.memory_config import MemoryConfig
from utils.memory_factory import MemoryFactory
from utils.timing_data import TimingData
from utils.ram_liberty_exporter import RAMLibertyExporter
from utils.lef_exporter import LefExporter

ASAP7_PROCESS_CONFIG = {
    "tech_nm": 7,
    "voltage": 0.7,
    "metal_prefix": "M",
    "metal_layer": "M4",
    "pin_width_nm": 24,
    "pin_pitch_nm": 48,
    "metal_track_pitch_nm": 48,
    "manufacturing_grid_nm": 1,
    "contacted_poly_pitch_nm": 54,
    "fin_pitch_nm": 27,
    "snap_width_nm": 190,
    "snap_height_nm": 1400,
    # A macro's power pins are horizontal M4 rails, which the platform's
    # macro grid connects to the core's vertical M5 straps
    # (openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl: each net every 5.4 um,
    # 0.12 um wide). A narrower macro can sit between two straps of a
    # net, its grid gets no shapes and pdngen fails the whole design
    # (PDN-0233, or PDN-0179 when it cannot repair the channels). One pitch plus a strap, plus the rails' 0.048 um inset
    # at both edges, puts a strap of each net across the rails wherever
    # the macro lands.
    "min_width_um": 5.4 + 0.12 + 2 * 0.048,
}

ASAP7_TIMING_CONFIG = {
    "cycle_time": 1.0,
    "access_time": 0.5,
    "setup_time": 0.1,
    "hold_time": 0.05,
    "leakage": 0.001,
}

# memories.json pin function -> the role SinglePortRAM names its port by.
_ROLE_OF_FUNCTION = {
    "clk": "clk",
    "addr": "addr",
    "en": "ce",
    "wmode": "we",
    "data_in": "din",
    "data_out": "dout",
    "mask": "mask",
}


def single_port_pins(mem: dict):
    """The (pin_names, mask_lanes) of a memory declared as one RW port.

    Returns None when the pins are not a single read-write port carrying
    the functions a single-port RAM has: the caller then falls back to
    FakeRAM's historical pin names.
    """
    pins = mem.get("pins") or []
    groups = {p["port_id"] for p in pins}
    if len(groups) != 1 or not next(iter(groups)).startswith("RW"):
        return None
    names = {}
    lanes = 0
    for p in pins:
        role = _ROLE_OF_FUNCTION.get(p["function"])
        if role is None or role in names:
            return None
        names[role] = p["name"]
        if role == "mask":
            lanes = int(p["width"])
    if not {"clk", "addr", "ce", "we", "din", "dout"} <= set(names):
        return None
    return names, lanes


def additional_height_for_pins(process: Process, bits: int, rows: int, lanes: int):
    """Height to add so every pin gets a track on the macro's left edge.

    FakeRAM sizes the macro from its bit cells and then fails when the
    pins do not fit; a memory folded square by the column mux with a
    per-bit mask is exactly that case. The extra height is computed here
    rather than left to the caller to discover one macro at a time.
    """
    addr_w = max(1, math.ceil(math.log2(rows))) if rows > 1 else 1
    num_pins = 2 * bits + addr_w + 3 + lanes
    _, height = process.get_macro_dimensions(bits, rows, 1, 0)
    needed = (num_pins + 1) * process.pin_pitch_um + 2 * process.y_offset
    return max(0.0, needed - height)


def run_orfs_asap7(platform: str, out_dir: Path, json_path: Path):
    if platform != "asap7":
        sys.stderr.write(f"FakeRAM2.0 orfs_asap7: unsupported platform {platform}\n")
        return 1

    try:
        data = json.loads(json_path.read_text())
        memories = data.get("memories", [])
    except Exception as e:
        sys.stderr.write(f"FakeRAM2.0 orfs_asap7: failed to read {json_path}: {e}\n")
        return 1

    out_dir.mkdir(parents=True, exist_ok=True)
    converted = sorted(
        (m for m in memories if m.get("idiomatic")), key=lambda m: m["name"]
    )

    process = Process(ASAP7_PROCESS_CONFIG)
    timing_data = TimingData(ASAP7_TIMING_CONFIG)

    blackboxes = []
    for m in converted:
        name = m["name"]
        bits = int(m.get("bits", 32))
        rows = int(m.get("rows", 128))

        pin_names = {}
        lanes = 0
        declared = single_port_pins(m)
        if declared is not None:
            pin_names, lanes = declared
        elif m.get("port_convention"):
            sys.stderr.write(
                f"FakeRAM2.0 orfs_asap7: {name} declares pins that are not a "
                "single read-write port; nothing this backend emits would link\n"
            )
            return 1

        sram_dict = {
            "name": name,
            "width": bits,
            "depth": rows,
            "banks": 1,
            "additional_height": additional_height_for_pins(process, bits, rows, lanes),
            "pin_names": pin_names,
            "mask_lanes": lanes,
        }
        mem_config = MemoryConfig.from_json(sram_dict)
        ram = MemoryFactory.create(mem_config, "RAM", "SP", process, timing_data)

        # Export Liberty
        lib_path = out_dir / f"{name}.lib"
        with open(lib_path, "w") as f:
            RAMLibertyExporter(ram).export(f)

        pre_lib_path = out_dir / f"{name}_pre_layout.lib"
        with open(pre_lib_path, "w") as f:
            RAMLibertyExporter(ram).export(f)

        # Export LEF
        lef_path = out_dir / f"{name}.lef"
        with open(lef_path, "w") as f:
            LefExporter(ram).export(f)

        # the area the .lib states, beside the name: synthesis costs the
        # blackbox by it
        blackboxes.append(f"{name} {ram.physical.get_area(False):.6f}\n")

    (out_dir / "blackboxes.txt").write_text("".join(blackboxes))
    return 0
