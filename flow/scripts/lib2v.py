#!/usr/bin/env python3
"""Generate Verilator-compatible behavioral Verilog from Liberty (.lib) files.

Verilator does not support Verilog-1995 UDP (User Defined Primitives) used in
the vendor-supplied behavioral models (e.g. altos_dff_sr_err).  This script
parses .lib/.lib.gz files and emits clean behavioral Verilog that Verilator can
simulate.

Supported cell types:
  - Combinational cells (SIMPLE, AO, OA, INVBUF): assign from function expr
  - Flip-flops (DFF*): always @(posedge/negedge clk) with optional async set/reset
  - Scan flip-flops (SDF*): same as DFF with scan-mux in next_state
  - Latches (DHL, DLL): level-sensitive always block
  - Clock gating cells (ICG*): latch + AND gate
  - Multi-bit DFFs (DFFHQNV2X, DFFHQNV4X, DFFHQNH2V2X): vectorized D/QN
  - Physical-only cells (TAPCELL, FILLER, DECAP): empty modules from LEF

All ASAP7 Vt variants (RVT/_R, LVT/_L, SLVT/_SL, SRAM/_SRAM) are supported.
"""

import argparse
import gzip
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Pin:
    name: str
    direction: str = ""  # input, output, internal
    function: str = ""
    state_function: str = ""
    clock: bool = False
    clock_gate_enable_pin: bool = False


@dataclass
class FFInfo:
    var1: str = ""
    var2: str = ""
    clocked_on: str = ""
    next_state: str = ""
    clear: str = ""
    preset: str = ""


@dataclass
class LatchInfo:
    var1: str = ""
    var2: str = ""
    enable: str = ""
    data_in: str = ""


@dataclass
class BundleInfo:
    name: str = ""
    members: list = field(default_factory=list)
    direction: str = ""
    function: str = ""


@dataclass
class Cell:
    name: str
    pins: dict = field(default_factory=dict)  # name -> Pin
    ff: FFInfo | None = None
    latch: LatchInfo | None = None
    bundles: list = field(default_factory=list)  # list of BundleInfo
    clock_gating: str = ""  # clock_gating_integrated_cell value


def read_lib(path: Path) -> str:
    """Read a .lib or .lib.gz file."""
    if path.suffix == ".gz":
        with gzip.open(path, "rt") as f:
            return f.read()
    else:
        with open(path) as f:
            return f.read()


def parse_lib(content: str) -> list[Cell]:
    """Parse liberty content and extract cells with their pins and sequential info."""
    cells = []
    lines = content.split("\n")
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        # Match cell declaration
        m = re.match(r"cell\s*\((\S+)\)\s*\{", line)
        if m:
            cell = Cell(name=m.group(1))
            i, cell = _parse_cell(lines, i + 1, cell)
            cells.append(cell)
        else:
            i += 1
    return cells


def _parse_cell(lines: list[str], start: int, cell: Cell) -> tuple[int, Cell]:
    """Parse cell body, tracking brace depth."""
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()

        if line == "}":
            depth -= 1
            i += 1
            continue

        # clock_gating_integrated_cell
        m = re.match(r'clock_gating_integrated_cell\s*:\s*(\S+)\s*;', line)
        if m:
            cell.clock_gating = m.group(1)
            i += 1
            continue

        # ff group (also matches ff_bank with optional bit count)
        m = re.match(r'ff(?:_bank)?\s*\((\w+)\s*,\s*(\w+)(?:\s*,\s*\d+)?\)\s*\{', line)
        if m:
            cell.ff = FFInfo(var1=m.group(1), var2=m.group(2))
            i = _parse_ff(lines, i + 1, cell.ff)
            continue

        # latch group
        m = re.match(r'latch\s*\((\w+)\s*,\s*(\w+)\)\s*\{', line)
        if m:
            cell.latch = LatchInfo(var1=m.group(1), var2=m.group(2))
            i = _parse_latch(lines, i + 1, cell.latch)
            continue

        # bundle group
        m = re.match(r'bundle\s*\((\w+)\)\s*\{', line)
        if m:
            bundle = BundleInfo(name=m.group(1))
            i = _parse_bundle(lines, i + 1, bundle)
            cell.bundles.append(bundle)
            continue

        # pin group
        m = re.match(r'pin\s*\((\w+)\)\s*\{', line)
        if m:
            pin = Pin(name=m.group(1))
            if _is_single_line_group(line):
                _parse_pin_inline(line, pin)
                i += 1
            else:
                i = _parse_pin(lines, i + 1, pin)
            cell.pins[pin.name] = pin
            continue

        # pg_pin or other groups - skip
        if "{" in line:
            if _is_single_line_group(line):
                i += 1
            else:
                i = _skip_group(lines, i + 1)
            continue

        i += 1

    return i, cell


