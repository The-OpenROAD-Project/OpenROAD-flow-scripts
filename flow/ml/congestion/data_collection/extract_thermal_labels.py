"""
Extract thermal labels from a placed ODB using HotSpot v7.

Pipeline:
  1. Read ODB  →  get per-instance (position, area)
  2. Use cell area as a leakage-power proxy, binned onto a grid
  3. Write HotSpot .flp (floorplan) and .ptrace (power trace) files
  4. Run HotSpot in steady-state block-model mode
  5. Parse .steady output  →  thermal heatmap on the same 64x64 grid
     used by congestion labels

Why area as a power proxy?
  Steady-state temperature is dominated by power density distribution,
  and leakage power in standard cells scales roughly linearly with area
  for a given process node. This gives a realistic relative thermal map
  without needing switching activity or full STA.

Power scaling — constant power density (W/mm²):
  Total power is set to POWER_DENSITY_W_PER_MM2 × die_area so that
  power density is constant across all designs and process nodes.
  With fixed total power (the old approach), a 50 µm asap7 die got
  the same 500 mW as a 3 mm ariane133 die, producing absurd 2000°C
  temperatures on tiny dies. With constant density, steady-state
  temperatures become comparable across designs (~100°C range), making
  the thermal labels physically consistent for cross-design training.

Adaptive grid:
  HotSpot's block RC model becomes singular when cells are smaller than
  ~5 µm. For small dies (asap7 at 50 µm × 50 µm), the HotSpot run uses
  a coarser grid (capped so each cell is ≥ MIN_CELL_UM), then the result
  is bilinearly upsampled to the target grid (default 64) for training
  consistency. The saved power_grid is always at the target resolution.

Run inside Docker (requires openroad/orfs-ml:latest):
  openroad -python extract_thermal_labels.py \\
      --odb  <3_place.odb or 5_1_grt.odb> \\
      --out  <path_thermal_labels.npz>     \\
      [--grid 64] [--power-density 10.0]
"""

import argparse
import subprocess
import tempfile
from pathlib import Path

import numpy as np
from openroad import Design, Tech

# HotSpot's block model becomes ill-conditioned below this cell dimension.
# Derived empirically: 5 µm gives stable LU decomposition across all tested
# process nodes (asap7 at 7nm, nangate45, sky130hd).
MIN_CELL_UM = 5.0

# Uniform baseline added to every power cell to prevent zero-power rows in the
# thermal conductance matrix (which cause singular-matrix errors in lupdcmp).
# Expressed as a fraction of total_power_w / number_of_cells.
POWER_FLOOR_FRAC = 0.01

# Power density used to compute total chip power from die area.
# Calibrated so nangate45 designs (~0.06 mm²) get ~100°C with HotSpot's
# default package model. Constant density means temperature is comparable
# across all designs and process nodes.
POWER_DENSITY_W_PER_MM2 = 10.0


def _parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--odb", required=True,
                    help="Placed ODB (3_place.odb or 5_1_grt.odb)")
    ap.add_argument("--out", required=True,
                    help="Output .npz path for thermal labels")
    ap.add_argument("--grid", type=int, default=64,
                    help="Output grid resolution (default 64 → 64x64). "
                         "HotSpot may use a coarser grid internally for small dies.")
    ap.add_argument("--power-density", type=float, default=POWER_DENSITY_W_PER_MM2,
                    help=f"Power density in W/mm² (default {POWER_DENSITY_W_PER_MM2}). "
                         "Total power = density × die_area, keeping temperatures "
                         "physically consistent across process nodes.")
    return ap.parse_args()


# ── Phase 1: power grid from ODB ───────────────────────────────────────────

def _dbu_to_m(val: float, dbu_per_um: float) -> float:
    """Convert OpenDB database units → metres."""
    return val / dbu_per_um * 1e-6


def _adaptive_hotspot_grid(die_w_m: float, die_h_m: float, target_grid: int) -> int:
    """
    Return the HotSpot grid size to use, capped so each cell is >= MIN_CELL_UM.
    If the die is large enough for the full target_grid, returns target_grid.
    """
    min_dim_um = min(die_w_m, die_h_m) * 1e6
    max_grid = max(1, int(min_dim_um / MIN_CELL_UM))
    return min(max_grid, target_grid)


