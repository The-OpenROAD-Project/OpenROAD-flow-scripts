#!/usr/bin/env python3
"""Platform configuration for asap7.

Generates the same variable assignments as config.mk.
Handles VT variant selection, PLACEHOLDER template expansion,
foreach/eval loop for OTHER_VT, and corner-based indirection.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
from platform_config_utils import PlatformConfig


def get_config(platform_dir=None):
    cfg = PlatformConfig(platform_dir)
    pd = cfg.platform_dir

    cfg.set("PLATFORM", "asap7")
    cfg.set("PROCESS", "7")

    # LIB_MODEL defaults to NLDM if not set
    lib_model = cfg.env("LIB_MODEL", "NLDM")
    if not lib_model:
        lib_model = "NLDM"
    cfg.set("LIB_MODEL", lib_model)
    lib_dir = f"{pd}/lib/{lib_model}"
    cfg.set("LIB_DIR", lib_dir, conditional=True)

    cfg.set("PLATFORM_TCL", f"{pd}/liberty_suppressions.tcl")

    # Library Setup
    cfg.set("TECH_LEF", f"{pd}/lef/asap7_tech_1x_201209.lef")

    cfg.set("BC_TEMPERATURE", "25C")
    cfg.set("TC_TEMPERATURE", "0C")
    cfg.set("WC_TEMPERATURE", "100C")

    cfg.set("BC_VOLTAGE", "0.77")
    cfg.set("TC_VOLTAGE", "0.70")
    cfg.set("WC_VOLTAGE", "0.63")

    # Dont use cells
    cfg.set("DONT_USE_CELLS", "*x1p*_ASAP7* *xp*_ASAP7*")
    cfg.append("DONT_USE_CELLS", "SDF* ICG*")

    cfg.set("SYNTH_MINIMUM_KEEP_SIZE", "1000", conditional=True)
    cfg.set("ABC_LOAD_IN_FF", "3.898")

    # Placement site
    cfg.set("PLACE_SITE", "asap7sc7p5t", conditional=True)
    cfg.set("MAKE_TRACKS", f"{pd}/openRoad/make_tracks.tcl")

    # PDN - conditional on BLOCKS
    blocks = cfg.env("BLOCKS")
    if not blocks:
        cfg.set(
            "PDN_TCL",
            f"{pd}/openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl",
            conditional=True,
        )
    else:
        cfg.set(
            "PDN_TCL", f"{pd}/openRoad/pdn/BLOCKS_grid_strategy.tcl", conditional=True
        )

    # IO Placer
    cfg.set("IO_PLACER_H", "M4", conditional=True)
    cfg.set("IO_PLACER_V", "M5", conditional=True)
    cfg.set("MACRO_PLACE_HALO", "10 10", conditional=True)
    cfg.set("MACRO_ROWS_HALO_X", "2", conditional=True)
    cfg.set("MACRO_ROWS_HALO_Y", "2", conditional=True)
    cfg.set("PLACE_DENSITY", "0.60", conditional=True)

    # Endcap and Welltie
    cfg.set("TAPCELL_TCL", f"{pd}/openRoad/tapcell.tcl", conditional=True)
    cfg.set("SET_RC_TCL", f"{pd}/setRC.tcl")

    # Route options
    cfg.set("MIN_ROUTING_LAYER", "M2", conditional=True)
    cfg.set("MIN_CLK_ROUTING_LAYER", "M4", conditional=True)
    cfg.set("MAX_ROUTING_LAYER", "M7", conditional=True)
    cfg.set("FASTROUTE_TCL", f"{pd}/fastroute.tcl", conditional=True)

    # KLayout
    cfg.set("KLAYOUT_TECH_FILE", f"{pd}/KLayout/asap7.lyt")
    cfg.set("KLAYOUT_DRC_FILE", f"{pd}/drc/asap7.lydrc")

    # OpenRCX
    cfg.set("RCX_RULES", f"{pd}/rcx_patterns.rules")

    # PLACEHOLDER templates
    bc_nldm_dff_t = f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_FF_nldm_220123.lib"
    bc_ccs_dff_t = f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_FF_ccs_220123.lib"
    wc_nldm_dff_t = f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_SS_nldm_220123.lib"
    tc_nldm_dff_t = f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_TT_nldm_220123.lib"

    bc_nldm_libs_t = (
        f"{lib_dir}/asap7sc7p5t_AO_PLACEHOLDERVT_FF_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_INVBUF_PLACEHOLDERVT_FF_nldm_220122.lib.gz "
        f"{lib_dir}/asap7sc7p5t_OA_PLACEHOLDERVT_FF_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SIMPLE_PLACEHOLDERVT_FF_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_FF_nldm_220123.lib"
    )
    bc_ccs_libs_t = (
        f"{lib_dir}/asap7sc7p5t_AO_PLACEHOLDERVT_FF_ccs_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_INVBUF_PLACEHOLDERVT_FF_ccs_220122.lib.gz "
        f"{lib_dir}/asap7sc7p5t_OA_PLACEHOLDERVT_FF_ccs_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SIMPLE_PLACEHOLDERVT_FF_ccs_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_FF_ccs_220123.lib"
    )
    wc_nldm_libs_t = (
        f"{lib_dir}/asap7sc7p5t_AO_PLACEHOLDERVT_SS_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_INVBUF_PLACEHOLDERVT_SS_nldm_220122.lib.gz "
        f"{lib_dir}/asap7sc7p5t_OA_PLACEHOLDERVT_SS_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_SS_nldm_220123.lib "
        f"{lib_dir}/asap7sc7p5t_SIMPLE_PLACEHOLDERVT_SS_nldm_211120.lib.gz"
    )
    tc_nldm_libs_t = (
        f"{lib_dir}/asap7sc7p5t_AO_PLACEHOLDERVT_TT_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_INVBUF_PLACEHOLDERVT_TT_nldm_220122.lib.gz "
        f"{lib_dir}/asap7sc7p5t_OA_PLACEHOLDERVT_TT_nldm_211120.lib.gz "
        f"{lib_dir}/asap7sc7p5t_SEQ_PLACEHOLDERVT_TT_nldm_220123.lib "
        f"{lib_dir}/asap7sc7p5t_SIMPLE_PLACEHOLDERVT_TT_nldm_211120.lib.gz"
    )

    fill_cells_t = [
        "FILLERxp5_ASAP7_75t_",
        "FILLER_ASAP7_75t_",
        "DECAPx1_ASAP7_75t_",
        "DECAPx2_ASAP7_75t_",
        "DECAPx4_ASAP7_75t_",
        "DECAPx6_ASAP7_75t_",
        "DECAPx10_ASAP7_75t_",
    ]

    # VT list: default to RVT if ASAP7_USE_VT is unset
    asap7_use_vt = cfg.env("ASAP7_USE_VT", "").strip()
    vt_list = asap7_use_vt.split() if asap7_use_vt else ["RVT"]
    primary_vt = vt_list[0]
    primary_vt_tag = primary_vt.replace("VT", "")  # RVT -> R, LVT -> L, SLVT -> SL
    other_vt = vt_list[1:]

    # Set cells based on primary VT
    cfg.set(
        "TIEHI_CELL_AND_PORT", f"TIEHIx1_ASAP7_75t_{primary_vt_tag} H", conditional=True
    )
    cfg.set(
        "TIELO_CELL_AND_PORT", f"TIELOx1_ASAP7_75t_{primary_vt_tag} L", conditional=True
    )
    cfg.set(
        "MIN_BUF_CELL_AND_PORTS",
        f"BUFx2_ASAP7_75t_{primary_vt_tag} A Y",
        conditional=True,
    )
    cfg.set("HOLD_BUF_CELL", f"BUFx2_ASAP7_75t_{primary_vt_tag}", conditional=True)
    cfg.set("ABC_DRIVER_CELL", f"BUFx2_ASAP7_75t_{primary_vt_tag}", conditional=True)

    # Fill cells: $(addsuffix $(PRIMARY_VT_TAG), $(FILL_CELLS_T))
    cfg.set(
        "FILL_CELLS",
        " ".join(f"{cell}{primary_vt_tag}" for cell in fill_cells_t),
        conditional=True,
    )

    cfg.set("TAP_CELL_NAME", f"TAPCELL_ASAP7_75t_{primary_vt_tag}", conditional=True)

    # GDS_FILES uses = (not ?=) because it gets set in the ORFS Makefile
    cfg.set("GDS_FILES", f"{pd}/gds/asap7sc7p5t_28_{primary_vt_tag}_220121a.gds")

    cfg.set(
        "SC_LEF",
        f"{pd}/lef/asap7sc7p5t_28_{primary_vt_tag}_1x_220121a.lef",
        conditional=True,
    )

    # Yosys mapping files
    cfg.set(
        "LATCH_MAP_FILE", f"{pd}/yoSys/cells_latch_{primary_vt_tag}.v", conditional=True
    )
    cfg.set(
        "CLKGATE_MAP_FILE",
        f"{pd}/yoSys/cells_clkgate_{primary_vt_tag}.v",
        conditional=True,
    )
    cfg.set(
        "ADDER_MAP_FILE",
        f"{pd}/yoSys/cells_adders_{primary_vt_tag}.v",
        conditional=True,
    )

    # Expand primary VT templates
    def expand(template, tag):
        return template.replace("PLACEHOLDER", tag)

    cfg.set(
        "BC_NLDM_DFF_LIB_FILE", expand(bc_nldm_dff_t, primary_vt_tag), conditional=True
    )
    cfg.set(
        "BC_NLDM_LIB_FILES", expand(bc_nldm_libs_t, primary_vt_tag), conditional=True
    )
    bc_ccs_libs = expand(bc_ccs_libs_t, primary_vt_tag)
    bc_additional = cfg.env("BC_ADDITIONAL_LIBS")
    if bc_additional:
        bc_ccs_libs += f" {bc_additional}"
    cfg.set("BC_CCS_LIB_FILES", bc_ccs_libs, conditional=True)
    cfg.set(
        "BC_CCS_DFF_LIB_FILE", expand(bc_ccs_dff_t, primary_vt_tag), conditional=True
    )

    cfg.set(
        "WC_NLDM_DFF_LIB_FILE", expand(wc_nldm_dff_t, primary_vt_tag), conditional=True
    )
    cfg.set(
        "WC_NLDM_LIB_FILES", expand(wc_nldm_libs_t, primary_vt_tag), conditional=True
    )

    cfg.set(
        "TC_NLDM_DFF_LIB_FILE", expand(tc_nldm_dff_t, primary_vt_tag), conditional=True
    )
    cfg.set(
        "TC_NLDM_LIB_FILES", expand(tc_nldm_libs_t, primary_vt_tag), conditional=True
    )

    # CLUSTER_FLOPS conditional
    cluster_flops = cfg.env("CLUSTER_FLOPS")
    if cluster_flops == "1":
        cfg.append(
            "ADDITIONAL_LIBS",
            f"{lib_dir}/asap7sc7p5t_DFFHQNH2V2X_{primary_vt_tag}VT_TT_nldm_FAKE.lib "
            f"{lib_dir}/asap7sc7p5t_DFFHQNV2X_{primary_vt_tag}VT_TT_nldm_FAKE.lib",
        )
        cfg.append(
            "ADDITIONAL_LEFS",
            f"{pd}/lef/asap7sc7p5t_DFFHQNH2V2X.lef "
            f"{pd}/lef/asap7sc7p5t_DFFHQNV2X.lef",
        )
        cfg.append("ADDITIONAL_SITES", "asap7sc7p5t_pg")
        cfg.set("GDS_ALLOW_EMPTY", "DFFHQN[VH][24].*", conditional=True)

    # foreach/eval loop: expand OTHER_VT templates and append
    for vt_type in other_vt:
        vt_tag = vt_type.replace("VT", "")  # LVT -> L, SLVT -> SL

        cfg.append(
            "ADDITIONAL_LEFS", f"{pd}/lef/asap7sc7p5t_28_{vt_tag}_1x_220121a.lef"
        )
        cfg.append("BC_NLDM_DFF_LIB_FILE", expand(bc_nldm_dff_t, vt_tag))
        cfg.append("BC_CCS_DFF_LIB_FILE", expand(bc_ccs_dff_t, vt_tag))
        cfg.append("WC_NLDM_DFF_LIB_FILE", expand(wc_nldm_dff_t, vt_tag))
        cfg.append("TC_NLDM_DFF_LIB_FILE", expand(tc_nldm_dff_t, vt_tag))
        cfg.append("BC_NLDM_LIB_FILES", expand(bc_nldm_libs_t, vt_tag))
        cfg.append("BC_CCS_LIB_FILES", expand(bc_ccs_libs_t, vt_tag))
        cfg.append("WC_NLDM_LIB_FILES", expand(wc_nldm_libs_t, vt_tag))
        cfg.append("TC_NLDM_LIB_FILES", expand(tc_nldm_libs_t, vt_tag))
        cfg.append("GDS_FILES", f"{pd}/gds/asap7sc7p5t_28_{vt_tag}_220121a.gds")
        cfg.append(
            "FILL_CELLS",
            " ".join(f"{cell}{vt_tag}" for cell in fill_cells_t),
        )

    # Corner selection via variable indirection
    corner = cfg.env("CORNER", "BC")
    cfg.set("CORNER", corner, conditional=True)

    # $($(CORNER)_$(LIB_MODEL)_LIB_FILES)
    corner_model_key = f"{corner}_{lib_model}_LIB_FILES"
    # Map to the right variable we computed above
    lib_model_map = {
        "BC_NLDM": "BC_NLDM_LIB_FILES",
        "BC_CCS": "BC_CCS_LIB_FILES",
        "WC_NLDM": "WC_NLDM_LIB_FILES",
        "TC_NLDM": "TC_NLDM_LIB_FILES",
    }
    corner_lib_key = lib_model_map.get(
        f"{corner}_{lib_model}", f"{corner}_{lib_model}_LIB_FILES"
    )
    corner_lib_files = cfg.get(corner_lib_key, "")

    cfg.append("LIB_FILES", corner_lib_files)
    additional_libs = cfg.env("ADDITIONAL_LIBS")
    if additional_libs:
        cfg.append("LIB_FILES", additional_libs)

    additional_gds = cfg.env("ADDITIONAL_GDS")
    if additional_gds:
        cfg.append("GDS_FILES", additional_gds)

    # DB_FILES uses $(realpath $($(CORNER)_DB_FILES))
    corner_db_key = f"{corner}_DB_FILES"
    db_files = cfg.get(corner_db_key, cfg.env(corner_db_key, ""))
    if db_files:
        resolved = " ".join(os.path.realpath(p) for p in db_files.split() if p)
        cfg.append("DB_FILES", resolved)

    cfg.set("TEMPERATURE", cfg.get(f"{corner}_TEMPERATURE", "25C"))
    cfg.set("VOLTAGE", cfg.get(f"{corner}_VOLTAGE", "0.77"))

    # IR Drop
    voltage = cfg.get("VOLTAGE", "0.77")
    cfg.set("PWR_NETS_VOLTAGES", f"VDD {voltage}", conditional=True)
    cfg.set("GND_NETS_VOLTAGES", "VSS 0.0", conditional=True)
    cfg.set("IR_DROP_LAYER", "M1", conditional=True)

    # Allow empty GDS
    cfg.set("GDS_ALLOW_EMPTY", "fakeram.*", conditional=True)

    cfg.set("REMOVE_CELLS_FOR_LEC", "TAPCELL*")

    return cfg


if __name__ == "__main__":
    get_config().output()