def _parse_ff(lines: list[str], start: int, ff: FFInfo) -> int:
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()
        if line == "}":
            depth -= 1
            i += 1
            continue
        if "{" in line:
            i = _skip_group(lines, i + 1)
            continue
        m = re.match(r'clocked_on\s*:\s*"(.+?)"\s*;', line)
        if m:
            ff.clocked_on = m.group(1)
        m = re.match(r'next_state\s*:\s*"(.+?)"\s*;', line)
        if m:
            ff.next_state = m.group(1)
        m = re.match(r'clear\s*:\s*"(.+?)"\s*;', line)
        if m:
            ff.clear = m.group(1)
        m = re.match(r'preset\s*:\s*"(.+?)"\s*;', line)
        if m:
            ff.preset = m.group(1)
        i += 1
    return i


def _parse_latch(lines: list[str], start: int, latch: LatchInfo) -> int:
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()
        if line == "}":
            depth -= 1
            i += 1
            continue
        if "{" in line:
            i = _skip_group(lines, i + 1)
            continue
        m = re.match(r'enable\s*:\s*"(.+?)"\s*;', line)
        if m:
            latch.enable = m.group(1)
        m = re.match(r'data_in\s*:\s*"(.+?)"\s*;', line)
        if m:
            latch.data_in = m.group(1)
        i += 1
    return i


def _parse_bundle(lines: list[str], start: int, bundle: BundleInfo) -> int:
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()
        if line == "}":
            depth -= 1
            i += 1
            continue
        m = re.match(r'members\s*\((.+?)\)\s*;', line)
        if m:
            bundle.members = [x.strip() for x in m.group(1).split(",")]
        m = re.match(r'direction\s*:\s*(\w+)\s*;', line)
        if m:
            bundle.direction = m.group(1)
        m = re.match(r'function\s*:\s*"(.+?)"\s*;', line)
        if m:
            bundle.function = m.group(1)
        # Skip nested groups (pin sub-groups within bundle)
        if "{" in line:
            i = _skip_group(lines, i + 1)
            continue
        i += 1
    return i


def _parse_pin(lines: list[str], start: int, pin: Pin) -> int:
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()
        if line == "}":
            depth -= 1
            i += 1
            continue
        if "{" in line:
            i = _skip_group(lines, i + 1)
            continue
        m = re.match(r'direction\s*:\s*(\w+)\s*;', line)
        if m:
            pin.direction = m.group(1)
        m = re.match(r'function\s*:\s*"(.+?)"\s*;', line)
        if m and "power_down" not in line:
            pin.function = m.group(1)
        m = re.match(r'state_function\s*:\s*"(.+?)"\s*;', line)
        if m:
            pin.state_function = m.group(1)
        if re.match(r'clock\s*:\s*true\s*;', line):
            pin.clock = True
        if re.match(r'clock_gate_enable_pin\s*:\s*true\s*;', line):
            pin.clock_gate_enable_pin = True
        i += 1
    return i


def _is_single_line_group(line: str) -> bool:
    """Check if a group opens and closes on the same line."""
    return line.count("{") == line.count("}")


def _parse_pin_inline(line: str, pin: Pin):
    """Parse pin attributes from a single-line group like: pin (X) { direction : input; }"""
    m = re.search(r'direction\s*:\s*(\w+)', line)
    if m:
        pin.direction = m.group(1)
    m = re.search(r'(?<!power_down_)function\s*:\s*"(.+?)"', line)
    if m:
        pin.function = m.group(1)
    m = re.search(r'state_function\s*:\s*"(.+?)"', line)
    if m:
        pin.state_function = m.group(1)
    if re.search(r'clock\s*:\s*true', line):
        pin.clock = True
    if re.search(r'clock_gate_enable_pin\s*:\s*true', line):
        pin.clock_gate_enable_pin = True


def _skip_group(lines: list[str], start: int) -> int:
    """Skip a brace-delimited group."""
    i = start
    depth = 1
    while i < len(lines) and depth > 0:
        line = lines[i].strip()
        depth += line.count("{") - line.count("}")
        i += 1
    return i


