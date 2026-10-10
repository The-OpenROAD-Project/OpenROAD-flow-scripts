import json
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
    "column_mux_factor": 1,
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

    for m in converted:
        name = m["name"]
        bits = m.get("bits", 32)
        rows = m.get("rows", 128)

        sram_dict = {
            "name": name,
            "width": bits,
            "depth": rows,
            "banks": 1,
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

    (out_dir / "blackboxes.txt").write_text(
        "".join(f"{m['name']}\n" for m in converted)
    )
    return 0
