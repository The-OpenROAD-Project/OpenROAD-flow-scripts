"""
Extract congestion labels from a GRT ODB file and/or GRT log.

Produces a .npz with three label arrays:
  heatmap  - float32 (10, grid, grid)  per-layer overflow fraction [0, 1]
  hotspot  - uint8   (grid, grid)       binary: 1 where any layer overflows
  score    - float32 scalar             mean overflow across all layers and cells

Run inside Docker via util/docker_shell:
  openroad -python extract_labels.py --odb <grt.odb> --out <path.npz> [--grid 64]
"""

import argparse

import numpy as np
import openroad as ord


LAYER_COUNT = 10  # metal1 – metal10


def _parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--odb", required=True, help="GRT stage ODB (5_1_grt.odb)")
    ap.add_argument("--out", required=True)
    ap.add_argument("--grid", type=int, default=64)
    ap.add_argument("--overflow-threshold", type=float, default=0.0,
                    help="Overflow fraction above which a cell is a hotspot")
    return ap.parse_args()


def extract_labels(odb_path: str, grid: int = 64,
                   overflow_threshold: float = 0.0) -> dict:
    db = ord.dbDatabase.create()
    ord.read_db(db, odb_path)
    chip = db.getChip()
    block = chip.getBlock()

    die = block.getDieArea()
    x0, y0 = die.xMin(), die.yMin()
    x1, y1 = die.xMax(), die.yMax()
    die_w = x1 - x0
    die_h = y1 - y0

    heatmap = np.zeros((LAYER_COUNT, grid, grid), dtype=np.float32)

    gcell_grid = block.getGCellGrid()
    if gcell_grid is None:
        raise RuntimeError("No GCell grid found — run GRT before extracting labels")

    # Build x/y GCell boundary arrays
    x_grid = []
    y_grid = []
    for layer in block.getTech().getLayers():
        if layer.getType() != "ROUTING":
            continue
    gcell_grid.getGridX(x_grid := [])
    gcell_grid.getGridY(y_grid := [])

    for layer_idx in range(LAYER_COUNT):
        # Layer objects are 1-indexed in OpenROAD tech
        layer_name = f"metal{layer_idx + 1}"
        tech = block.getTech()
        layer = tech.findLayer(layer_name)
        if layer is None:
            continue

        for gcell in gcell_grid.getGCells(layer):
            usage    = gcell.getUsage()
            capacity = gcell.getCapacity()
            if capacity == 0:
                continue
            overflow = max(0.0, (usage - capacity) / capacity)

            bbox = gcell.getBBox()
            cx = (bbox.xMin() + bbox.xMax()) / 2
            cy = (bbox.yMin() + bbox.yMax()) / 2

            gx = int((cx - x0) / die_w * grid)
            gy = int((cy - y0) / die_h * grid)
            gx = min(max(gx, 0), grid - 1)
            gy = min(max(gy, 0), grid - 1)

            heatmap[layer_idx, gy, gx] = max(
                heatmap[layer_idx, gy, gx], overflow
            )

    # Clip to [0, 1] — values > 1 mean capacity exceeded by more than 100%
    heatmap = np.clip(heatmap, 0.0, 1.0)

    hotspot = (heatmap.max(axis=0) > overflow_threshold).astype(np.uint8)
    score   = float(heatmap.mean())

    return {"heatmap": heatmap, "hotspot": hotspot, "score": np.float32(score)}


def main():
    args = _parse_args()
    labels = extract_labels(args.odb, args.grid, args.overflow_threshold)
    np.savez(args.out, **labels)

    h = labels["heatmap"]
    for i in range(LAYER_COUNT):
        print(f"  metal{i+1}: max={h[i].max():.4f} mean={h[i].mean():.4f}")
    print(f"  hotspot cells: {labels['hotspot'].sum()}/{args.grid**2}")
    print(f"  score: {labels['score']:.6f}")
    print(f"Saved -> {args.out}")


if __name__ == "__main__":
    main()