def build_power_grid(block, grid: int, total_power_w: float) -> tuple:
    """
    Return (power_grid_W, die_bounds_m) where power_grid_W is (grid, grid)
    in Watts and die_bounds_m is (x0, y0, width, height) in metres.

    Cell area (µm²) is accumulated per bin, then the whole grid is rescaled
    so it sums to total_power_w. A small uniform floor (POWER_FLOOR_FRAC of
    total) is added to every cell to prevent zero-power rows from making
    HotSpot's conductance matrix singular.
    """
    die = block.getDieArea()
    x0_dbu, y0_dbu = die.xMin(), die.yMin()
    x1_dbu, y1_dbu = die.xMax(), die.yMax()
    die_w_dbu = x1_dbu - x0_dbu
    die_h_dbu = y1_dbu - y0_dbu

    dbu_per_um = block.getDbUnitsPerMicron()

    area_grid = np.zeros((grid, grid), dtype=np.float64)

    for inst in block.getInsts():
        bbox = inst.getBBox()
        cx = (bbox.xMin() + bbox.xMax()) / 2
        cy = (bbox.yMin() + bbox.yMax()) / 2

        gx = int((cx - x0_dbu) / die_w_dbu * grid)
        gy = int((cy - y0_dbu) / die_h_dbu * grid)
        gx = min(max(gx, 0), grid - 1)
        gy = min(max(gy, 0), grid - 1)

        # Area in µm²
        w_um = (bbox.xMax() - bbox.xMin()) / dbu_per_um
        h_um = (bbox.yMax() - bbox.yMin()) / dbu_per_um
        area_grid[gy, gx] += w_um * h_um

    # Rescale so total power equals the user-supplied value
    total_area = area_grid.sum()
    if total_area > 0:
        power_grid = area_grid / total_area * total_power_w
    else:
        power_grid = np.ones((grid, grid), dtype=np.float64) * total_power_w / (grid * grid)

    # Add power floor: prevents zero-power cells from creating singular rows.
    # Floor = POWER_FLOOR_FRAC * total / N_cells so it's small relative to peaks.
    floor_per_cell = POWER_FLOOR_FRAC * total_power_w / (grid * grid)
    power_grid = np.maximum(power_grid, floor_per_cell)
    # Renormalize to keep total power constant
    power_grid = power_grid / power_grid.sum() * total_power_w

    # Die bounds in metres for HotSpot
    die_x0_m = _dbu_to_m(x0_dbu, dbu_per_um)
    die_y0_m = _dbu_to_m(y0_dbu, dbu_per_um)
    die_w_m  = _dbu_to_m(die_w_dbu, dbu_per_um)
    die_h_m  = _dbu_to_m(die_h_dbu, dbu_per_um)

    return power_grid, (die_x0_m, die_y0_m, die_w_m, die_h_m)


# ── Phase 2: write HotSpot input files ─────────────────────────────────────

def write_hotspot_inputs(power_grid: np.ndarray, die_bounds_m: tuple,
                         grid: int, work_dir: Path) -> tuple:
    """
    Write a .flp (floorplan) and .ptrace (power trace) for HotSpot.

    HotSpot .flp format (one block per line):
        name  width_m  height_m  x_left_m  y_bottom_m

    HotSpot .ptrace format:
        <tab-separated block names>   ← header
        <tab-separated power values>  ← steady-state row (Watts)

    We name blocks u{row}_{col} so we can recover the grid position
    when parsing the temperature output.
    """
    die_x0, die_y0, die_w, die_h = die_bounds_m
    cell_w = die_w / grid
    cell_h = die_h / grid

    names = [f"u{gy}_{gx}" for gy in range(grid) for gx in range(grid)]

    flp_path = work_dir / "design.flp"
    with open(flp_path, "w") as f:
        for gy in range(grid):
            for gx in range(grid):
                name  = f"u{gy}_{gx}"
                x_pos = die_x0 + gx * cell_w
                y_pos = die_y0 + gy * cell_h
                f.write(f"{name}\t{cell_w:.6e}\t{cell_h:.6e}"
                        f"\t{x_pos:.6e}\t{y_pos:.6e}\n")

    ptrace_path = work_dir / "design.ptrace"
    with open(ptrace_path, "w") as f:
        f.write("\t".join(names) + "\n")
        powers = [f"{power_grid[gy, gx]:.6e}"
                  for gy in range(grid) for gx in range(grid)]
        f.write("\t".join(powers) + "\n")

    return flp_path, ptrace_path


# ── Phase 3: run HotSpot ───────────────────────────────────────────────────

