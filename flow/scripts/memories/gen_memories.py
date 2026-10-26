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
  <out-dir>/regfiles.txt        register files to dissolve into their cells
                                after macro placement (`mode netlist`)
  <out-dir>/inline.txt          register files whose generated netlist
                                replaces their module in synthesis (those
                                not in AUTO_MEMORIES_MACRO_PLACE)
  <out-dir>/regfile_cores.txt   the RAMs those wrappers instantiate as
                                macros: in blackboxes.txt, but no module of
                                the sources, so not there after read_slang
  <out-dir>/blackboxes.txt      `<module> <area>` per line, area in um^2 as
                                the .lib states it — what synthesis
                                blackboxes and the cost it gives each

Everything downstream consumes these files; nothing else is passed
between the generator and the flow.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import subprocess

import detect  # noqa: E402
import idiomatic  # noqa: E402
import regfile_ram  # noqa: E402
import schema  # noqa: E402

FAKERAM_RUN_PY = Path(__file__).resolve().parents[3] / "tools/FakeRAM2.0/run.py"


def _spec_module(spec: Path) -> str:
    """The `module <name>` line of a register-file spec."""
    for line in spec.read_text().splitlines():
        parts = line.split("#", 1)[0].split()
        if len(parts) == 2 and parts[0] == "module":
            return parts[1]
    raise SystemExit(f"gen_memories: {spec}: no `module` line")


def _spec_value(spec: Path, key: str) -> list[list[str]]:
    """Every `key ...` line of a register-file spec, as word lists."""
    out = []
    for line in spec.read_text().splitlines():
        parts = line.split("#", 1)[0].split()
        if parts and parts[0] == key:
            out.append(parts[1:])
    return out


def _spec_mode(spec: Path) -> str:
    """`mode macro` (the default) or `mode netlist` of a register-file spec."""
    for line in spec.read_text().splitlines():
        parts = line.split("#", 1)[0].split()
        if len(parts) == 2 and parts[0] == "mode":
            if parts[1] not in ("macro", "netlist"):
                raise SystemExit(
                    f"gen_memories: {spec}: mode is macro or netlist, not {parts[1]}"
                )
            return parts[1]
    return "macro"


def _lib_area(lib: Path) -> str:
    """The cell area `lib` states, in um^2: what blackboxes.txt gives a
    register file beside its name, as FakeRAM does for its macros."""
    m = re.search(r"^\s*area\s*:\s*([0-9.eE+-]+)\s*;", lib.read_text(), re.M)
    if not m:
        raise SystemExit(f"gen_memories: {lib} states no area")
    return m.group(1)


def _regfile_memory(spec: Path, module: str, reason: str) -> schema.Memory:
    """A register file's memories.json record, its shape from its spec."""
    mem = schema.Memory(name=module, kind="regfile", source="listed", spec=str(spec))
    words = _spec_value(spec, "words")
    bits = _spec_value(spec, "bits")
    mem.rows = int(words[0][0]) if words else 0
    mem.bits = int(bits[0][0]) if bits else 0
    mem.read_ports = len(_spec_value(spec, "read")) + len(
        _spec_value(spec, "read_banked")
    )
    mem.write_ports = len(_spec_value(spec, "write"))
    mem.reason = reason
    return mem


