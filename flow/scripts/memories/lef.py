#!/usr/bin/env python3
"""Emit an abstract LEF view for a memory macro.

The shape follows the platform's fakeram abstracts: CLASS BLOCK with a
FOREIGN reference, per-bit signal pin pads stacked along the left edge
(SHAPE ABUTMENT, wrapping into further columns when one edge is not
enough), interleaved horizontal power/ground straps the platform's PDN
macro grid can connect to, and a full-footprint multi-layer OBS so the
parent's router treats the macro as opaque. Geometry comes from the
parametric area model, snapped to the manufacturing grid.
"""

from __future__ import annotations

import liberty
import schema
from pdk_asap7 import PdkParams


def emit_lef(mem: schema.Memory, params: PdkParams) -> str:
    name = mem.name
    area = liberty.predict_area_um2(mem, params.tech_nm)
    width, height = liberty.predict_dimensions_um(area)
    grid = params.grid_um
    width = max(round(width / grid) * grid, 1.0)
    height = max(round(height / grid) * grid, 1.0)

    lines: list[str] = []
    a = lines.append
    a("VERSION 5.8 ;")
    a('BUSBITCHARS "[]" ;')
    a('DIVIDERCHAR "/" ;')
    a("UNITS")
    a("    DATABASE MICRONS 1000 ;")
    a("END UNITS")
    a("")
    a(f"MACRO {name}")
    a(f"  FOREIGN {name} 0 0 ;")
    a("  SYMMETRY X Y R90 ;")
    a(f"  SIZE {width:.3f} BY {height:.3f} ;")
    a("  CLASS BLOCK ;")

    # Signal pins as small pads stacked along the left edge, like the
    # fakeram abstracts. When one column fills up, continue in the next.
    pad = params.pin_pad_um
    pitch = params.pin_pitch_um
    cursor_x = 0.0
    cursor_y = pitch

    def emit_pin(pin_name: str, direction: str) -> None:
        nonlocal cursor_x, cursor_y
        a(f"  PIN {pin_name}")
        a(f"    DIRECTION {direction.upper()} ;")
        a("    USE SIGNAL ;")
        a("    SHAPE ABUTMENT ;")
        a("    PORT")
        a(f"      LAYER {params.pin_layer} ;")
        a(
            f"      RECT {cursor_x:.3f} {cursor_y:.3f} "
            f"{cursor_x + pad:.3f} {cursor_y + pad:.3f} ;"
        )
        a("    END")
        a(f"  END {pin_name}")
        cursor_y += pitch
        if cursor_y + pad > height:
            cursor_y = pitch
            cursor_x += pitch

    for _port_id, pins in liberty.ordered_port_groups(mem):
        for pin in pins:
            if pin.width > 1:
                for bit in range(pin.width):
                    emit_pin(f"{pin.name}[{bit}]", pin.direction)
            else:
                emit_pin(pin.name, pin.direction)

    # Interleaved horizontal power/ground straps, nearly full width,
    # matching the fakeram abstracts (VSS at offset 0, VDD offset by
    # half the per-net pitch). The platform PDN's macro grid connects
    # to these.
    strap_w = params.pg_strap_w_um
    strap_pitch = params.pg_strap_pitch_um
    margin = params.pg_margin_um
    x0 = margin
    x1 = max(width - margin, x0 + grid)

    def emit_pg(pin_name: str, use: str, y_start: float) -> None:
        a(f"  PIN {pin_name}")
        a("    DIRECTION INOUT ;")
        a(f"    USE {use} ;")
        a("    PORT")
        a(f"      LAYER {params.pg_layer} ;")
        y = y_start
        while y + strap_w <= height:
            a(f"      RECT {x0:.3f} {y:.3f} {x1:.3f} {y + strap_w:.3f} ;")
            y += strap_pitch
        a("    END")
        a(f"  END {pin_name}")

    emit_pg("VDD", "POWER", params.pg_vdd_offset_um)
    emit_pg("VSS", "GROUND", 0.0)

    # Full-footprint obstruction so the parent's router treats the
    # macro as opaque (pins and straps sit on top of it, as in the
    # fakeram abstracts).
    a("  OBS")
    for layer in params.obs_device_layers + params.obs_metal_layers:
        a(f"    LAYER {layer} ;")
        a(f"    RECT 0 0 {width:.3f} {height:.3f} ;")
    a("  END")
    a(f"END {name}")
    a("")
    a("END LIBRARY")
    a("")
    return "\n".join(lines)
