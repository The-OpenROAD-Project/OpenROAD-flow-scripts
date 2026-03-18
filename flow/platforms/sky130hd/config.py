#!/usr/bin/env python3
"""Platform configuration for sky130hd.

Generates the same variable assignments as config.mk.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
from platform_config_utils import PlatformConfig


def get_config(platform_dir=None):
    cfg = PlatformConfig(platform_dir)
    pd = cfg.platform_dir
    platform = cfg.env("PLATFORM", "sky130hd")

    # Process node
    cfg.set("PROCESS", "130")

    # Tech/Libs
    cfg.set("TECH_LEF", f"{pd}/lef/sky130_fd_sc_hd.tlef")
    cfg.set("SC_LEF", f"{pd}/lef/sky130_fd_sc_hd_merged.lef")

    lib_files = f"{pd}/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
    additional_libs = cfg.env("ADDITIONAL_LIBS")
    if additional_libs:
        lib_files += f" {additional_libs}"
    cfg.set("LIB_FILES", lib_files)

    gds = cfg.wildcard_glob(f"{pd}/gds/*.gds")
    additional_gds = cfg.env("ADDITIONAL_GDS")
    if additional_gds:
        gds += f" {additional_gds}"
    cfg.set("GDS_FILES", gds)

    # Dont use cells
    cfg.append(
        "DONT_USE_CELLS",
        "sky130_fd_sc_hd__probe_p_8 sky130_fd_sc_hd__probec_p_8 "
        "sky130_fd_sc_hd__lpflow_bleeder_1 "
        "sky130_fd_sc_hd__lpflow_clkbufkapwr_1 "
        "sky130_fd_sc_hd__lpflow_clkbufkapwr_16 "
        "sky130_fd_sc_hd__lpflow_clkbufkapwr_2 "
        "sky130_fd_sc_hd__lpflow_clkbufkapwr_4 "
        "sky130_fd_sc_hd__lpflow_clkbufkapwr_8 "
        "sky130_fd_sc_hd__lpflow_clkinvkapwr_1 "
        "sky130_fd_sc_hd__lpflow_clkinvkapwr_16 "
        "sky130_fd_sc_hd__lpflow_clkinvkapwr_2 "
        "sky130_fd_sc_hd__lpflow_clkinvkapwr_4 "
        "sky130_fd_sc_hd__lpflow_clkinvkapwr_8 "
        "sky130_fd_sc_hd__lpflow_decapkapwr_12 "
        "sky130_fd_sc_hd__lpflow_decapkapwr_3 "
        "sky130_fd_sc_hd__lpflow_decapkapwr_4 "
        "sky130_fd_sc_hd__lpflow_decapkapwr_6 "
        "sky130_fd_sc_hd__lpflow_decapkapwr_8 "
        "sky130_fd_sc_hd__lpflow_inputiso0n_1 "
        "sky130_fd_sc_hd__lpflow_inputiso0p_1 "
        "sky130_fd_sc_hd__lpflow_inputiso1n_1 "
        "sky130_fd_sc_hd__lpflow_inputiso1p_1 "
        "sky130_fd_sc_hd__lpflow_inputisolatch_1 "
        "sky130_fd_sc_hd__lpflow_isobufsrc_1 "
        "sky130_fd_sc_hd__lpflow_isobufsrc_16 "
        "sky130_fd_sc_hd__lpflow_isobufsrc_2 "
        "sky130_fd_sc_hd__lpflow_isobufsrc_4 "
        "sky130_fd_sc_hd__lpflow_isobufsrc_8 "
        "sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 "
        "sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4",
    )

    # Fill cells
    cfg.set(
        "FILL_CELLS",
        "sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8",
        conditional=True,
    )

    # Yosys
    cfg.set("TIEHI_CELL_AND_PORT", "sky130_fd_sc_hd__conb_1 HI")
    cfg.set("TIELO_CELL_AND_PORT", "sky130_fd_sc_hd__conb_1 LO")
    cfg.set("MIN_BUF_CELL_AND_PORTS", "sky130_fd_sc_hd__buf_4 A X")

    # Yosys mapping files
    cfg.set("LATCH_MAP_FILE", f"{pd}/cells_latch_hd.v")
    cfg.set("CLKGATE_MAP_FILE", f"{pd}/cells_clkgate_hd.v")
    cfg.set("ADDER_MAP_FILE", f"{pd}/cells_adders_hd.v", conditional=True)

    cfg.set("ABC_DRIVER_CELL", "sky130_fd_sc_hd__buf_1")
    cfg.set("ABC_LOAD_IN_FF", "5")

    # Sizing
    cfg.set("MATCH_CELL_FOOTPRINT", "1")

    # Floorplan
    cfg.set("PLACE_SITE", "unithd")
    cfg.set("IO_PLACER_H", "met3", conditional=True)
    cfg.set("IO_PLACER_V", "met2", conditional=True)
    cfg.set("PDN_TCL", f"{pd}/pdn.tcl", conditional=True)
    cfg.set("TAP_CELL_NAME", "sky130_fd_sc_hd__tapvpwrvgnd_1")
    cfg.set("TAPCELL_TCL", f"{pd}/tapcell.tcl", conditional=True)
    cfg.set("MACRO_PLACE_HALO", "40 40", conditional=True)

    # Place
    cfg.set("PLACE_DENSITY", "0.60", conditional=True)

    # Route
    cfg.set("MIN_ROUTING_LAYER", "met1", conditional=True)
    cfg.set("MIN_CLK_ROUTING_LAYER", "met3", conditional=True)
    cfg.set("MAX_ROUTING_LAYER", "met5", conditional=True)
    cfg.set("FASTROUTE_TCL", f"{pd}/fastroute.tcl", conditional=True)

    # KLayout
    cfg.set("KLAYOUT_TECH_FILE", f"{pd}/{platform}.lyt")
    cfg.set("FILL_CONFIG", f"{pd}/fill.json")
    cfg.set("TEMPLATE_PGA_CFG", f"{pd}/template_pga.cfg", conditional=True)

    # OpenRCX
    cfg.set("RCX_RULES", f"{pd}/rcx_patterns.rules")

    # IR Drop
    cfg.set("PWR_NETS_VOLTAGES", "VDD 1.8", conditional=True)
    cfg.set("GND_NETS_VOLTAGES", "VSS 0.0", conditional=True)
    cfg.set("IR_DROP_LAYER", "met1", conditional=True)

    # DRC/LVS
    cfg.set("KLAYOUT_DRC_FILE", f"{pd}/drc/{platform}.lydrc")
    cfg.set("CDL_FILE", f"{pd}/cdl/{platform}.cdl")
    cfg.set("KLAYOUT_LVS_FILE", f"{pd}/lvs/{platform}.lylvs")
    cfg.set("REMOVE_CELLS_FOR_LEC", "sky130_fd_sc_hd__tapvpwrvgnd*")

    return cfg


if __name__ == "__main__":
    get_config().output()
