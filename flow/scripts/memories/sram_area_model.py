#!/usr/bin/env python3
"""Parametric 7 nm-class SRAM area/power model.

Coefficients are anchored to published 7 nm SP-SRAM figures (Suzuki et
al., ISSCC 2018, "A 6T-SRAM in 7 nm FinFET CMOS" — ~0.027 µm² per bit
cell; published foundry SRAM IP figures for peripheral overhead). The
model represents what a real 7 nm SRAM compiler would emit for a given
(rows, cols, ports) spec.
"""

from __future__ import annotations

import math

# ASAP7 NAND2xp33_ASAP7_75t_R area — the smallest NAND2 in the ASAP7 RVT
# library, the customary gate-equivalent unit for converting µm² to GE.
NAND2_AREA_UM2 = 0.05832

# Calibration coefficients. Tuned against published 7 nm SP-SRAM
# references; ±10 % at the anchor and ±25 % over a 5–256 Kb sweep.
_STORAGE_PER_BIT_UM2 = 0.030  # 7 nm-class 6T bit cell.
_PERIMETER_COEFF = 5.0  # row decode + sense amps + write drivers.
_CONTROL_FIXED_UM2 = 200.0  # control + redundancy floor for tiny memories.
_PORT_FACTOR_READ = 0.25  # +25 % per extra read port.
_PORT_FACTOR_WRITE = 0.35  # +35 % per extra write port.
# Per-mask-lane bit-write-enable overhead. A masked-write SRAM gains a
# column-group write-driver gate + the mask wire routed up each column
# group; real 7 nm SP-SRAM compilers cost a per-lane write-mask option at
# roughly one extra write-driver per lane. Modeled as a flat per-lane
# peripheral adder so a wide masked macro is not scored identically to an
# unmasked array of the same (rows, cols). Zero lanes (the default)
# reproduces the unmasked model exactly.
_WRITE_MASK_PER_LANE_UM2 = NAND2_AREA_UM2 * 4.0  # ~4 NAND2/lane.

# Power-model anchors. Leakage is anchored at 85 °C because published
# 7 nm SRAM IP standby numbers are typically datasheet-quoted at 85 °C,
# not 25 °C.
_LEAKAGE_PER_BIT_PW_85C = 100.0  # mid of published 7 nm range 50-200 pW.
_LEAKAGE_SENSE_AMP_NW_PER_PORT = 5.0  # per-port sense-amp leakage adder.
_DYNAMIC_FJ_PER_COL = 1.0  # ~1 fJ per accessed-row column at 0.7 V.
_DYNAMIC_WL_FJ = 5.0  # word-line drive per access.


def sram_area_um2(
    rows: int,
    cols: int,
    read_ports: int = 1,
    write_ports: int = 1,
    tech_nm: int = 7,
    write_mask_lanes: int = 0,
) -> float:
    """Estimate SP/MP-SRAM macro area in µm².

    Storage scales linearly with bits and the multi-port factor.
    Peripheral (decode + sense + write drivers) scales with √bits — real
    SRAM compilers fold columns internally to keep the physical array
    near-square, so the cost is perimeter-shaped regardless of the
    logical (rows, cols) the caller asked for.

    The coefficients are anchored at 7 nm. For other nodes the result is
    multiplied by an ideal area-scale (tech_nm / 7)² — a first-order
    estimate, NOT a re-fit against that node's SRAM IP (advanced-node
    SRAM famously scales worse than ideal).
    """
    if rows < 1 or cols < 1:
        raise ValueError(f"rows ({rows}) and cols ({cols}) must be >= 1")
    if read_ports < 0 or write_ports < 0:
        raise ValueError(
            f"port counts must be >= 0; got "
            f"read_ports={read_ports}, write_ports={write_ports}"
        )
    if tech_nm < 1:
        raise ValueError(f"tech_nm ({tech_nm}) must be >= 1")
    if write_mask_lanes < 0:
        raise ValueError(f"write_mask_lanes ({write_mask_lanes}) must be >= 0")
    bits = rows * cols
    port_factor = (
        1.0
        + _PORT_FACTOR_READ * max(read_ports - 1, 0)
        + _PORT_FACTOR_WRITE * max(write_ports - 1, 0)
    )
    storage = bits * _STORAGE_PER_BIT_UM2 * port_factor
    perimeter = math.sqrt(bits)
    peripheral = perimeter * _PERIMETER_COEFF * port_factor + _CONTROL_FIXED_UM2
    # Per-write-port mask overhead: each write port carries
    # `write_mask_lanes` bit-write-enable gates.
    peripheral += write_mask_lanes * _WRITE_MASK_PER_LANE_UM2 * max(write_ports, 0)
    node_area_scale = (tech_nm / 7.0) ** 2
    return (storage + peripheral) * node_area_scale


def sram_leakage_pw(rows: int, cols: int, ports: int = 1) -> float:
    """Standby leakage at 85 °C TT for a 7 nm-class SRAM macro, in pW.

    Per-bit leakage anchors at ~100 pW (mid of the published 7 nm IP
    range of 50-200 pW at 85 °C). Sense-amp leakage adds ~5 nW per port.
    """
    if rows < 1 or cols < 1:
        raise ValueError(f"rows ({rows}) and cols ({cols}) must be >= 1")
    if ports < 1:
        raise ValueError(f"ports ({ports}) must be >= 1")
    bits = rows * cols
    storage_pw = bits * _LEAKAGE_PER_BIT_PW_85C
    sense_amp_pw = ports * _LEAKAGE_SENSE_AMP_NW_PER_PORT * 1000.0  # nW → pW
    return storage_pw + sense_amp_pw


def sram_dynamic_pj_per_access(rows: int, cols: int) -> float:
    """Per-access switching energy at 0.7 V, in pJ.

    One read or write activates a single row; all `cols` bit-line
    columns toggle. Word-line drive adds a small fixed term. Port count
    is deliberately not a parameter: each access costs one
    row-activation regardless of how many ports the macro exposes — the
    access *rate* is the caller's knob.
    """
    if rows < 1 or cols < 1:
        raise ValueError(f"rows ({rows}) and cols ({cols}) must be >= 1")
    bitline_fj = cols * _DYNAMIC_FJ_PER_COL
    return (bitline_fj + _DYNAMIC_WL_FJ) / 1000.0  # fJ → pJ


def sram_dimensions_um(
    area_um2: float, aspect_ratio: float = 0.5
) -> tuple[float, float]:
    """Return (width, height) in µm given total area and aspect ratio.

    ``aspect_ratio`` is height/width (0.5 → wider than tall).
    """
    if area_um2 <= 0:
        raise ValueError(f"area_um2 must be positive; got {area_um2}")
    if aspect_ratio <= 0:
        raise ValueError(f"aspect_ratio must be positive; got {aspect_ratio}")
    height = math.sqrt(area_um2 * aspect_ratio)
    width = area_um2 / height
    return width, height
