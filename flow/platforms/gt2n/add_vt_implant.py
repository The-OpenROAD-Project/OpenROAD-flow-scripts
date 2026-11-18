#!/usr/bin/env python3
"""Add Vt implant layers to the gt2n LEFs.

The upstream GT2N LEFs carry no threshold-voltage information, so
OpenROAD sees every W/Vt flavor of a cell as the same Vt and the
resizer's Vt-aware moves (vt_swap, keep_sizing_vt, Vt-aware buffer
selection) do nothing. As in asap7, the resizer identifies a cell's Vt
from IMPLANT-layer obstructions in its LEF macro.

This script:
  - declares one IMPLANT layer per Vt (ELVT ULVT LVT SVT HVT) in the
    tech LEF, after the front-end MASTERSLICE layers;
  - adds a full-cell OBS rectangle on the matching layer to every macro
    in each gt2_6t_<W>_<Vt>.lef, creating the OBS block where a macro
    has none.

The rectangles mirror the GDS, where every elvt/ulvt/svt/hvt cell has a
single Vt-layer rectangle (layers 94/95/96/97 in gt2.layermap) from the
origin to the cell SIZE. LVT is the base device and has no GDS layer;
it gets an LEF-only layer so every flavor is explicit. LEF obstructions
are not streamed to GDS, so the layout is unchanged.

The script is idempotent; rerun it after re-syncing the LEFs from
upstream:
  python3 add_vt_implant.py
"""

import pathlib
import re
import sys

PLATFORM_DIR = pathlib.Path(__file__).resolve().parent
LEF_DIR = PLATFORM_DIR / "lef"
TECH_LEF = LEF_DIR / "gt2_tech.lef"

VTS = ["elvt", "ulvt", "lvt", "svt", "hvt"]

# Implant layers go after the last front-end MASTERSLICE layer.
TECH_ANCHOR = "END SDCON\n"


def add_tech_layers(path):
    text = path.read_text()
    if re.search(r"^LAYER ELVT\b", text, re.MULTILINE):
        return False
    if TECH_ANCHOR not in text:
        sys.exit(f"{path}: anchor {TECH_ANCHOR.strip()!r} not found")
    layers = "".join(
        f"\nLAYER {vt.upper()}\n  TYPE IMPLANT ;\nEND {vt.upper()}\n" for vt in VTS
    )
    path.write_text(text.replace(TECH_ANCHOR, TECH_ANCHOR + layers, 1))
    return True


def add_macro_obs(path, layer):
    lines = path.read_text().splitlines(keepends=True)
    out = []
    macro = None
    size = None
    in_obs = False
    has_obs = False
    has_layer = False
    changed = False
    for line in lines:
        stripped = line.strip()
        if m := re.match(r"MACRO\s+(\S+)", stripped):
            macro = m.group(1)
            size = None
            in_obs = has_obs = has_layer = False
        elif macro and (m := re.match(r"SIZE\s+(\S+)\s+BY\s+(\S+)\s*;", stripped)):
            size = (m.group(1), m.group(2))
        elif macro and stripped == "OBS":
            in_obs = has_obs = True
        elif in_obs and stripped == f"LAYER {layer} ;":
            has_layer = True
        elif in_obs and stripped == "END":
            if not has_layer:
                out.append(implant_rect(layer, size, macro, path))
                changed = True
            in_obs = False
        elif macro and stripped == f"END {macro}":
            if not has_obs:
                out.append("  OBS\n")
                out.append(implant_rect(layer, size, macro, path))
                out.append("  END\n")
                changed = True
            macro = None
        out.append(line)
    if changed:
        path.write_text("".join(out))
    return changed


def implant_rect(layer, size, macro, path):
    if size is None:
        sys.exit(f"{path}: macro {macro} has no SIZE before its OBS")
    width, height = size
    return f"    LAYER {layer} ;\n      RECT 0 0 {width} {height} ;\n"


def main():
    if add_tech_layers(TECH_LEF):
        print(f"updated {TECH_LEF.name}")
    for vt in VTS:
        for path in sorted(LEF_DIR.glob(f"gt2_6t_w*_{vt}.lef")):
            if add_macro_obs(path, vt.upper()):
                print(f"updated {path.name}")


if __name__ == "__main__":
    main()
