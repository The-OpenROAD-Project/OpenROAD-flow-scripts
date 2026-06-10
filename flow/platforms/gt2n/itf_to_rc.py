"""Derive per-length R and C (metals) and per-via R (vias) from GT2.itf.

Outputs Tcl set_layer_rc commands matching the existing setRC.tcl format.
Units: R in ohm/um for metals (ohm/via for vias), C in pf/um, matching the
gt2n libs (pulling_resistance_unit=1ohm, capacitive_load_unit=1pf).

Model:
  R/um  = RPSQ / WMIN
  C/um  = (Ca + Cb)*FRINGE_FACTOR + 2*Cc
    Ca = eps0 * eps_above * W / d_above   parallel-plate to layer above
    Cb = eps0 * eps_below * W / d_below   parallel-plate to layer below
    Cc = eps0 * eps_side  * T / SMIN      between sidewalls of min-spaced neighbors
"""

import re

EPS0 = 8.854e-3
FRINGE_FACTOR = 1.5
PF_PER_FF = 1.0e-3

ROUTING = {
    "M0",
    "M1",
    "M2",
    "M3",
    "M4",
    "M5",
    "M6",
    "M7",
    "M8",
    "M9",
    "M10",
    "M11",
    "M12",
    "M13",
    "RDL",
    "BPR",
    "BM1",
    "BM2",
    "BM3",
    "BM4",
    "BRDL",
}

# dielectrics to ignore when looking up neighbors (file-end placeholder)
IGNORE_DIELS = {"dummy_diel"}


def parse_itf(path):
    text = re.sub(r"\$[^\n]*\n", "\n", open(path).read())
    entries = []
    for m in re.finditer(r"(DIELECTRIC|CONDUCTOR|VIA)\s+(\w+)\s*\{([^}]*)\}", text):
        kind, name, body = m.group(1), m.group(2), m.group(3)
        params = {k: float(v) for k, v in re.findall(r"(\w+)\s*=\s*([\d.]+)", body)}
        # also accept upper/lower text fields like FROM/TO for VIA
        for k, v in re.findall(r"(\w+)\s*=\s*([A-Za-z]\w*)", body):
            params.setdefault(k, v)
        entries.append((kind, name, params))
    return entries


def metal_rc(entries, idx):
    cond = entries[idx][2]
    # dielectric above (closest, ignoring placeholders)
    above = None
    for j in range(idx - 1, -1, -1):
        if entries[j][0] == "DIELECTRIC" and entries[j][1] not in IGNORE_DIELS:
            above = entries[j][2]
            break
    # dielectric below (closest, stop at next conductor)
    below = None
    for j in range(idx + 1, len(entries)):
        if entries[j][0] == "CONDUCTOR":
            break
        if entries[j][0] == "DIELECTRIC" and entries[j][1] not in IGNORE_DIELS:
            below = entries[j][2]
            break
    W, S, T = cond["WMIN"], cond["SMIN"], cond["THICKNESS"]
    R = cond["RPSQ"] / W

    def pp(d):
        return EPS0 * d["ER"] * W / d["THICKNESS"] if d else 0.0

    Ca, Cb = pp(above), pp(below)
    eps_side = (above or below)["ER"] if (above or below) else 1.0
    Cc = EPS0 * eps_side * T / S
    C_fF = (Ca + Cb) * FRINGE_FACTOR + 2 * Cc
    return R, C_fF * PF_PER_FF


if __name__ == "__main__":
    entries = parse_itf("/home/mrg/orfs/GT2N/nxtgrd/GT2.itf")
    print("# Per-length metal R and C, derived analytically from GT2.itf.")
    print("# R/um = RPSQ / WMIN  (matches Fig 1(b) of the GT2N paper).")
    print(
        "# C/um = parallel-plate-to-neighbor + sidewall-coupling, fringe-scaled 1.5x."
    )
    print(
        "# pulling_resistance_unit=1ohm -> ohm/um ; capacitive_load_unit(1, pf) -> pf/um."
    )
    print()
    for i, (kind, name, _) in enumerate(entries):
        if kind == "CONDUCTOR" and name in ROUTING:
            R, C = metal_rc(entries, i)
            print(
                f"set_layer_rc -layer {name:<5} -resistance {R:8.3f} -capacitance {C:.3e}"
            )
    print()
    print("# Via resistance (single via). Derived from ITF VIA RPV values.")
    print()
    for kind, name, p in entries:
        if kind == "VIA" and name.startswith(("V", "BV")) and "RPV" in p:
            print(f'set_layer_rc -via {name:<4} -resistance {p["RPV"]:.3f}')
