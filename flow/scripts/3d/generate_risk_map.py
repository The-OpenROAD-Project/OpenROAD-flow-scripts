#!/usr/bin/env python3
"""
Generate per-pad risk heatmap CSV files from YAP W2W simulation output.

Reads the assembly_fail_map_per_interface_dict.npz, per-interface
bitmap_collection.npy, per-interface YAML configs, and the .3dbx stack
config to produce CSV heatmap files with format:
    <chiplet_instance>,<connection_name>_<mechanism>
    x0,y0,x1,y1,value

Pad coordinates are in the chiplet's pre-transform local frame.

Usage:
    generate_risk_map.py --results_dir <results_dir> --objects_dir <objects_dir>
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
    (chiplet_instance, connection_name).

    YAP derives the interface name as:
        INTERFACE_TOP = connection.bot  -> last dotted part -> strip 'To_' prefix
        INTERFACE_BOT = connection.top  -> last dotted part -> strip 'From_' prefix
        INTERFACE     = {INTERFACE_TOP}_From_{INTERFACE_BOT}

    The chiplet instance owning the pad coordinates is extracted from
    connection.top (the first dotted part).
    """
    dbx = OmegaConf.load(dbx_path)
    mapping = {}

    for conn_name, connection in dbx.Connection.items():
        itf_top = str(connection.bot.split(".")[-1]).split("To_")[-1]
        itf_bot = str(connection.top.split(".")[-1]).split("From_")[-1]
        interface_name = f"{itf_top}_From_{itf_bot}"
        chiplet_instance = connection.top.split(".")[0]
        mapping[interface_name] = (chiplet_instance, conn_name)

    return mapping


def generate_risk_maps(results_dir: str, objects_dir: str):
    npz_path = os.path.join(results_dir, "assembly_fail_map_per_interface_dict.npz")
    if not os.path.exists(npz_path):
        raise FileNotFoundError(f"Fail map not found: {npz_path}")

    itf_mapping = build_interface_mapping(find_stack_config(objects_dir))
    fail_data = np.load(npz_path, allow_pickle=True)

    for itf_name in fail_data.keys():
        if itf_name not in itf_mapping:
            print(f"Skipping {itf_name}: no matching connection in .3dbx")
            continue

        chiplet_inst, conn_name = itf_mapping[itf_name]

        bmp_path = os.path.join(
            results_dir, itf_name, f"{itf_name}_bitmap_collection.npy"
        )
        if not os.path.exists(bmp_path):
            print(f"Skipping {itf_name}: bitmap collection not found")
            continue

        itf_cfg_path = os.path.join(objects_dir, f"{itf_name}.yaml")
        if not os.path.exists(itf_cfg_path):
            print(f"Skipping {itf_name}: interface config not found at {itf_cfg_path}")
            continue

        itf_cfg = OmegaConf.load(itf_cfg_path)
        pad_r = float(itf_cfg.PAD_TOP_R_um)

        bmp = np.load(bmp_path, allow_pickle=True).item()
        bump_data = bmp["bump_data"]
        n_pads = len(bump_data)
        pad_arr_side = int(np.sqrt(n_pads))

        fail_maps = fail_data[itf_name].item()

        for mechanism in fail_maps.keys():
            fail_prob = fail_maps[mechanism]

            heatmap_name = f"{conn_name}_{mechanism}"
            csv_path = os.path.join(
                results_dir, itf_name, f"{itf_name}_{mechanism}_risk.csv"
            )
            written = 0
            with open(csv_path, "w") as f:
                f.write(f"{chiplet_inst},{heatmap_name}\n")
                for row in range(pad_arr_side):
                    for col in range(pad_arr_side):
                        bid = row * pad_arr_side + col
                        if bid >= n_pads:
                            continue
                        x = bump_data[bid]["x"]
                        y = bump_data[bid]["y"]
                        prob = fail_prob[row, col]
                        x0 = x - pad_r
                        y0 = y - pad_r
                        x1 = x + pad_r
                        y1 = y + pad_r
                        f.write(f"{x0:.4f},{y0:.4f},{x1:.4f},{y1:.4f},{prob:.6f}\n")
                        written += 1

            nonzero = int(np.count_nonzero(fail_prob))
            print(
                f"  {chiplet_inst} {heatmap_name}: {csv_path} "
                f"({written} pads, {nonzero} nonzero)"
            )

        print(f"Done: {itf_name} -> {chiplet_inst} ({conn_name})")


def main():
    parser = argparse.ArgumentParser(
        description="Generate risk heatmap CSVs from YAP W2W simulation output"
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
    args = parser.parse_args()
    generate_risk_maps(args.results_dir, args.objects_dir)


if __name__ == "__main__":
    main()