def liberty_to_verilog(expr: str) -> str:
    """Convert a liberty boolean expression to Verilog.

    Liberty uses: * (AND), + (OR), ! (NOT), ^ (XOR)
    Verilog uses: & (AND), | (OR), ~ (NOT), ^ (XOR)
    """
    result = []
    i = 0
    while i < len(expr):
        ch = expr[i]
        if ch == "*":
            result.append("&")
        elif ch == "+":
            result.append("|")
        elif ch == "!":
            result.append("~")
        elif ch == "&":
            # liberty uses & for AND in some contexts (e.g. state_function)
            result.append("&")
        else:
            result.append(ch)
        i += 1
    return "".join(result)


def _extract_signal_from_expr(expr: str) -> tuple[str, bool]:
    """Extract signal name and polarity from a simple liberty expression.

    Returns (signal_name, is_negated).
    e.g. "!SETN" -> ("SETN", True), "CLK" -> ("CLK", False)
    """
    expr = expr.strip()
    if expr.startswith("!"):
        return expr[1:], True
    return expr, False


def generate_verilog(cell: Cell) -> str:
    """Generate behavioral Verilog for a cell."""
    if cell.bundles:
        return _generate_bundle_dff(cell)
    if cell.clock_gating:
        return _generate_icg(cell)
    if cell.ff:
        return _generate_ff(cell)
    if cell.latch:
        return _generate_latch(cell)
    # Combinational
    return _generate_combinational(cell)


def _get_io_pins(cell: Cell) -> tuple[list[Pin], list[Pin]]:
    """Get (input_pins, output_pins) excluding power/internal."""
    inputs = []
    outputs = []
    for pin in cell.pins.values():
        if pin.direction == "input":
            inputs.append(pin)
        elif pin.direction == "output":
            outputs.append(pin)
    return inputs, outputs


def _module_header(cell: Cell, inputs: list[str], outputs: list[str],
                   reg_outputs: list[str] | None = None) -> list[str]:
    """Generate module header lines."""
    all_ports = outputs + inputs
    lines = [
        f"module {cell.name} ({', '.join(all_ports)});",
    ]
    if outputs:
        if reg_outputs:
            reg_out = [p for p in outputs if p in reg_outputs]
            wire_out = [p for p in outputs if p not in reg_outputs]
            if reg_out:
                lines.append(f"    output reg {', '.join(reg_out)};")
            if wire_out:
                lines.append(f"    output {', '.join(wire_out)};")
        else:
            lines.append(f"    output {', '.join(outputs)};")
    if inputs:
        lines.append(f"    input {', '.join(inputs)};")
    return lines


def _generate_combinational(cell: Cell) -> str:
    inputs, outputs = _get_io_pins(cell)
    in_names = [p.name for p in inputs]
    out_names = [p.name for p in outputs]

    if not out_names:
        # Physical-only cell (should not happen from lib, but guard)
        return _generate_empty_module(cell.name, in_names)

    lines = _module_header(cell, in_names, out_names)
    for pin in outputs:
        if pin.function:
            vexpr = liberty_to_verilog(pin.function)
            lines.append(f"    assign {pin.name} = {vexpr};")
    lines.append("endmodule")
    return "\n".join(lines)


