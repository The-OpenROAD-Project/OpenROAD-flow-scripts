"""
Extract input features from an ODB file after detailed placement.

Produces a .npz with four 64x64 arrays:
  cell_density   - normalized cell area per grid cell
  macro_density  - fraction of cell area occupied by macros
  pin_density    - number of instance pins per grid cell (normalized)
  fanout_density - mean fanout of cells in each grid cell (normalized)

Run inside Docker via util/docker_shell:
  openroad -python extract_features.py --odb <path> --out <path.npz> [--grid 64]
"""

import argparse
import sys

import numpy as np
import openroad as ord
import utl


def _parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--odb", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--grid", type=int, default=64)
    return ap.parse_args()


def extract_features(odb_path: str, grid: int = 64) -> dict[str, np.ndarray]:
    db = ord.dbDatabase.create()
    ord.read_db(db, odb_path)
    chip = db.getChip()
    block = chip.getBlock()

    die = block.getDieArea()
    x0, y0 = die.xMin(), die.yMin()
    x1, y1 = die.xMax(), die.yMax()
    die_w = x1 - x0
    die_h = y1 - y0

    cell_density   = np.zeros((grid, grid), dtype=np.float32)
    macro_density  = np.zeros((grid, grid), dtype=np.float32)
    pin_density    = np.zeros((grid, grid), dtype=np.float32)
    fanout_sum     = np.zeros((grid, grid), dtype=np.float32)
    fanout_count   = np.zeros((grid, grid), dtype=np.float32)

    for inst in block.getInsts():
        bbox = inst.getBBox()
        cx = (bbox.xMin() + bbox.xMax()) / 2
        cy = (bbox.yMin() + bbox.yMax()) / 2

        gx = int((cx - x0) / die_w * grid)
        gy = int((cy - y0) / die_h * grid)
        gx = min(max(gx, 0), grid - 1)
        gy = min(max(gy, 0), grid - 1)

        cell_w = bbox.xMax() - bbox.xMin()
        cell_h = bbox.yMax() - bbox.yMin()
        area = cell_w * cell_h

        cell_density[gy, gx] += area
        master = inst.getMaster()
        if master.isBlock():
            macro_density[gy, gx] += area

        iterm_count = 0
        fanout = 0
        for iterm in inst.getITerms():
            iterm_count += 1
            net = iterm.getNet()
            if net is not None:
                fanout += net.getITermCount()
        pin_density[gy, gx] += iterm_count
        if iterm_count > 0:
            fanout_sum[gy, gx] += fanout / iterm_count
            fanout_count[gy, gx] += 1

    cell_area = die_w / grid * die_h / grid
    cell_density  /= (cell_area + 1e-9)
    macro_density /= (cell_area + 1e-9)

    max_pins = pin_density.max()
    if max_pins > 0:
        pin_density /= max_pins

    fanout_density = np.where(fanout_count > 0, fanout_sum / fanout_count, 0.0)
    max_fo = fanout_density.max()
    if max_fo > 0:
        fanout_density /= max_fo

    return {
        "cell_density":  cell_density,
        "macro_density": macro_density,
        "pin_density":   pin_density,
        "fanout_density": fanout_density,
    }


def main():
    args = _parse_args()
    features = extract_features(args.odb, args.grid)
    np.savez(args.out, **features)
    for k, v in features.items():
        print(f"  {k}: min={v.min():.4f} mean={v.mean():.4f} max={v.max():.4f}")
    print(f"Saved -> {args.out}")


if __name__ == "__main__":
    main()