def run_regfiles(
    specs: list[Path],
    openroad: str | None,
    lefs: list[Path],
    out_dir: Path,
    macro_place: list[str] | None = None,
) -> list[schema.Memory]:
    """Generate every listed register file with OpenROAD's generate_ram,
    through regfile_ram.py: a wrapper in the RTL module's place connects
    its ports to the generated RAM's.

    A register file not named in AUTO_MEMORIES_MACRO_PLACE is inlined: its
    generated netlist replaces the module's body in synthesis (inline.txt),
    and from there on its cells are placed, sized and buffered with the
    rest of the design. No macro, no abstract, no dissolve: the best shape
    for a small design, where a macro's outline and channels cost more
    core than the array saves.

    A register file named in AUTO_MEMORIES_MACRO_PLACE is a macro to
    synthesis and to macro placement: its
    abstract LEF and model liberty land beside the FakeRAM views and the
    module joins blackboxes.txt. In `mode netlist` it then dissolves into
    its placed cells after macro placement (regfile_dissolve.tcl), which
    reads its structural netlist and the placement of its core
    (<m>.v, <m>.place) and finds it in regfiles.txt. A spec whose ports
    are not the module's stops the build here rather than miswire the
    parent.
    """
    macro_place = set(macro_place or [])
    if not specs:
        (out_dir / "regfiles.txt").write_text("")
        (out_dir / "inline.txt").write_text("")
        (out_dir / "regfile_cores.txt").write_text("")
        if macro_place:
            raise SystemExit(
                "gen_memories: AUTO_MEMORIES_MACRO_PLACE names "
                + " ".join(sorted(macro_place))
                + " but AUTO_MEMORIES_REGFILES lists no register file"
            )
        return []
    if not openroad:
        raise SystemExit(
            "gen_memories: AUTO_MEMORIES_REGFILES is set but OPENROAD_EXE is not"
        )
    if not lefs:
        raise SystemExit(
            "gen_memories: AUTO_MEMORIES_REGFILES needs TECH_LEF and SC_LEF"
        )
    modules = [_spec_module(spec) for spec in specs]
    unknown = sorted(macro_place - set(modules))
    if unknown:
        raise SystemExit(
            "gen_memories: AUTO_MEMORIES_MACRO_PLACE names "
            + " ".join(unknown)
            + ", which no AUTO_MEMORIES_REGFILES spec builds; it lists "
            + " ".join(modules)
        )
    memories = []
    dissolve = []
    cores = []
    inline = []
    for spec, module in zip(specs, modules):
        mode = _spec_mode(spec)
        # the RTL module's place taken by a wrapper around the RAM
        shape = mode if module in macro_place else "inline"
        regfile_ram.check(spec)
        ram = regfile_ram.generate(spec, module, shape, openroad, lefs, out_dir)
        memories.append(
            _regfile_memory(spec, module, f"register file, generate_ram, {shape}")
        )
        inline.append(module)
        if ram["macro"]:
            cores.append(ram["block"])
        if ram["dissolve"]:
            dissolve.append(ram["block"])
        sys.stderr.write(
            f"gen_memories: {module} -> register file, generate_ram, "
            f"{shape} ({spec.name})\n"
        )
    with (out_dir / "blackboxes.txt").open("a") as f:
        f.write(
            "".join(
                f"{name} {_lib_area(out_dir / f'{name}.lib')}\n"
                for name in [m.name for m in memories if m.name not in inline] + cores
            )
        )
    (out_dir / "regfiles.txt").write_text("".join(f"{m}\n" for m in dissolve))
    (out_dir / "inline.txt").write_text("".join(f"{m}\n" for m in inline))
    (out_dir / "regfile_cores.txt").write_text("".join(f"{m}\n" for m in cores))
    return memories


def run(
    yosys_json: Path,
    memories_files: list[Path],
    platform: str,
    out_dir: Path,
    json_path: Path,
    top: str | None = None,
    regfile_specs: list[Path] | None = None,
    openroad: str | None = None,
    lefs: list[Path] | None = None,
    macro_place: list[str] | None = None,
) -> int:
    if platform != "asap7":
        sys.stderr.write(f"gen_memories: unsupported platform {platform}\n")
        return 1

    found = detect.scan_yosys_json(yosys_json, top)

    # generate_ram builds storage with no initial value: a register file
    # with one would lose it without a word
    initialized = detect.initialized_modules(yosys_json, top)
    for spec in regfile_specs or []:
        module = _spec_module(spec)
        if module in initialized:
            raise SystemExit(
                f"gen_memories: {module} ({spec}) has a memory with an initial "
                "value, which a register file from generate_ram does not "
                "have; remove it from AUTO_MEMORIES_REGFILES"
            )

    idiomatic.apply(found)

    overrides: list[schema.Memory] = []
    for path in memories_files:
        overrides.extend(schema.load(path))
    memories = schema.merge(found, overrides)
    override_names = {o.name for o in overrides}
    for mem in memories:
        mem.kind = "fakeram" if mem.idiomatic else "flops"
        if mem.name in override_names:
            mem.source = "override"

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

    # After FakeRAM has written blackboxes.txt for the inferred memories,
    # and recorded in memories.json beside them.
    regfiles = run_regfiles(
        regfile_specs or [], openroad, lefs or [], out_dir, macro_place
    )
    if regfiles:
        listed = {m.name for m in regfiles}
        memories = [m for m in memories if m.name not in listed] + regfiles
        schema.dump(memories, json_path, platform)

    for mem in sorted(memories, key=lambda m: m.name):
        verdict = mem.kind
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
    p.add_argument(
        "--regfile-spec",
        action="append",
        default=[],
        type=Path,
        help="Register-file spec, AUTO_MEMORIES_REGFILES (repeatable).",
    )
    p.add_argument(
        "--openroad",
        default=None,
        help="The openroad that runs generate_ram (OPENROAD_EXE).",
    )
    p.add_argument(
        "--lef",
        action="append",
        default=[],
        type=Path,
        help="Technology and cell LEF for the generator (repeatable).",
    )
    p.add_argument(
        "--macro-place",
        action="append",
        default=[],
        help="A register file placed as a macro, AUTO_MEMORIES_MACRO_PLACE "
        "(repeatable); the others are inlined.",
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
    p.add_argument(
        "--top",
        help="The design's top module, which slang's per-instance module "
        "names carry.",
    )
    args = p.parse_args(argv)
    return run(
        args.yosys_json,
        args.memories,
        args.platform,
        args.out_dir,
        args.json,
        args.top,
        args.regfile_spec,
        args.openroad,
        args.lef,
        args.macro_place,
    )


if __name__ == "__main__":
    sys.exit(main())
