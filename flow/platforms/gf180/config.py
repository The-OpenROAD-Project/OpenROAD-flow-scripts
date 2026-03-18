#!/usr/bin/env python3
"""Platform configuration for gf180.

Generates the same variable assignments as config.mk.
Parameterized by TRACK_OPTION, METAL_OPTION, KVALUE, POWER_OPTION, CORNER.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
from platform_config_utils import PlatformConfig


def get_config(platform_dir=None):
    cfg = PlatformConfig(platform_dir)
    pd = cfg.platform_dir

    # Parameterized options
    track = cfg.env("TRACK_OPTION", "9t")
    metal = cfg.env("METAL_OPTION", "5LM_1TM")
    kvalue = cfg.env("KVALUE", "9")
    power = cfg.env("POWER_OPTION", "5v0")
    corner = cfg.env("CORNER", "BC")

    cfg.set("TRACK_OPTION", track, conditional=True)
    cfg.set("METAL_OPTION", metal, conditional=True)
    cfg.set("KVALUE", kvalue, conditional=True)
    cfg.set("POWER_OPTION", power, conditional=True)
    cfg.set("CORNER", corner, conditional=True)
    cfg.set("PROCESS", "180")

    # Tech/Libs
    cfg.set("TECH_LEF", f"{pd}/lef/gf180mcu_{metal}_{kvalue}K_{track}_tech.lef")
    cfg.set(
        "SC_LEF",
        f"{pd}/lef/gf180mcu_{metal}_{kvalue}K_{track}_sc.lef",
        conditional=True,
    )

    gds = cfg.wildcard_glob(f"{pd}/gds/{track}/*.gds")
    additional_gds = cfg.env("ADDITIONAL_GDS")
    if additional_gds:
        gds += f" {additional_gds}"
    cfg.set("GDS_FILES", gds)

    cfg.set("DONT_USE_CELLS", "*_1")

    # Fill cells
    sc = f"gf180mcu_fd_sc_mcu{track}{power}"
    cfg.set(
        "FILL_CELLS",
        f"{sc}__fill_64 {sc}__fill_32 {sc}__fill_16 {sc}__fill_8 {sc}__fill_4 {sc}__fill_2 {sc}__fill_1",
        conditional=True,
    )

    cfg.set("TIE_CELL", f"{sc}__filltie")
    cfg.set("ENDCAP_CELL", f"{sc}__endcap")
    cfg.set("RC_FILE", f"{pd}/setRC.tcl")

    # Yosys
    cfg.set("TIEHI_CELL_AND_PORT", f"{sc}__tieh Z")
    cfg.set("TIELO_CELL_AND_PORT", f"{sc}__tiel ZN")
    cfg.set("ABC_DRIVER_CELL", f"{sc}__buf_4")
    cfg.set("ABC_LOAD_IN_FF", "0.01343")
    cfg.set("MIN_BUF_CELL_AND_PORTS", f"{sc}__dlya_4 I Z")
    cfg.set("MAX_FANOUT", "20")

    # Yosys mapping files
    cfg.set("LATCH_MAP_FILE", f"{pd}/cells_latch.v", conditional=True)
    cfg.set("ADDER_MAP_FILE", f"{pd}/cells_adders.v", conditional=True)

    # Floorplan
    if track == "9t":
        cfg.set("PLACE_SITE", "GF018hv5v_green_sc9", conditional=True)
    else:
        cfg.set("PLACE_SITE", "GF018hv5v_mcu_sc7", conditional=True)

    cfg.set("IO_PLACER_H", "Metal3", conditional=True)
    cfg.set("IO_PLACER_V", "Metal4", conditional=True)
    cfg.set(
        "PDN_TCL",
        f"{pd}/openROAD/pdn/pdn_grid_strategy_{track}_6M.cfg",
        conditional=True,
    )
    cfg.set("TAPCELL_TCL", f"{pd}/openROAD/tapcell.tcl", conditional=True)
    cfg.set("MACRO_PLACE_HALO", "10 10", conditional=True)

    # Place
    cfg.set("PLACE_DENSITY", "0.40", conditional=True)

    # Route
    cfg.set("MIN_ROUTING_LAYER", "Metal2", conditional=True)
    cfg.set("MAX_ROUTING_LAYER", "Metal5", conditional=True)
    cfg.set("DISABLE_VIA_GEN", "1", conditional=True)
    cfg.set("FASTROUTE_TCL", f"{pd}/fastroute.tcl", conditional=True)

    # KLayout
    cfg.set("KLAYOUT_TECH_FILE", f"{pd}/KLayout/gf180mcu_{metal}_{kvalue}K_{track}.lyt")
    cfg.set("KLAYOUT_LEF_FILE", f"{pd}/KLayout/tech_{track}_{metal}.lef")
    cfg.set(
        "GDS_LAYER_MAP",
        os.path.abspath(
            f"{pd}/gds/{track}/gf180mcu_{metal}_{kvalue}K_{track}_edi2gds.layermap"
        ),
    )

    # RCX - corner-dependent
    cfg.set(
        "BC_RCX_RULES", f"{pd}/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_bst.rules"
    )
    cfg.set(
        "WC_RCX_RULES", f"{pd}/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_wst.rules"
    )
    cfg.set(
        "TC_RCX_RULES", f"{pd}/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_typ.rules"
    )

    cfg.set("BC_RCX_RC_CORNER", "FuncRCmin")
    cfg.set("WC_RCX_RC_CORNER", "FuncRCmax")
    cfg.set("TC_RCX_RC_CORNER", "FuncRCtyp")

    # Variable indirection for RCX
    rcx_rules = {
        "BC": cfg.get("BC_RCX_RULES"),
        "WC": cfg.get("WC_RCX_RULES"),
        "TC": cfg.get("TC_RCX_RULES"),
    }
    rcx_corners = {"BC": "FuncRCmin", "WC": "FuncRCmax", "TC": "FuncRCtyp"}
    cfg.set("RCX_RULES", rcx_rules.get(corner, rcx_rules["BC"]))
    cfg.set("RCX_RC_CORNER", rcx_corners.get(corner, rcx_corners["BC"]))

    # Corner-dependent libraries
    bc_lib = os.path.abspath(
        f"{pd}/lib/gf180mcu_fd_sc_mcu{track}{power}__ff_n40C_5v50.lib.gz"
    )
    wc_lib = os.path.abspath(
        f"{pd}/lib/gf180mcu_fd_sc_mcu{track}{power}__ss_125C_4v50.lib.gz"
    )
    tc_lib = os.path.abspath(
        f"{pd}/lib/gf180mcu_fd_sc_mcu{track}{power}__tt_025C_5v00.lib.gz"
    )

    cfg.set("BC_LIB_FILES", bc_lib)
    cfg.set("BC_TEMPERATURE", "-40c")
    cfg.set("BC_VOLTAGE", "5.5")

    cfg.set("WC_LIB_FILES", wc_lib)
    cfg.set("WC_TEMPERATURE", "125c")
    cfg.set("WC_VOLTAGE", "4.5")

    cfg.set("TC_LIB_FILES", tc_lib)
    cfg.set("TC_TEMPERATURE", "25c")
    cfg.set("TC_VOLTAGE", "5.0")

    # Variable indirection for corner selection
    corner_libs = {"BC": bc_lib, "WC": wc_lib, "TC": tc_lib}
    corner_temps = {"BC": "-40c", "WC": "125c", "TC": "25c"}
    corner_volts = {"BC": "5.5", "WC": "4.5", "TC": "5.0"}

    lib_files = corner_libs.get(corner, corner_libs["BC"])
    additional_libs = cfg.env("ADDITIONAL_LIBS")
    if additional_libs:
        lib_files += f" {additional_libs}"
    cfg.set("TEMPERATURE", corner_temps.get(corner, corner_temps["BC"]))
    cfg.set("VOLTAGE", corner_volts.get(corner, corner_volts["BC"]))
    cfg.set("LIB_FILES", lib_files)

    # IR Drop
    voltage = corner_volts.get(corner, corner_volts["BC"])
    cfg.set("PWR_NETS_VOLTAGES", f"VDD {voltage}", conditional=True)
    cfg.set("GND_NETS_VOLTAGES", "VSS 0.0", conditional=True)
    cfg.set("IR_DROP_LAYER", "Metal1", conditional=True)

    # Private dir (skipped: -include private.mk is for vendor-specific additions)
    cfg.set("GF180_PRIVATE_DIR", "../../gf180-private", conditional=True)

    return cfg


if __name__ == "__main__":
    get_config().output()
