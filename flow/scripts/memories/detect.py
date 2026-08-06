#!/usr/bin/env python3
"""Detect memory modules in Yosys netlist JSON outputs ($mem_v2 cells).

Processes the JSON netlist emitted by Yosys after `proc; memory -nomap`.
Extracts memory parameters (depth, width, read/write port counts, write-enable
masks) and checks clock net equivalence across ports to determine whether all
ports share a single clock domain.
"""

from __future__ import annotations

import json
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


def scan_yosys_json(data: dict | str | Path) -> list[schema.Memory]:
    """Extract memory modules from a Yosys netlist JSON output ($mem_v2 cells)."""
    if isinstance(data, (str, Path)):
        p = Path(data)
        if not p.is_file():
            return []
        data = json.loads(p.read_text())

    out: list[schema.Memory] = []
    modules = data.get("modules", {})

    for mod_name, mod_info in modules.items():
        clean_mod_name = mod_name[1:] if mod_name.startswith("\\") else mod_name
        cells = mod_info.get("cells", {})
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

            clean_cell = cell_name[1:] if cell_name.startswith("\\") else cell_name
            mem_name = clean_mod_name if len(cells) == 1 else clean_cell

            mem = schema.Memory(
                name=mem_name,
                rows=size,
                bits=width,
                addr_w=addr_w,
                read_ports=rd_ports,
                write_ports=wr_ports,
                rw_ports=0,
                mask_lanes=mask_lanes,
                pins=pins,
                behavioral_model={"module": clean_mod_name},
                reason=f"Yosys inferred $mem_v2 ({'single-clock' if single_clock else 'multi-clock'})",
            )
            out.append(mem)

    return out


def scan_files(paths: list[Path]) -> list[schema.Memory]:
    """Scan Yosys netlist JSON files; later definitions of a name win."""
    found: dict[str, schema.Memory] = {}
    for path in paths:
        for memory in scan_yosys_json(path):
            found[memory.name] = memory
    return list(found.values())