def run_hotspot(flp_path: Path, ptrace_path: Path, work_dir: Path) -> Path:
    """
    Run HotSpot steady-state block model. Returns path to .steady output.

    No -c config flag → HotSpot uses all built-in defaults (standard
    spreader/heatsink package, 45°C ambient). This is fine for relative
    comparisons between designs; absolute temperatures require a real
    package thermal model calibrated to the target chip.
    """
    steady_path = work_dir / "design.steady"
    cmd = [
        "hotspot",
        "-f", str(flp_path),
        "-p", str(ptrace_path),
        "-steady_file", str(steady_path),
        "-model_type", "block",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, cwd=str(work_dir))
    if result.returncode != 0:
        raise RuntimeError(
            f"HotSpot exited with code {result.returncode}:\n{result.stderr}"
        )
    return steady_path


# ── Phase 4: parse HotSpot output ──────────────────────────────────────────

def parse_steady(steady_path: Path, grid: int) -> np.ndarray:
    """
    Parse HotSpot .steady file into a (grid, grid) float32 array in °C.

    .steady format (one block per line):
        block_name  temperature_K
    """
    temp_map = np.zeros((grid, grid), dtype=np.float32)
    with open(steady_path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            if len(parts) != 2:
                continue
            name, temp_k = parts[0], float(parts[1])
            if not name.startswith("u"):
                continue  # skip package/spreader blocks HotSpot may add
            coords = name[1:]  # strip leading "u"
            gy, gx = map(int, coords.split("_", 1))
            temp_map[gy, gx] = temp_k - 273.15  # K → °C
    return temp_map


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    args = _parse_args()
    target_grid = args.grid

    tech = Tech()
    design = Design(tech)
    design.readDb(args.odb)
    block = design.getBlock()

    print(f"[thermal] Reading placement from {args.odb}")

    # Determine die size first — used for both power scaling and adaptive grid.
    die = block.getDieArea()
    dbu_per_um = block.getDbUnitsPerMicron()
    die_w_m = _dbu_to_m(die.xMax() - die.xMin(), dbu_per_um)
    die_h_m = _dbu_to_m(die.yMax() - die.yMin(), dbu_per_um)

    # Power scales with die area so power *density* is constant across designs.
    die_area_mm2 = die_w_m * die_h_m * 1e6
    total_power_w = args.power_density * die_area_mm2

    hs_grid = _adaptive_hotspot_grid(die_w_m, die_h_m, target_grid)

    if hs_grid < target_grid:
        print(f"[thermal] Die {die_w_m*1e3:.2f}×{die_h_m*1e3:.2f} mm is small — "
              f"using {hs_grid}×{hs_grid} HotSpot grid (min cell ≥{MIN_CELL_UM} µm), "
              f"upsampling to {target_grid}×{target_grid} for output")
    else:
        print(f"[thermal] Die: {die_w_m*1e3:.2f}×{die_h_m*1e3:.2f} mm  "
              f"({die_area_mm2:.4f} mm²)  Grid: {hs_grid}×{hs_grid}")

    power_grid, die_bounds_m = build_power_grid(block, hs_grid, total_power_w)
    print(f"[thermal] Total power: {power_grid.sum()*1e3:.1f} mW")

    with tempfile.TemporaryDirectory() as tmp:
        work_dir = Path(tmp)
        flp_path, ptrace_path = write_hotspot_inputs(
            power_grid, die_bounds_m, hs_grid, work_dir
        )
        print(f"[thermal] Running HotSpot ({hs_grid}×{hs_grid} = {hs_grid**2} blocks)...")
        steady_path = run_hotspot(flp_path, ptrace_path, work_dir)
        temp_map_hs = parse_steady(steady_path, hs_grid)

    # Upsample HotSpot output to target_grid if a coarser grid was used.
    if hs_grid < target_grid:
        from scipy.ndimage import zoom
        scale = target_grid / hs_grid
        temp_map = zoom(temp_map_hs, scale, order=1).astype(np.float32)
        # Also upsample power_grid so saved arrays are always (target_grid, target_grid)
        power_grid_out = zoom(power_grid.astype(np.float32), scale, order=1)
    else:
        temp_map = temp_map_hs
        power_grid_out = power_grid.astype(np.float32)

    print(f"[thermal] Temperature: min={temp_map.min():.1f}°C  "
          f"max={temp_map.max():.1f}°C  "
          f"peak-to-peak={temp_map.max()-temp_map.min():.1f}°C")

    np.savez(
        args.out,
        thermal_map=temp_map,
        power_grid=power_grid_out,
    )
    print(f"[thermal] Saved → {args.out}")


if __name__ == "__main__":
    main()
