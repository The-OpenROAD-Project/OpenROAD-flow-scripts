#!/usr/bin/env python3
"""AUTO_MEMORIES driver: detect memories, judge them, emit macro views.

Run pre-synthesis (before canonicalization). Reads the netlist JSON
that extract_memories.tcl writes after yosys `proc; memory -nomap`,
collects its $mem_v2 cells, merges user-supplied `.memories` files
(ADDITIONAL_MEMORIES), applies the idiomatic-macro gate, then writes:

  <json>                 full inventory, converted or not (memories.json)
  <out-dir>/<m>.lib             Liberty view per converted memory
  <out-dir>/<m>_pre_layout.lib  ideal-clock variant for pre-CTS consumers
  <out-dir>/<m>.lef             abstract LEF per converted memory
  <out-dir>/blackboxes.txt      `<module> <area>` per line, area in um^2 as
                                the .lib states it — what synthesis
                                blackboxes and the cost it gives each

Everything downstream consumes these files; nothing else is passed
between the generator and the flow.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import subprocess

import detect  # noqa: E402
import idiomatic  # noqa: E402
import schema  # noqa: E402

FAKERAM_RUN_PY = Path(__file__).resolve().parents[3] / "tools/FakeRAM2.0/run.py"


def run(
    yosys_json: Path,
    memories_files: list[Path],
    platform: str,
    out_dir: Path,
    json_path: Path,
) -> int:
    if platform != "asap7":
        sys.stderr.write(f"gen_memories: unsupported platform {platform}\n")
        return 1

    found = detect.scan_yosys_json(yosys_json)

    idiomatic.apply(found)

    overrides: list[schema.Memory] = []
    for path in memories_files:
        overrides.extend(schema.load(path))
    memories = schema.merge(found, overrides)

    out_dir.mkdir(parents=True, exist_ok=True)
    json_path.parent.mkdir(parents=True, exist_ok=True)
    schema.dump(memories, json_path, platform)

    converted = sorted((m for m in memories if m.idiomatic), key=lambda m: m.name)
    for mem in converted:
        schema.validate_emittable(mem)

    subprocess.check_call(
        [
            sys.executable,
            str(FAKERAM_RUN_PY),
            "--orfs_asap7_backend",
            "--output_dir",
            str(out_dir),
            str(json_path),
        ]
    )

    for mem in sorted(memories, key=lambda m: m.name):
        verdict = "macro" if mem.idiomatic else "flops"
        sys.stderr.write(
            f"gen_memories: {mem.name} {mem.rows}x{mem.bits} "
            f"R={mem.read_ports} W={mem.write_ports} RW={mem.rw_ports} "
            f"mask_lanes={mem.mask_lanes} -> {verdict} ({mem.reason})\n"
        )
    if not memories:
        sys.stderr.write("gen_memories: no memory-shaped modules found\n")
    return 0


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument(
        "--yosys-json",
        required=True,
        type=Path,
        help="Yosys netlist JSON file containing $mem_v2 primitives.",
    )
    p.add_argument(
        "--memories",
        action="append",
        default=[],
        type=Path,
        help="User-supplied .memories file merged onto the "
        "detected set (repeatable).",
    )
    p.add_argument("--platform", required=True)
    p.add_argument(
        "--out-dir",
        required=True,
        type=Path,
        help="Directory for generated .lib/.lef/blackboxes.txt.",
    )
    p.add_argument(
        "--json",
        required=True,
        type=Path,
        help="Path of the memories.json inventory to write.",
    )
    args = p.parse_args(argv)
    return run(
        args.yosys_json,
        args.memories,
        args.platform,
        args.out_dir,
        args.json,
    )


if __name__ == "__main__":
    sys.exit(main())