def _generate_ff(cell: Cell) -> str:
    ff = cell.ff
    inputs, outputs = _get_io_pins(cell)
    in_names = [p.name for p in inputs]
    out_names = [p.name for p in outputs]

    # Determine clock edge
    clk_signal, clk_negated = _extract_signal_from_expr(ff.clocked_on)
    edge = "negedge" if clk_negated else "posedge"

    # Build sensitivity list
    sens = [f"{edge} {clk_signal}"]

    # Async clear/preset
    clear_signal = clear_neg = None
    preset_signal = preset_neg = None
    if ff.clear:
        clear_signal, clear_neg = _extract_signal_from_expr(ff.clear)
        clear_edge = "negedge" if clear_neg else "posedge"
        sens.append(f"{clear_edge} {clear_signal}")
    if ff.preset:
        preset_signal, preset_neg = _extract_signal_from_expr(ff.preset)
        preset_edge = "negedge" if preset_neg else "posedge"
        sens.append(f"{preset_edge} {preset_signal}")

    # State variable
    state_var = ff.var1
    next_state_verilog = liberty_to_verilog(ff.next_state)

    # Output mapping: output pins reference state variables via function
    lines = _module_header(cell, in_names, out_names)
    lines.append(f"    reg {state_var};")

    lines.append(f"    always @({' or '.join(sens)}) begin")
    if ff.clear:
        cond = f"~{clear_signal}" if clear_neg else clear_signal
        lines.append(f"        if ({cond})")
        lines.append(f"            {state_var} <= 1'b0;")
        if ff.preset:
            pcond = f"~{preset_signal}" if preset_neg else preset_signal
            lines.append(f"        else if ({pcond})")
            lines.append(f"            {state_var} <= 1'b1;")
        lines.append("        else")
        lines.append(f"            {state_var} <= {next_state_verilog};")
    elif ff.preset:
        pcond = f"~{preset_signal}" if preset_neg else preset_signal
        lines.append(f"        if ({pcond})")
        lines.append(f"            {state_var} <= 1'b1;")
        lines.append("        else")
        lines.append(f"            {state_var} <= {next_state_verilog};")
    else:
        lines.append(f"        {state_var} <= {next_state_verilog};")
    lines.append("    end")

    # Output assignments
    for pin in outputs:
        if pin.function:
            vexpr = liberty_to_verilog(pin.function)
            lines.append(f"    assign {pin.name} = {vexpr};")

    lines.append("endmodule")
    return "\n".join(lines)


def _generate_latch(cell: Cell) -> str:
    latch = cell.latch
    inputs, outputs = _get_io_pins(cell)
    in_names = [p.name for p in inputs]
    out_names = [p.name for p in outputs]

    state_var = latch.var1
    enable_verilog = liberty_to_verilog(latch.enable)
    data_verilog = liberty_to_verilog(latch.data_in)

    lines = _module_header(cell, in_names, out_names)
    lines.append(f"    reg {state_var};")
    lines.append(f"    always @* begin")
    lines.append(f"        if ({enable_verilog})")
    lines.append(f"            {state_var} = {data_verilog};")
    lines.append(f"    end")

    for pin in outputs:
        if pin.function:
            vexpr = liberty_to_verilog(pin.function)
            lines.append(f"    assign {pin.name} = {vexpr};")

    lines.append("endmodule")
    return "\n".join(lines)


def _generate_icg(cell: Cell) -> str:
    """Generate clock gating cell: latch + AND."""
    inputs, outputs = _get_io_pins(cell)
    in_names = [p.name for p in inputs]
    out_names = [p.name for p in outputs]

    # Find the enable and SE pins
    ena_pin = None
    se_pin = None
    clk_pin = None
    for pin in inputs:
        if pin.clock:
            clk_pin = pin
        elif pin.clock_gate_enable_pin:
            ena_pin = pin
        elif pin.name == "SE":
            se_pin = pin

    # Find internal pin for latch state
    internal_pin = None
    for pin in cell.pins.values():
        if pin.direction == "internal":
            internal_pin = pin
            break

    # Find output with state_function
    out_pin = outputs[0] if outputs else None

    lines = _module_header(cell, in_names, out_names)
    latch_var = internal_pin.name if internal_pin else "latch_out"
    lines.append(f"    reg {latch_var};")

    # Latch: transparent when CLK is low
    latch_data_parts = []
    if ena_pin:
        latch_data_parts.append(ena_pin.name)
    if se_pin:
        latch_data_parts.append(se_pin.name)
    latch_data = " | ".join(latch_data_parts) if latch_data_parts else "1'b0"

    clk_name = clk_pin.name if clk_pin else "CLK"
    lines.append(f"    always @* begin")
    lines.append(f"        if (~{clk_name})")
    lines.append(f"            {latch_var} = {latch_data};")
    lines.append(f"    end")

    # Output: CLK & latch
    if out_pin and out_pin.state_function:
        vexpr = liberty_to_verilog(out_pin.state_function)
        lines.append(f"    assign {out_pin.name} = {vexpr};")
    elif out_pin:
        lines.append(f"    assign {out_pin.name} = {clk_name} & {latch_var};")

    lines.append("endmodule")
    return "\n".join(lines)


