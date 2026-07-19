#!/usr/bin/env python3
"""Detect memory modules in Verilog sources by port-naming convention.

Scans Verilog for modules whose entire port list follows the firtool
(CIRCT) memory port convention: every port is named
``<R|W|RW><n>_<function>`` — e.g. ``R0_addr``, ``W0_en``, ``RW0_wdata``,
or the subword-split variants ``RW0_wdata_3`` / ``W0_mask_2``. Such
modules are the memory wrappers emitted by Chisel/firtool (and by other
generators that follow the same convention), and are the unit
AUTO_MEMORIES turns into macros.

Yak-shave deliberately not done in this PR: yosys could be wired up as
the memory detector instead of this ad-hoc Python scanner — its memory
inference pass also finds memories that are embedded inside a larger
module rather than separated out into a module with a name of its own
(the case FPGA tools handle). Then again, perhaps OpenROAD SYN could
become such a memory detector — it currently has no memory inference
pass, which is also why this flow cannot simply lean on yosys inference.
Punt on all of that with a fast, simple Python scanner.
"""

from __future__ import annotations

import re
from pathlib import Path

import schema

_MODULE_HEADER_RE = re.compile(r"^\s*module\s+(\w+)\b", re.MULTILINE)
# Capture every port — including names that follow a continuation comma
# without their own `input`/`output` keyword (firtool emits `R0_clk` that
# way). Each `input|output` group is a region running to the next
# direction keyword or `);`, and the names inside are comma-separated.
_DIR_REGION_RE = re.compile(
    r"\b(input|output|inout)\b\s*(\[[^\]]+\])?([^()]*?)"
    r"(?=\b(?:input|output|inout)\b|\);)",
    re.DOTALL,
)
_BUS_WIDTH_RE = re.compile(r"\[\s*(\d+)\s*:\s*(\d+)\s*\]")
_NAME_RE = re.compile(r"\b([A-Za-z_]\w*)\b")
_PORT_PIN_RE = re.compile(r"^(RW|R|W)(\d+)_([A-Za-z][A-Za-z0-9_]*)$")
_SUBWORD_RE = re.compile(r"^(.*?)(?:_(\d+))?$")


def _parse_module_ports(body: str) -> list[tuple[str, str, int]]:
    """Return (name, direction, width) for each port of one module body."""
    ports: list[tuple[str, str, int]] = []
    open_paren = body.find("(")
    if open_paren < 0:
        return ports
    close = body.find(");", open_paren)
    if close < 0:
        return ports
    portlist = body[open_paren + 1 : close + 2]
    for m in _DIR_REGION_RE.finditer(portlist):
        direction = m.group(1)
        bracket = m.group(2)
        rest = m.group(3)
        width = 1
        if bracket:
            bm = _BUS_WIDTH_RE.search(bracket)
            if bm:
                width = abs(int(bm.group(1)) - int(bm.group(2))) + 1
            else:
                # Parameterized or otherwise non-literal bus width:
                # disqualify the module rather than silently modeling
                # the port as 1 bit wide (it falls back to flops).
                return []
        for chunk in rest.split(","):
            nm = _NAME_RE.search(chunk)
            if not nm:
                continue
            name = nm.group(1)
            if name in ("input", "output", "inout"):
                continue
            ports.append((name, direction, width))
    return ports


def _classify_tail(kind: str, tail: str) -> str | None:
    """Map a pin-name tail to a schema pin function, or None if unknown.

    Subword-split data and mask pins (`wdata_3`, `mask_0`) map to the
    same function as their unsplit form; the split only affects how many
    pins carry the function.
    """
    if tail in ("addr", "en", "wmode", "clk"):
        return tail
    base = _SUBWORD_RE.match(tail).group(1)
    if base in ("mask", "wmask"):
        return "mask"
    if base == "wdata":
        return "data_in"
    if base == "rdata":
        return "data_out"
    if base == "data":
        if kind == "R":
            return "data_out"
        if kind == "W":
            return "data_in"
        return None  # RW ports must use wdata/rdata
    return None


def classify_module(
    name: str, ports: list[tuple[str, str, int]], source_file: str = ""
) -> schema.Memory | None:
    """Build a Memory from a module port list, or None if not a memory.

    A module qualifies only when *every* port matches the convention —
    a single unrecognized port disqualifies it, so ordinary logic
    modules that happen to contain an `R0_...` name are not swept in.
    """
    if not ports:
        return None
    pins: list[schema.Pin] = []
    groups: dict[str, list[schema.Pin]] = {}
    for pname, direction, width in ports:
        m = _PORT_PIN_RE.match(pname)
        if not m:
            return None
        kind, num, tail = m.group(1), m.group(2), m.group(3)
        function = _classify_tail(kind, tail)
        if function is None:
            return None
        pin = schema.Pin(
            name=pname,
            direction=direction,
            width=width,
            port_id=kind + num,
            function=function,
        )
        pins.append(pin)
        groups.setdefault(kind + num, []).append(pin)

    n_read = n_write = n_rw = 0
    addr_w = 0
    bits = 0
    mask_lanes = 0
    for port_id, group in groups.items():
        functions = {p.function for p in group}
        if "clk" not in functions or "addr" not in functions:
            return None
        if port_id.startswith("RW"):
            if not {"wmode", "data_in", "data_out"} <= functions:
                return None
            n_rw += 1
        elif port_id.startswith("R"):
            if "data_out" not in functions:
                return None
            n_read += 1
        else:
            if "data_in" not in functions:
                return None
            n_write += 1
        addr_w = max(addr_w, max(p.width for p in group if p.function == "addr"))
        for function in ("data_in", "data_out"):
            bits = max(bits, sum(p.width for p in group if p.function == function))
        mask_lanes = max(
            mask_lanes, sum(p.width for p in group if p.function == "mask")
        )
    if addr_w == 0 or bits == 0:
        return None
    return schema.Memory(
        name=name,
        rows=1 << addr_w,
        bits=bits,
        addr_w=addr_w,
        read_ports=n_read,
        write_ports=n_write,
        rw_ports=n_rw,
        mask_lanes=mask_lanes,
        pins=pins,
        behavioral_model={"file": source_file, "module": name},
    )


def scan_text(text: str, source_file: str = "") -> list[schema.Memory]:
    """Find every memory-shaped module in one Verilog text."""
    out: list[schema.Memory] = []
    # Strip block and line comments so a comment inside a port list (or
    # a commented-out module) cannot confuse the port parser.
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    text = re.sub(r"//[^\n]*", "", text)
    headers = list(_MODULE_HEADER_RE.finditer(text))
    for i, m in enumerate(headers):
        start = m.start()
        end = headers[i + 1].start() if i + 1 < len(headers) else len(text)
        memory = classify_module(
            m.group(1), _parse_module_ports(text[start:end]), source_file
        )
        if memory is not None:
            out.append(memory)
    return out


def scan_files(paths: list[Path]) -> list[schema.Memory]:
    """Scan Verilog files; later definitions of a name win."""
    found: dict[str, schema.Memory] = {}
    for path in paths:
        for memory in scan_text(path.read_text(errors="replace"), str(path)):
            found[memory.name] = memory
    return list(found.values())
