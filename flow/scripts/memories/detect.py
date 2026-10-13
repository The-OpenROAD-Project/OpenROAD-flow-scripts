#!/usr/bin/env python3
"""Detect memory modules in Yosys netlist JSON outputs ($mem_v2 cells).

Processes the JSON netlist emitted by Yosys after `proc; memory -nomap`.
Extracts memory parameters (depth, width, read/write port counts, write-enable
masks) and checks clock net equivalence across ports to determine whether all
ports share a single clock domain.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import schema


def parse_param_int(val) -> int:
    """Parse an integer parameter from Yosys JSON (handles ints and binary strings)."""
    if isinstance(val, int):
        return val
    if isinstance(val, str):
        if val.startswith("0x"):
            return int(val, 16)
        try:
            return int(val, 2)
        except ValueError:
            return int(val)
    return int(val)


# firtool names a memory module's ports by port and function -- R0_addr,
# W1_mask, RW0_wmode -- and this is the one convention read here. A module
# whose every port fits it is a memory at the module boundary, and three
# things follow that the yosys view alone gets wrong: the pins the macro
# must expose are the module's own ports, not names synthesized from port
# indices; a read-write port is one port, where yosys reports a read plus
# a write; and the write mask is as wide as the port says, not the per-bit
# enable yosys expands it into.
_FIRTOOL_PORT = re.compile(
    r"^(RW|R|W)(\d+)_(addr|en|clk|data|rdata|wdata|wmode|wmask|mask)$"
)
_FIRTOOL_FUNCTION = {
    "addr": "addr",
    "en": "en",
    "clk": "clk",
    "wmode": "wmode",
    "wmask": "mask",
    "mask": "mask",
    "wdata": "data_in",
    "rdata": "data_out",
}


def firtool_pins(mod_info: dict):
    """Pins of a module whose ports all follow firtool's memory convention.

    Returns (pins, read_ports, write_ports, rw_ports, mask_lanes), or None
    when the module has no ports or any port does not fit the convention.
    """
    ports = mod_info.get("ports", {})
    if not ports:
        return None
    pins: list[schema.Pin] = []
    kinds: dict[str, str] = {}
    mask_lanes = 0
    for name, info in ports.items():
        clean = name[1:] if name.startswith("\\") else name
        m = _FIRTOOL_PORT.match(clean)
        if not m:
            return None
        kind, index, field = m.groups()
        port_id = kind + index
        kinds[port_id] = kind
        direction = info.get("direction", "input")
        if field == "data":
            function = "data_out" if direction == "output" else "data_in"
        else:
            function = _FIRTOOL_FUNCTION[field]
        width = len(info.get("bits", [])) or 1
        if function == "mask":
            mask_lanes = max(mask_lanes, width)
        pins.append(
            schema.Pin(
                name=clean,
                direction=direction,
                width=width,
                port_id=port_id,
                function=function,
            )
        )
    found = list(kinds.values())
    return pins, found.count("R"), found.count("W"), found.count("RW"), mask_lanes


def _clock_enable_bits(val, ports: int) -> str:
    """RD_CLK_ENABLE as a string of `ports` bits, most significant first.

    yosys writes it as a binary string of exactly RD_PORTS digits. Anything
    else is refused rather than padded, truncated or read as decimal: a
    miscounted bit is a combinational read let through as a macro.
    """
    if isinstance(val, int):
        if not 0 <= val < 1 << ports:
            raise ValueError(f"RD_CLK_ENABLE {val} does not fit {ports} read ports")
        return format(val, f"0{ports}b")
    if not isinstance(val, str) or len(val) != ports or set(val) - {"0", "1"}:
        raise ValueError(
            f"RD_CLK_ENABLE {val!r} is not {ports} binary digits, one per read port"
        )
    return val


def scan_yosys_json(
    data: dict | str | Path, top: str | None = None
) -> list[schema.Memory]:
    """Extract memory modules from a Yosys netlist JSON output ($mem_v2 cells).

    `top` is the design's top module; slang's per-instance module names
    are cut back to their definition with it (see definition_name).
    """
    if isinstance(data, (str, Path)):
        data = json.loads(Path(data).read_text())

    out: list[schema.Memory] = []
    modules = data.get("modules", {})

    for mod_name, mod_info in modules.items():
        clean_mod_name = mod_name[1:] if mod_name.startswith("\\") else mod_name
        # slang's --keep-hierarchy elaborates one module per instance and
        # names it `<definition>$<instance path>`; the flow blackboxes by
        # definition (`--blackboxed-module <definition>` is what the
        # frontend honours, and the black box it imports has the
        # definition's type), so the memory is named for the definition
        # and its copies collapse into one entry below.
        clean_mod_name = definition_name(clean_mod_name, top)
        cells = mod_info.get("cells", {})
        mem_cells = [
            n for n, c in cells.items() if c.get("type", "") in ("$mem_v2", "$mem")
        ]
        for cell_name, cell_info in cells.items():
            cell_type = cell_info.get("type", "")
            if cell_type not in ("$mem_v2", "$mem"):
                continue

            params = cell_info.get("parameters", {})
            conn = cell_info.get("connections", {})

            size = parse_param_int(params.get("SIZE", 0))
            width = parse_param_int(params.get("WIDTH", 0))
            rd_ports = parse_param_int(params.get("RD_PORTS", 0))
            wr_ports = parse_param_int(params.get("WR_PORTS", 0))

            if size == 0 or width == 0:
                continue

            addr_w = (size - 1).bit_length() if size > 1 else 1

            # Clock net tracking & single-clock validation across ports
            rd_clks = conn.get("RD_CLK", [])
            wr_clks = conn.get("WR_CLK", [])
            all_clk_bits = [
                c for c in rd_clks + wr_clks if str(c) not in ("0", "1", "x", "z")
            ]
            single_clock = len(set(all_clk_bits)) <= 1

            # Write enable mask lanes
            wr_en_bits = conn.get("WR_EN", [])
            mask_lanes = 0
            if wr_ports > 0 and len(wr_en_bits) > wr_ports:
                mask_lanes = len(wr_en_bits) // wr_ports
            # A read port without a clock is a combinational read. An
            # absent parameter is yosys saying every read is clocked.
            rd_clk_enable = params.get("RD_CLK_ENABLE")
            comb_read_ports = 0
            if rd_ports and rd_clk_enable is not None:
                comb_read_ports = _clock_enable_bits(rd_clk_enable, rd_ports).count("0")

            pins: list[schema.Pin] = []

            for i in range(rd_ports):
                port_id = f"R{i}"
                pins.extend(
                    [
                        schema.Pin(
                            name=f"{port_id}_clk",
                            direction="input",
                            width=1,
                            port_id=port_id,
                            function="clk",
                        ),
                        schema.Pin(
                            name=f"{port_id}_addr",
                            direction="input",
                            width=addr_w,
                            port_id=port_id,
                            function="addr",
                        ),
                        schema.Pin(
                            name=f"{port_id}_en",
                            direction="input",
                            width=1,
                            port_id=port_id,
                            function="en",
                        ),
                        schema.Pin(
                            name=f"{port_id}_data",
                            direction="output",
                            width=width,
                            port_id=port_id,
                            function="data_out",
                        ),
                    ]
                )

            for i in range(wr_ports):
                port_id = f"W{i}"
                pins.extend(
                    [
                        schema.Pin(
                            name=f"{port_id}_clk",
                            direction="input",
                            width=1,
                            port_id=port_id,
                            function="clk",
                        ),
                        schema.Pin(
                            name=f"{port_id}_addr",
                            direction="input",
                            width=addr_w,
                            port_id=port_id,
                            function="addr",
                        ),
                        schema.Pin(
                            name=f"{port_id}_en",
                            direction="input",
                            width=1,
                            port_id=port_id,
                            function="en",
                        ),
                        schema.Pin(
                            name=f"{port_id}_data",
                            direction="input",
                            width=width,
                            port_id=port_id,
                            function="data_in",
                        ),
                    ]
                )
                if mask_lanes > 0:
                    pins.append(
                        schema.Pin(
                            name=f"{port_id}_mask",
                            direction="input",
                            width=mask_lanes,
                            port_id=port_id,
                            function="mask",
                        )
                    )

            # The module's own ports beat the synthesized pin list when
            # they follow firtool's convention: those are the names the
            # generated liberty view has to carry for the blackboxed
            # module to link at all.
            rw_ports = 0
            port_convention = ""
            convention = firtool_pins(mod_info)
            if convention is not None:
                pins, rd_ports, wr_ports, rw_ports, mask_lanes = convention
                port_convention = "firtool"
            # A module that holds nothing but one memory *is* that memory
            # and takes the module's name -- which is the name the flow
            # blackboxes. So does a firtool memory module, whatever glue
            # surrounds its array: its ports say what it is, and every one
            # calls its array `Memory`, so naming by cell would fold them
            # all into one entry. Any other memory is named per cell,
            # qualified so the names stay distinct across modules: an
            # array inside a module that also does something else is the
            # design asking for flip-flops, and idiomatic.judge refuses a
            # memory that is not named for its module.
            clean_cell = cell_name[1:] if cell_name.startswith("\\") else cell_name
            if len(mem_cells) == 1 and (port_convention or len(cells) == 1):
                mem_name = clean_mod_name
            else:
                mem_name = f"{clean_mod_name}.{clean_cell}"

            mem = schema.Memory(
                name=mem_name,
                rows=size,
                bits=width,
                addr_w=addr_w,
                read_ports=rd_ports,
                write_ports=wr_ports,
                rw_ports=rw_ports,
                mask_lanes=mask_lanes,
                comb_read_ports=comb_read_ports,
                port_convention=port_convention,
                pins=pins,
                behavioral_model={"module": clean_mod_name},
                reason=f"Yosys inferred $mem_v2 ({'single-clock' if single_clock else 'multi-clock'})",
            )
            out.append(mem)

    return dedupe(out)


def definition_name(module: str, top: str | None) -> str:
    """`array_64x114$top.u0` -> `array_64x114` for top module `top`.

    slang's instance path starts at the top module, so the name is cut
    where `$<top>.` begins, not at the first `$`: a definition may have a
    `$` of its own (`my$ram$top.u0` is `my$ram`). Any other name, yosys's
    own `$paramod\\...` names among them, is returned unchanged.
    """
    if top:
        i = module.find(f"${top}.")
        if i > 0:
            return module[:i]
    return module


def dedupe(memories: list[schema.Memory]) -> list[schema.Memory]:
    """One entry per name; copies must agree on shape and pins.

    The copies are one definition elaborated per instance, so they agree
    unless the definition is parameterised on the memory's shape -- and
    then one liberty view per definition cannot serve them, which is an
    error rather than a silent pick.
    """

    def shape(m):
        return (
            m.rows,
            m.bits,
            m.read_ports,
            m.write_ports,
            m.rw_ports,
            m.mask_lanes,
            m.comb_read_ports,
            m.port_convention,
            tuple(m.pins),
        )

    by_name: dict[str, schema.Memory] = {}
    for m in memories:
        first = by_name.get(m.name)
        if first is None:
            by_name[m.name] = m
        elif shape(first) != shape(m):
            raise ValueError(
                f"memory {m.name}: two elaborations differ in shape "
                f"({first.rows}x{first.bits} against {m.rows}x{m.bits}, or in "
                "ports); a definition parameterised on its memory cannot be "
                "one macro"
            )
    return list(by_name.values())
