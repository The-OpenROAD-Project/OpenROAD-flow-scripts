#!/usr/bin/env python3
"""
Visualize YAP yield results for a given design.
Re-runs the calculator and saves per-interface pad yield maps + wafer-level views.
"""

import os
import sys
import time
import argparse
import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from utils.util import *
from assembly_yield_calculator import Assembly_Yield_Calculator
from wafer_die_stack_initialization import WaferStack
from overlay_yield_calculator import stack_overlay_yield_calculator
from defect_yield_calculator import stack_defect_yield_calculator
from Cu_expansion_yield_calculator import stack_stress_yield_calculator
from esd_yield_calculator import stack_esd_yield_calculator


def parse_args():
    p = argparse.ArgumentParser(description="Visualize YAP yield results")
    p.add_argument("--config", "-c", required=True)
    p.add_argument("--mode", "-m", default="w2w_modeling")
    p.add_argument("--ds_name", "-d", required=True)
    p.add_argument("--ds_dir", required=True)
    return p.parse_args()


def main():
    args = parse_args()
    input_ds_dir = args.ds_dir
    _3dbv_path = input_ds_dir + "/generated_chiplet_definitions.3dbv"
    _3dbx_path = input_ds_dir + "/generated_stack_config.3dbx"
    cfg_skeleton = OmegaConf.load(args.config)[args.mode]

    cfg_dict = get_config_dict(
        cfg_folder=os.path.dirname(os.path.abspath(args.config)),
        cfg_skeleton=cfg_skeleton,
        ds_name=args.ds_name,
        input_ds_dir=input_ds_dir,
        _3dbv_path=_3dbv_path,
        _3dbx_path=_3dbx_path,
        mode=args.mode,
        debug=False,
    )

    for cfg in cfg_dict.values():
        cfg.plot_flag = False
        cfg.verbose = True
        output_path = os.path.join(cfg.OUTPUT_DIR, args.ds_name, cfg.INTERFACE)
        os.makedirs(output_path, exist_ok=True)

    # Build pad bitmap collections
    pad_bitmap_collection_dict = {}
    for interface, cfg in cfg_dict.items():
        bmap_path = os.path.join(input_ds_dir, f"{cfg.INTERFACE}.bmap")
        crit_path = os.path.join(input_ds_dir, f"{cfg.INTERFACE}_criticality.txt")
        pad_bitmap_collection_dict[interface] = convert_3dblox_to_pad_bitmap(
            cfg=cfg,
            _bmap_path=bmap_path,
            criticality_path=crit_path,
            pad_arrange_pattern=cfg.PAD_ARRANGE_PATTERN,
        )

    # Initialize wafer stack and run all calculators
    print("Initializing wafer stack...")
    waf_stack = WaferStack(
        cfg_dict=cfg_dict,
        pad_bitmap_collection_dict=pad_bitmap_collection_dict,
        mode=args.mode,
    )

    print("Calculating overlay yield...")
    stack_overlay_yield_calculator(cfg_dict=cfg_dict, waf_stack=waf_stack)

    print("Calculating defect yield...")
    stack_defect_yield_calculator(cfg_dict=cfg_dict, waf_stack=waf_stack)

    print("Calculating Cu expansion yield...")
    stack_stress_yield_calculator(cfg_dict=cfg_dict, waf_stack=waf_stack)

    print("Calculating ESD yield...")
    stack_esd_yield_calculator(
        cfg_dict=cfg_dict,
        waf_stack=waf_stack,
        pad_bitmap_collection_dict=pad_bitmap_collection_dict,
    )

    die_stack_yield, die_stack_yield_list = waf_stack.get_die_stack_yield()
    print(f"\nOverall die stack yield: {die_stack_yield:.4%}")

    out_base = os.path.join("output", args.ds_name, "visualizations")
    os.makedirs(out_base, exist_ok=True)

    # --- Plot 1: Per-interface per-mechanism yield histograms ---
    mechanisms = ["overlay", "particle", "mechanical", "ESD", "overall"]
    n_interfaces = len(cfg_dict)
    fig, axes = plt.subplots(
        n_interfaces,
        len(mechanisms),
        figsize=(4 * len(mechanisms), 3.5 * n_interfaces),
        squeeze=False,
    )
    fig.suptitle(
        f"Design: {args.ds_name} — Per-Die Yield Distributions (Stack Yield = {die_stack_yield:.4%})",
        fontsize=14,
        y=1.02,
    )

    for row, (itf_name, _) in enumerate(cfg_dict.items()):
        for col, mech in enumerate(mechanisms):
            ax = axes[row, col]
            data = waf_stack.die_yield_list_per_interface_dict[itf_name][mech]
            data = np.asarray(data, dtype=float).ravel()
            valid = data[~np.isnan(data)]
            if len(valid) > 0:
                ax.hist(
                    valid, bins=50, color="steelblue", edgecolor="white", linewidth=0.3
                )
                ax.axvline(
                    np.mean(valid),
                    color="red",
                    linestyle="--",
                    linewidth=1,
                    label=f"mean={np.mean(valid):.4f}",
                )
                ax.legend(fontsize=7)
            ax.set_xlim(0, 1.05)
            if row == 0:
                ax.set_title(mech, fontsize=11)
            if col == 0:
                short_name = (
                    itf_name.replace("Memory_DRAM_", "DRAM")
                    .replace("_From_", "\nfrom ")
                    .replace("TSV_Interconnect_Die", "TSV")
                )
                ax.set_ylabel(short_name, fontsize=9)
            ax.tick_params(labelsize=7)

    plt.tight_layout()
    hist_path = os.path.join(out_base, "yield_histograms.png")
    fig.savefig(hist_path, dpi=150, bbox_inches="tight")
    print(f"Saved: {hist_path}")
    plt.close(fig)

    # --- Plot 2: Per-interface wafer yield map (spatial) ---
    for itf_name, waf_itf in waf_stack.interfaces.interface_dict.items():
        for mech in ["Y_ovl", "Y_ce", "Y_esd"]:
            try:
                figpath = os.path.join(out_base, f"{itf_name}_{mech}_wafer.png")
                waf_itf.draw_wafer_die(
                    fig_size=(12, 12), draw_pad_yield_map_option=mech
                )
                plt.savefig(figpath, dpi=150, bbox_inches="tight")
                print(f"Saved: {figpath}")
                plt.close("all")
            except Exception as e:
                print(f"  Skipping {itf_name}/{mech}: {e}")

    # --- Plot 3: Die stack yield across wafer position ---
    fig, ax = plt.subplots(figsize=(10, 4))
    ax.plot(die_stack_yield_list, ".", markersize=1, alpha=0.5)
    ax.set_xlabel("Die index")
    ax.set_ylabel("Stack yield")
    ax.set_title(
        f"Design {args.ds_name}: Per-Die Stack Yield (mean={die_stack_yield:.4%})"
    )
    ax.set_ylim(0, 1.05)
    ax.axhline(die_stack_yield, color="red", linestyle="--", linewidth=1)
    plt.tight_layout()
    scatter_path = os.path.join(out_base, "die_stack_yield_scatter.png")
    fig.savefig(scatter_path, dpi=150)
    print(f"Saved: {scatter_path}")
    plt.close(fig)

    # --- Plot 4: Summary bar chart ---
    fig, ax = plt.subplots(figsize=(10, 5))
    x_labels = []
    bar_data = {m: [] for m in mechanisms}
    for itf_name in cfg_dict:
        short = (
            itf_name.replace("Memory_DRAM_", "DRAM")
            .replace("_From_", "\nfrom ")
            .replace("TSV_Interconnect_Die", "TSV")
        )
        x_labels.append(short)
        for mech in mechanisms:
            data = np.asarray(
                waf_stack.die_yield_list_per_interface_dict[itf_name][mech], dtype=float
            ).ravel()
            bar_data[mech].append(np.nanmean(data))

    x = np.arange(len(x_labels))
    width = 0.15
    colors = ["#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974"]
    for i, mech in enumerate(mechanisms):
        ax.bar(x + i * width, bar_data[mech], width, label=mech, color=colors[i])

    ax.set_xticks(x + width * 2)
    ax.set_xticklabels(x_labels, fontsize=8)
    ax.set_ylabel("Mean yield")
    ax.set_ylim(0, 1.05)
    ax.set_title(f"Design {args.ds_name}: Mean Yield by Interface & Mechanism")
    ax.legend()
    plt.tight_layout()
    bar_path = os.path.join(out_base, "yield_summary_bar.png")
    fig.savefig(bar_path, dpi=150)
    print(f"Saved: {bar_path}")
    plt.close(fig)

    print(f"\nAll visualizations saved to: {out_base}/")


if __name__ == "__main__":
    main()
