#!/usr/bin/env python3
"""Platform configuration for nangate45.

Generates the same variable assignments as config.mk.
Called by Make via $(shell) or by bazel-orfs for JSON output.

Usage:
  python config.py              # Make-compatible output
  python config.py --format=json  # JSON dict for bazel-orfs
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
from platform_config_utils import PlatformConfig


def get_config(platform_dir=None):
    cfg = PlatformConfig(platform_dir)
    pd = cfg.platform_dir

    # Process node
    cfg.set("PROCESS", "45")

    # Tech/Libs
    cfg.set("TECH_LEF", f"{pd}/lef/NangateOpenCellLibrary.tech.lef")
    cfg.set("SC_LEF", f"{pd}/lef/NangateOpenCellLibrary.macro.mod.lef")

    lib_files = f"{pd}/lib/NangateOpenCellLibrary_typical.lib"
    additional_libs = cfg.env("ADDITIONAL_LIBS")
    if additional_libs:
        lib_files += f" {additional_libs}"
    cfg.set("LIB_FILES", lib_files)

    gds = cfg.sorted_glob(f"{pd}/gds/*.gds")
    additional_gds = cfg.env("ADDITIONAL_GDS")
    if additional_gds:
        gds += f" {additional_gds}"
    cfg.set("GDS_FILES", gds)

    cfg.set("DONT_USE_CELLS", "TAPCELL_X1 FILLCELL_X1 AOI211_X1 OAI211_X1")

    # Fill cells
    cfg.set(
        "FILL_CELLS",
        "FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32",
        conditional=True,
    )

    # Yosys
    cfg.set("SYNTH_MINIMUM_KEEP_SIZE", "10000", conditional=True)
    cfg.set("TIEHI_CELL_AND_PORT", "LOGIC1_X1 Z")
    cfg.set("TIELO_CELL_AND_PORT", "LOGIC0_X1 Z")
    cfg.set("MIN_BUF_CELL_AND_PORTS", "BUF_X1 A Z")

    # Yosys mapping files
    cfg.set("LATCH_MAP_FILE", f"{pd}/cells_latch.v")
    cfg.set("CLKGATE_MAP_FILE", f"{pd}/cells_clkgate.v")
    cfg.set("ADDER_MAP_FILE", f"{pd}/cells_adders.v", conditional=True)

    cfg.set("ABC_DRIVER_CELL", "BUF_X1")
    cfg.set("ABC_LOAD_IN_FF", "3.898")

    # Floorplan
    cfg.set("PLACE_SITE", "FreePDK45_38x28_10R_NP_162NW_34O")
    cfg.set("IO_PLACER_H", "metal5", conditional=True)
    cfg.set("IO_PLACER_V", "metal6", conditional=True)
    cfg.set("PDN_TCL", f"{pd}/grid_strategy-M1-M4-M7.tcl", conditional=True)
    cfg.set("TAPCELL_TCL", f"{pd}/tapcell.tcl", conditional=True)
    cfg.set("TAP_CELL_NAME", "TAPCELL_X1")
    cfg.set("MACRO_PLACE_HALO", "22.4 15.12", conditional=True)

    # Place
    cfg.set("PLACE_DENSITY", "0.30", conditional=True)

    # Route
    cfg.set("MIN_ROUTING_LAYER", "metal2")
    cfg.set("MIN_CLK_ROUTING_LAYER", "metal4")
    cfg.set("MAX_ROUTING_LAYER", "metal10")
    cfg.set("FASTROUTE_TCL", f"{pd}/fastroute.tcl", conditional=True)

    # KLayout
    cfg.set("KLAYOUT_TECH_FILE", f"{pd}/FreePDK45.lyt")
    cfg.set("KLAYOUT_DRC_FILE", f"{pd}/drc/FreePDK45.lydrc")
    cfg.set("KLAYOUT_LVS_FILE", f"{pd}/lvs/FreePDK45.lylvs")

    # Allow empty GDS cell
    cfg.set("GDS_ALLOW_EMPTY", "fakeram.*", conditional=True)

    cfg.set("CDL_FILE", f"{pd}/cdl/NangateOpenCellLibrary.cdl")
    cfg.set("TEMPLATE_PGA_CFG", f"{pd}/template_pga.cfg", conditional=True)

    # OpenRCX
    cfg.set("RCX_RULES", f"{pd}/rcx_patterns.rules")

    # IR Drop
    cfg.set("PWR_NETS_VOLTAGES", "VDD 1.1", conditional=True)
    cfg.set("GND_NETS_VOLTAGES", "VSS 0.0", conditional=True)
    cfg.set("IR_DROP_LAYER", "metal1", conditional=True)

    return cfg


if __name__ == "__main__":
    get_config().output()
