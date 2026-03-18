#!/usr/bin/env python3
"""Platform configuration for ihp-sg13g2.

Generates the same variable assignments as config.mk.
"""

import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
from platform_config_utils import PlatformConfig


def get_config(platform_dir=None):
    cfg = PlatformConfig(platform_dir)
    pd = cfg.platform_dir

    # Process node
    cfg.set("PROCESS", "ihp-sg13g2")

    # Tech/Libs - conditional IO files when FOOTPRINT_TCL is set
    cfg.set("LOAD_ADDITIONAL_FILES", "1", conditional=True)
    footprint_tcl = cfg.env("FOOTPRINT_TCL")
    load_additional = cfg.env("LOAD_ADDITIONAL_FILES", "1")
    if footprint_tcl and load_additional == "1":
        cfg.append(
            "ADDITIONAL_LEFS", f"{pd}/lef/sg13g2_io.lef {pd}/lef/bondpad_70x70.lef"
        )
        cfg.append(
            "ADDITIONAL_SLOW_LIBS", f"{pd}/lib/sg13g2_io_slow_1p08V_3p0V_125C.lib"
        )
        cfg.append(
            "ADDITIONAL_FAST_LIBS", f"{pd}/lib/sg13g2_io_fast_1p32V_3p6V_m40C.lib"
        )
        cfg.append("ADDITIONAL_TYP_LIBS", f"{pd}/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib")
        cfg.append(
            "ADDITIONAL_GDS", f"{pd}/gds/sg13g2_io.gds {pd}/gds/bondpad_70x70.gds"
        )

    cfg.set("TECH_LEF", f"{pd}/lef/sg13g2_tech.lef", conditional=True)
    cfg.set("SC_LEF", f"{pd}/lef/sg13g2_stdcell.lef", conditional=True)

    additional_slow_libs = cfg.get(
        "ADDITIONAL_SLOW_LIBS", cfg.env("ADDITIONAL_SLOW_LIBS")
    )
    additional_fast_libs = cfg.get(
        "ADDITIONAL_FAST_LIBS", cfg.env("ADDITIONAL_FAST_LIBS")
    )
    additional_typ_libs = cfg.get("ADDITIONAL_TYP_LIBS", cfg.env("ADDITIONAL_TYP_LIBS"))
    additional_gds = cfg.get("ADDITIONAL_GDS", cfg.env("ADDITIONAL_GDS"))

    slow_lib = f"{pd}/lib/sg13g2_stdcell_slow_1p08V_125C.lib"
    if additional_slow_libs:
        slow_lib += f" {additional_slow_libs}"
    cfg.set("SLOW_LIB_FILES", slow_lib, conditional=True)

    fast_lib = f"{pd}/lib/sg13g2_stdcell_fast_1p32V_m40C.lib"
    if additional_fast_libs:
        fast_lib += f" {additional_fast_libs}"
    cfg.set("FAST_LIB_FILES", fast_lib, conditional=True)

    typ_lib = f"{pd}/lib/sg13g2_stdcell_typ_1p20V_25C.lib"
    if additional_typ_libs:
        typ_lib += f" {additional_typ_libs}"
    cfg.set("TYP_LIB_FILES", typ_lib, conditional=True)

    cfg.set("LIB_FILES", cfg.get("TYP_LIB_FILES", typ_lib), conditional=True)

    gds_files = f"{pd}/gds/sg13g2_stdcell.gds"
    if additional_gds:
        gds_files += f" {additional_gds}"
    cfg.set("GDS_FILES", gds_files, conditional=True)

    # Dont use cells
    cfg.append(
        "DONT_USE_CELLS",
        "sg13g2_lgcp_1 sg13g2_sighold sg13g2_slgcp_1 sg13g2_dfrbp_2",
    )

    # Fill cells
    cfg.set(
        "FILL_CELLS",
        "sg13g2_fill_1 sg13g2_fill_2 sg13g2_decap_4 sg13g2_decap_8",
        conditional=True,
    )

    # Yosys
    cfg.set("TIEHI_CELL_AND_PORT", "sg13g2_tiehi L_HI")
    cfg.set("TIELO_CELL_AND_PORT", "sg13g2_tielo L_LO")
    cfg.set("MIN_BUF_CELL_AND_PORTS", "sg13g2_buf_1 A X")

    # Yosys mapping files
    cfg.set("LATCH_MAP_FILE", f"{pd}/cells_latch.v")
    cfg.set("CLKGATE_MAP_FILE", f"{pd}/cells_clkgate.v")

    cfg.set("ABC_DRIVER_CELL", "sg13g2_buf_4")
    cfg.set("ABC_LOAD_IN_FF", "6.0")

    # SDC clock period extraction: $(shell sed ...)
    # Replaces: $(origin ABC_CLOCK_PERIOD_IN_PS) check + $(shell sed ...) + awk
    if "ABC_CLOCK_PERIOD_IN_PS" not in os.environ:
        sdc_file = cfg.env("SDC_FILE")
        if sdc_file and os.path.isfile(sdc_file):
            with open(sdc_file) as f:
                for line in f:
                    m = re.search(
                        r"^set\s+clk_period\s+(\S+)|.*-period\s+(\S+)",
                        line,
                    )
                    if m:
                        val = m.group(1) or m.group(2)
                        try:
                            period_ps = str(float(val) * 1000)
                            cfg.set(
                                "ABC_CLOCK_PERIOD_IN_PS", period_ps, conditional=True
                            )
                        except ValueError:
                            pass
                        break

    # Sizing
    cfg.set("MATCH_CELL_FOOTPRINT", "1")

    # Floorplan
    cfg.set("PLACE_SITE", "CoreSite")
    cfg.set("IO_PLACER_V", "Metal2", conditional=True)
    cfg.set("IO_PLACER_H", "Metal3", conditional=True)
    cfg.set("PDN_TCL", f"{pd}/pdn.tcl", conditional=True)
    cfg.set("CORE_MARGIN", "17.5", conditional=True)
    cfg.set("TAPCELL_TCL", f"{pd}/tapcell.tcl", conditional=True)
    cfg.set("MACRO_PLACE_HALO", "40 40", conditional=True)

    # IO pin variables (??= treated as ?=)
    cfg.set("IO_NORTH_PINS", "", conditional=True)
    cfg.set("IO_SOUTH_PINS", "", conditional=True)
    cfg.set("IO_EAST_PINS", "", conditional=True)
    cfg.set("IO_WEST_PINS", "", conditional=True)

    # Bondpad/padframe variables
    cfg.set("IO_BONDPAD_SIZE", "70", conditional=True)
    cfg.set("IO_BONDPAD_NAME", "bondpad_70x70", conditional=True)
    cfg.set("IO_LENGTH", "180", conditional=True)
    cfg.set("IO_WIDTH", "80", conditional=True)
    cfg.set("IO_SEALRING_OFFSET", "70", conditional=True)
    cfg.set(
        "IO_FILLER_CELLS",
        "sg13g2_Filler10000 sg13g2_Filler4000 sg13g2_Filler2000 sg13g2_Filler1000 sg13g2_Filler400 sg13g2_Filler200",
        conditional=True,
    )

    # Place
    cfg.set("PLACE_DENSITY", "0.65", conditional=True)

    # Route
    cfg.set("MIN_ROUTING_LAYER", "Metal2", conditional=True)
    cfg.set("MAX_ROUTING_LAYER", "Metal5", conditional=True)
    cfg.set("FASTROUTE_TCL", f"{pd}/fastroute.tcl", conditional=True)

    # KLayout
    cfg.set("KLAYOUT_TECH_FILE", f"{pd}/sg13g2.lyt")
    cfg.set("FILL_CONFIG", f"{pd}/fill.json")

    # OpenRCX
    cfg.set("RCX_RULES", f"{pd}/rcx_patterns.rules")

    # IR Drop
    cfg.set("PWR_NETS_VOLTAGES", "VDD 1.2", conditional=True)
    cfg.set("GND_NETS_VOLTAGES", "VSS 0.0", conditional=True)
    cfg.set("IR_DROP_LAYER", "Metal1", conditional=True)

    # DRC/LVS
    cfg.set("KLAYOUT_DRC_FILE", f"{pd}/drc/sg13g2_minimal.lydrc", conditional=True)
    cfg.set("CDL_FILE", f"{pd}/cdl/sg13g2_stdcell.cdl", conditional=True)
    cfg.set("REMOVE_CELLS_FOR_LEC", "bondpad_70* sg13g2*", conditional=True)

    # Final
    cfg.set(
        "GDS_ALLOW_EMPTY",
        r"RM_IHPSG13_\dP_BITKIT_16x2_(CORNER|EDGE_TB|LE_con_corner|LE_con_edge_lr|LE_con_tap_lr|POWER_ramtap|TAP|TAP_LR)",
    )

    return cfg


if __name__ == "__main__":
    get_config().output()
