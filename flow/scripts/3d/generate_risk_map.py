#!/usr/bin/env python3
"""
Generate per-pad risk heatmap CSV files from YAP W2W or D2W simulation output.

Reads the assembly_fail_map_per_interface_dict<tag>.npz, per-interface
bitmap_collection.npy, per-interface <interface><tag>.yaml configs, and the
.3dbx stack config to produce CSV heatmap files with format:
    <chiplet_path>,<connection_name>_<mechanism>
    x0,y0,x1,y1,value

value is the pad's failure rate in percent: the share of simulated stacks in
which it failed (YAP stores this as a 0-1 fraction).

<chiplet_path> is the chiplet's full hierarchical path as the web viewer names
it (e.g. top/Compute_Large_0_1), which web_load_chiplet_heatmap matches on.
Pad coordinates are in the chiplet's pre-transform local frame.

<tag> is empty for W2W. D2W appends __<config name>__<criticality profile>.

Usage:
    generate_risk_map.py --results_dir <results_dir> --objects_dir <objects_dir>
                         [--file_tag <tag>]
"""

import argparse
import glob
import os
import numpy as np
from omegaconf import OmegaConf


def find_stack_config(objects_dir: str) -> str:
    """Locate the single .3dbx stack config staged into objects_dir."""
    matches = sorted(glob.glob(os.path.join(objects_dir, "*.3dbx")))
    if not matches:
        raise FileNotFoundError(f"No .3dbx stack config found in {objects_dir}")
    if len(matches) > 1:
        raise RuntimeError(
            f"Expected one .3dbx in {objects_dir}, found: {', '.join(matches)}"
        )
    return matches[0]


def build_interface_mapping(dbx_path: str) -> dict:
    """
    Parse .3dbx to build a mapping from YAP interface name to
    (chiplet_path, connection_name).

    YAP derives the interface name as:
        INTERFACE_TOP = connection.bot  -> last dotted part -> strip 'To_' prefix
        INTERFACE_BOT = connection.top  -> last dotted part -> strip 'From_' prefix
        INTERFACE     = {INTERFACE_TOP}_From_{INTERFACE_BOT}

    The chiplet owning the pad coordinates is the one connection.top names.
    3Dblox writes that as <inst>[/<inst>...].regions.<region>, so the part
    before '.regions.' is already the '/'-delimited instance path below the
    root; prefixing the root (the .3dbx Design name) gives the full path the
    viewer keys chiplets on.
    """
    dbx = OmegaConf.load(dbx_path)
    root = str(dbx.Design.name)
    mapping = {}

    for conn_name, connection in dbx.Connection.items():
        itf_top = str(connection.bot.split(".")[-1]).split("To_")[-1]
        itf_bot = str(connection.top.split(".")[-1]).split("From_")[-1]
        interface_name = f"{itf_top}_From_{itf_bot}"
        inst_path = str(connection.top).split(".regions.")[0]
        mapping[interface_name] = (f"{root}/{inst_path}", conn_name)

    return mapping


def generate_risk_maps(results_dir: str, objects_dir: str, file_tag: str = ""):
    npz_path = os.path.join(
        results_dir, f"assembly_fail_map_per_interface_dict{file_tag}.npz"
    )
    if not os.path.exists(npz_path):
        raise FileNotFoundError(f"Fail map not found: {npz_path}")

    itf_mapping = build_interface_mapping(find_stack_config(objects_dir))
    fail_data = np.load(npz_path, allow_pickle=True)

    for itf_name in fail_data.keys():
        if itf_name not in itf_mapping:
            print(f"Skipping {itf_name}: no matching connection in .3dbx")
            continue

        chiplet_path, conn_name = itf_mapping[itf_name]

        bmp_path = os.path.join(
            results_dir, itf_name, f"{itf_name}_bitmap_collection.npy"
        )
        if not os.path.exists(bmp_path):
            print(f"Skipping {itf_name}: bitmap collection not found")
            continue

        itf_cfg_path = os.path.join(objects_dir, f"{itf_name}{file_tag}.yaml")
        if not os.path.exists(itf_cfg_path):
            print(f"Skipping {itf_name}: interface config not found at {itf_cfg_path}")
            continue

        itf_cfg = OmegaConf.load(itf_cfg_path)
        pad_r = float(itf_cfg.PAD_TOP_R_um)

        bmp = np.load(bmp_path, allow_pickle=True).item()
        bump_data = bmp["bump_data"]
        # Fail maps live on YAP's physical pad grid; this maps each cell to its
        # bump id, NaN where the grid has no pad.  The pad array need not be
        # square or full (e.g. a round footprint), so it must drive the walk.
        grid_to_bump = bmp["mapping_physical_to_bumpid"]
        n_rows, n_cols = grid_to_bump.shape

        fail_maps = fail_data[itf_name].item()

        for mechanism in fail_maps.keys():
            fail_prob = fail_maps[mechanism]

            heatmap_name = f"{conn_name}_{mechanism}"
            csv_path = os.path.join(
                results_dir, itf_name, f"{itf_name}_{mechanism}_risk.csv"
            )
            written = 0
            with open(csv_path, "w") as f:
                f.write(f"{chiplet_path},{heatmap_name}\n")
                for row in range(n_rows):
                    for col in range(n_cols):
                        if np.isnan(grid_to_bump[row, col]):
                            continue
                        bid = int(grid_to_bump[row, col])
                        x = bump_data[bid]["x"]
                        y = bump_data[bid]["y"]
                        fail_pct = fail_prob[row, col] * 100.0
                        x0 = x - pad_r
                        y0 = y - pad_r
                        x1 = x + pad_r
                        y1 = y + pad_r
                        f.write(f"{x0:.4f},{y0:.4f},{x1:.4f},{y1:.4f},{fail_pct:.4f}\n")
                        written += 1

            nonzero = int(np.count_nonzero(fail_prob))
            print(
                f"  {chiplet_path} {heatmap_name}: {csv_path} "
                f"({written} pads, {nonzero} nonzero)"
            )

        print(f"Done: {itf_name} -> {chiplet_path} ({conn_name})")


def main():
    parser = argparse.ArgumentParser(
        description="Generate risk heatmap CSVs from YAP W2W or D2W simulation output"
    )
    parser.add_argument(
        "--results_dir",
        required=True,
        help="Design results directory holding the YAP simulation output",
    )
    parser.add_argument(
        "--objects_dir",
        required=True,
        help="Objects directory holding the staged .3dbx and per-interface YAMLs",
    )
    parser.add_argument(
        "--file_tag",
        default="",
        help="Suffix YAP appended to its output names (empty for W2W)",
    )
    args = parser.parse_args()
    generate_risk_maps(args.results_dir, args.objects_dir, args.file_tag)


if __name__ == "__main__":
    main()