def _generate_bundle_dff(cell: Cell) -> str:
    """Generate multi-bit DFF from FAKE lib bundle cells."""
    ff = cell.ff
    if not ff:
        # Shouldn't happen for bundle cells, but guard
        return _generate_combinational(cell)

    clk_signal, clk_negated = _extract_signal_from_expr(ff.clocked_on)
    edge = "negedge" if clk_negated else "posedge"

    # Separate bundles into input and output
    in_bundle = None
    out_bundle = None
    for b in cell.bundles:
        if b.direction == "input":
            in_bundle = b
        elif b.direction == "output":
            out_bundle = b

    # Collect all port names
    in_names = [clk_signal]
    out_names = []
    d_members = []
    q_members = []

    if in_bundle:
        d_members = in_bundle.members
        in_names.extend(d_members)
    if out_bundle:
        q_members = out_bundle.members
        out_names.extend(q_members)

    # Also include non-bundle input pins
    for pin in cell.pins.values():
        if pin.direction == "input" and pin.name not in in_names:
            in_names.append(pin.name)

    lines = _module_header(cell, in_names, out_names, reg_outputs=q_members)

    # Determine the next_state transform
    # e.g. "!D" means QNi <= ~Di
    ns = ff.next_state.strip()
    invert = ns.startswith("!")

    lines.append(f"    always @({edge} {clk_signal}) begin")
    for d, q in zip(d_members, q_members):
        if invert:
            lines.append(f"        {q} <= ~{d};")
        else:
            lines.append(f"        {q} <= {d};")
    lines.append("    end")
    lines.append("endmodule")
    return "\n".join(lines)


def generate_empty_module(name: str) -> str:
    """Generate an empty module for a physical-only cell."""
    return f"module {name};\nendmodule"


def _generate_empty_module(name: str, inputs: list[str]) -> str:
    if inputs:
        lines = [
            f"module {name} ({', '.join(inputs)});",
            f"    input {', '.join(inputs)};",
            "endmodule",
        ]
        return "\n".join(lines)
    return f"module {name};\nendmodule"


def parse_lef_physical_only(path: Path) -> list[str]:
    """Extract MACRO names from a LEF file that have no signal pins.

    Physical-only cells (TAPCELL, FILLER, DECAP) have only POWER/GROUND
    pins and no SIGNAL pins, so they need empty Verilog module stubs.
    """
    names = []
    with open(path) as f:
        content = f.read()
    for m in re.finditer(
        r"^MACRO\s+(\S+)\s*\n(.*?)^END\s+\1",
        content, re.MULTILINE | re.DOTALL
    ):
        name = m.group(1)
        body = m.group(2)
        has_signal_pin = bool(re.search(r"USE\s+SIGNAL\s*;", body))
        if not has_signal_pin:
            names.append(name)
    return names


def find_physical_only_cells(lef_dir: Path, lib_cells: set[str]) -> list[str]:
    """Find physical-only cells in LEF (no signal pins, not in any lib)."""
    physical = []
    for lef_path in sorted(lef_dir.glob("asap7sc7p5t_*.lef")):
        for name in parse_lef_physical_only(lef_path):
            if name not in lib_cells:
                physical.append(name)
    return sorted(physical)


def main():
    parser = argparse.ArgumentParser(
        description="Generate behavioral Verilog from Liberty (.lib) files"
    )
    parser.add_argument(
        "lib_files", nargs="+", type=Path,
        help="Input .lib or .lib.gz files"
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=None,
        help="Output .v file (default: stdout)"
    )
    parser.add_argument(
        "--lef-dir", type=Path, default=None,
        help="LEF directory to scan for physical-only cells (TAPCELL, FILLER, DECAP)"
    )
    args = parser.parse_args()

    all_cells = []
    seen_names = set()

    for lib_path in args.lib_files:
        content = read_lib(lib_path)
        cells = parse_lib(content)
        for cell in cells:
            if cell.name not in seen_names:
                all_cells.append(cell)
                seen_names.add(cell.name)

    # Generate verilog
    modules = []
    for cell in all_cells:
        modules.append(generate_verilog(cell))

    # Physical-only cells from LEF
    if args.lef_dir:
        physical_cells = find_physical_only_cells(args.lef_dir, seen_names)
        for name in physical_cells:
            modules.append(generate_empty_module(name))

    output = "\n\n".join(modules) + "\n"

    if args.output:
        args.output.write_text(output)
        print(f"Wrote {len(all_cells)} cells to {args.output}", file=sys.stderr)
    else:
        print(output)


if __name__ == "__main__":
    main()
