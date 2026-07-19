#!/usr/bin/env python3
"""PDK parameters for generated memory macro .lib/.lef files.

The emitters in liberty.py / lef.py are structured generally and take a
PdkParams; this module holds what is platform-specific. Only asap7 is
supported — its values match the conventions of the checked-in
platforms/asap7 fakeram7_* artifacts (signal pins and power straps on
M4, where the platform's PDN macro grid connects M4 to the M5 stripes).
Supporting another PDK means adding a PdkParams for it here; a
first-pass separation of general and asap7 concerns, generalization is
future work.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class PdkParams:
    name: str
    tech_nm: int
    nom_voltage: float
    # Layer signal/clock pins are drawn on, and the pin pad size /
    # pitch along the macro edge.
    pin_layer: str
    pin_pad_um: float
    pin_pitch_um: float
    # Manufacturing-grid snap for the macro outline.
    grid_um: float
    # Horizontal power/ground straps: layer, width, per-net pitch, and
    # the VDD offset relative to VSS (interleaved straps).
    pg_layer: str
    pg_strap_w_um: float
    pg_strap_pitch_um: float
    pg_vdd_offset_um: float
    pg_margin_um: float
    # Layers obstructed over the full macro footprint. Device-recognition
    # layers go in their own tuple (empty for PDKs that do not define
    # them — naming an unknown layer fails the parent's OpenDB LEF read).
    obs_metal_layers: tuple[str, ...]
    obs_device_layers: tuple[str, ...]


ASAP7 = PdkParams(
    name="asap7",
    tech_nm=7,
    nom_voltage=0.77,
    pin_layer="M4",
    pin_pad_um=0.024,
    pin_pitch_um=0.048,
    grid_um=0.024,
    pg_layer="M4",
    pg_strap_w_um=0.096,
    pg_strap_pitch_um=0.768,
    pg_vdd_offset_um=0.384,
    pg_margin_um=0.048,
    obs_metal_layers=("M1", "M2", "M3", "M4"),
    obs_device_layers=(),
)

PLATFORMS = {p.name: p for p in (ASAP7,)}


def get_platform(name: str) -> PdkParams:
    try:
        return PLATFORMS[name]
    except KeyError:
        raise ValueError(
            f"AUTO_MEMORIES supports only {', '.join(sorted(PLATFORMS))}; "
            f"got platform '{name}'"
        ) from None
