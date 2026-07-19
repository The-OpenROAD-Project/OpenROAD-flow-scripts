#!/usr/bin/env python3
"""AUTO_MEMORIES driver: detect memories, judge them, emit macro views.

Run pre-synthesis (before canonicalization). Scans the design's Verilog
for memory-shaped modules, merges user-supplied `.memories` files
(ADDITIONAL_MEMORIES), applies the idiomatic-macro gate, then writes:

  <json>                 full inventory, converted or not (memories.json)
  <out-dir>/<m>.lib             Liberty view per converted memory
  <out-dir>/<m>_pre_layout.lib  ideal-clock variant for pre-CTS consumers
  <out-dir>/<m>.lef             abstract LEF per converted memory
  <out-dir>/blackboxes.txt      converted module names, one per line —
                                what synthesis blackboxes

Everything downstream consumes these files; nothing else is passed
between the generator and the flow.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import detect  # noqa: E402
import idiomatic  # noqa: E402
import lef  # noqa: E402
import liberty  # noqa: E402
import pdk_asap7  # noqa: E402
import schema  # noqa: E402


def run(
    verilog: list[Path],
    memories_files: list[Path],
    platform: str,
    out_dir: Path,
    json_path: Path,
) -> int:
    try:
        params = pdk_asap7.get_platform(platform)
    except ValueError as e:
        sys.stderr.write(f"gen_memories: {e}\n")
        return 1

    try:
        found = detect.scan_files(verilog)
    except OSError as e:
        sys.stderr.write(f"gen_memories: cannot read Verilog: {e}\n")
        return 1
    idiomatic.apply(found)

    try:
        overrides: list[schema.Memory] = []
        for path in memories_files:
            overrides.extend(schema.load(path))
        memories = schema.merge(found, overrides)
    except schema.SchemaError as e:
        sys.stderr.write(f"gen_memories: {e}\n")
        return 1

    out_dir.mkdir(parents=True, exist_ok=True)
    json_path.parent.mkdir(parents=True, exist_ok=True)
    schema.dump(memories, json_path, platform)

    converted = sorted((m for m in memories if m.idiomatic), key=lambda m: m.name)
    try:
        for mem in converted:
            schema.validate_emittable(mem)
    except schema.SchemaError as e:
        sys.stderr.write(f"gen_memories: {e}\n")
        return 1

    for mem in converted:
        (out_dir / f"{mem.name}.lib").write_text(liberty.emit_lib(mem, params))
        (out_dir / f"{mem.name}_pre_layout.lib").write_text(
            liberty.emit_lib(mem, params, ck_insertion_ps=0.0)
        )
        (out_dir / f"{mem.name}.lef").write_text(lef.emit_lef(mem, params))
    (out_dir / "blackboxes.txt").write_text("".join(f"{m.name}\n" for m in converted))

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
        "--verilog",
        action="append",
        default=[],
        type=Path,
        help="Verilog source file to scan (repeatable).",
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
    return run(args.verilog, args.memories, args.platform, args.out_dir, args.json)


if __name__ == "__main__":
    sys.exit(main())
