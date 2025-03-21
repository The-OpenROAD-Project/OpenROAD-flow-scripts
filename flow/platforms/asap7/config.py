def list_if_exists(environment, name):
    return environment.get(name, "").split()


def get_defaults(environment):
    lib_model = (
        "NLDM"
        if ("LIB_MODEL" not in environment or environment.get("LIB_MODEL", "") == "")
        else environment.get("LIB_MODEL")
    )
    lib_dir = f"{environment['PLATFORM_DIR']}/lib/{lib_model}"
    variables = {
        "PLATFORM": "asap7",
        "PROCESS": "7",
        "LIB_MODEL": lib_model,
        "LIB_DIR": lib_dir,
        # Library Setup variable
        "TECH_LEF": f"{environment['PLATFORM_DIR']}/lef/asap7_tech_1x_201209.lef",
        "SC_LEF": f"{environment['PLATFORM_DIR']}/lef/asap7sc7p5t_28_R_1x_220121a.lef",
        "GDS_FILES": " ".join(
            [f"{environment['PLATFORM_DIR']}/gds/asap7sc7p5t_28_R_220121a.gds"]
            + list_if_exists(environment, "ADDITIONAL_GDS")
        ),
        "BC_NLDM_LIB_FILES": " ".join(
            [
                f"{lib_dir}/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz",
                f"{lib_dir}/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib",
            ]
            + list_if_exists(environment, "BC_ADDITIONAL_LIBS")
        ),
        "BC_NLDM_LIB_FILES": " ".join(
            [
                f"{lib_dir}/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz",
                f"{lib_dir}/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib",
            ]
            + list_if_exists(environment, "BC_ADDITIONAL_LIBS")
        ),
        "BC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib",
        "BC_CCS_LIB_FILES": " ".join(
            [
                f"{lib_dir}/asap7sc7p5t_AO_RVT_FF_ccs_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_INVBUF_RVT_FF_ccs_220122.lib.gz",
                f"{lib_dir}/asap7sc7p5t_OA_RVT_FF_ccs_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SIMPLE_RVT_FF_ccs_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SEQ_RVT_FF_ccs_220123.lib",
            ]
            + list_if_exists(environment, "BC_ADDITIONAL_LIBS")
        ),
        "BC_CCS_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_RVT_FF_ccs_220123.lib",
        "WC_NLDM_LIB_FILES": " ".join(
            [
                f"{lib_dir}/asap7sc7p5t_AO_RVT_SS_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_INVBUF_RVT_SS_nldm_220122.lib.gz",
                f"{lib_dir}/asap7sc7p5t_OA_RVT_SS_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib",
                f"{lib_dir}/asap7sc7p5t_SIMPLE_RVT_SS_nldm_211120.lib.gz",
            ]
            + list_if_exists(environment, "WC_ADDITIONAL_LIBS")
        ),
        "WC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib",
        "TC_NLDM_LIB_FILES": " ".join(
            [
                f"{lib_dir}/asap7sc7p5t_AO_RVT_TT_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.lib.gz",
                f"{lib_dir}/asap7sc7p5t_OA_RVT_TT_nldm_211120.lib.gz",
                f"{lib_dir}/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib",
                f"{lib_dir}/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz",
            ]
            + list_if_exists(environment, "TC_ADDITIONAL_LIBS")
        ),
        "TC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib",
        **(
            # Add the multi-bit FF for clustering.  These are single corner libraries.
            {
                "ADDITIONAL_SITES": "asap7sc7p5t_pg",
                "GDS_ALLOW_EMPTY": "DFFHQN[VH][24].*",
            }
            if environment.get("CLUSTER_FLOPS") == "1"
            else {}
        ),
        "ADDITIONAL_LIBS": " ".join(
            (
                [
                    f"{lib_dir}/asap7sc7p5t_DFFHQNH2V2X_RVT_TT_nldm_FAKE.lib",
                    f"{lib_dir}/asap7sc7p5t_DFFHQNV2X_RVT_TT_nldm_FAKE.lib",
                ]
                if environment.get("CLUSTER_FLOPS") == "1"
                else []
            )
            + list_if_exists(environment, "ADDITIONAL_LIBS")
        ),
        "ADDITIONAL_LEFS": " ".join(
            (
                [
                    f"{environment['PLATFORM_DIR']}/lef/asap7sc7p5t_DFFHQNH2V2X.lef",
                    f"{environment['PLATFORM_DIR']}/lef/asap7sc7p5t_DFFHQNV2X.lef",
                ]
                if environment.get("CLUSTER_FLOPS") == "1"
                else []
            )
            + list_if_exists(environment, "ADDITIONAL_LEFS")
        ),
        "BC_TEMPERATURE": "25C",
        "TC_TEMPERATURE": "0C",
        "WC_TEMPERATURE": "100C",
        "BC_VOLTAGE": "0.77",
        "TC_VOLTAGE": "0.70",
        "WC_VOLTAGE": "0.63",
        # Don't use cells to ease congestion
        # Specify at least one filler cell if none
        "DONT_USE_CELLS": " ".join(["*x1p*_ASAP7*", "*xp*_ASAP7*", "SDF*", "ICG*"]),
        # Yosys mapping files
        "LATCH_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_latch_R.v",
        "CLKGATE_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_clkgate_R.v",
        "ADDER_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_adders_R.v",
        "SYNTH_MINIMUM_KEEP_SIZE": "1000",
        "ABC_DRIVER_CELL": "BUFx2_ASAP7_75t_R",
        # BUF_X1, pin (A) = 0.974659. Arbitrarily multiply by 4
        "ABC_LOAD_IN_FF": "3.898",
        # Set the TIEHI/TIELO cells
        # These are used in yosys synthesis to avoid logical 1/0's in the netlist
        "TIEHI_CELL_AND_PORT": "TIEHIx1_ASAP7_75t_R H",
        "TIELO_CELL_AND_PORT": "TIELOx1_ASAP7_75t_R L",
        # Used in synthesis
        "MIN_BUF_CELL_AND_PORTS": "BUFx2_ASAP7_75t_R A Y",
        # Placement site for core cells
        # This can be found in the technology LEF
        "PLACE_SITE": "asap7sc7p5t",
        "MAKE_TRACKS": f"{environment['PLATFORM_DIR']}/openRoad/make_tracks.tcl",
        # Define default PDN config
        "PDN_TCL": (
            f"{environment['PLATFORM_DIR']}/openRoad/pdn/BLOCKS_grid_strategy.tcl"
            if environment.get("BLOCKS")
            else f"{environment['PLATFORM_DIR']}/openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl"
        ),
        # IO Placer pin layers
        "IO_PLACER_H": "M4",
        "IO_PLACER_V": "M5",
        # Macro placement halo
        "MACRO_PLACE_HALO": "10 10",
        # The following create a keep-out/halo between macro and core rows
        "MACRO_ROWS_HALO_X": "2",
        "MACRO_ROWS_HALO_Y": "2",
        "PLACE_DENSITY": "0.60",
        # Endcap and Welltie cells
        "TAPCELL_TCL": f"{environment['PLATFORM_DIR']}/openRoad/tapcell.tcl",
        # Fill cells used in fill cell insertion
        "FILL_CELLS": " ".join(
            [
                "FILLERxp5_ASAP7_75t_R",
                "FILLER_ASAP7_75t_R",
                "DECAPx1_ASAP7_75t_R",
                "DECAPx2_ASAP7_75t_R",
                "DECAPx4_ASAP7_75t_R",
                "DECAPx6_ASAP7_75t_R",
                "DECAPx10_ASAP7_75t_R",
            ]
        ),
        "TAP_CELL_NAME": "TAPCELL_ASAP7_75t_R",
        "SET_RC_TCL": f"{environment['PLATFORM_DIR']}/setRC.tcl",
        # Route options
        "MIN_ROUTING_LAYER": "M2",
        # "MIN_CLOCK_ROUTING_LAYER": "M4",  # Uncomment if needed
        "MAX_ROUTING_LAYER": "M7",
        # KLayout technology file
        "KLAYOUT_TECH_FILE": f"{environment['PLATFORM_DIR']}/KLayout/asap7.lyt",
        # KLayout DRC ruledeck
        "KLAYOUT_DRC_FILE": f"{environment['PLATFORM_DIR']}/drc/asap7.lydrc",
        # OpenRCX extRules
        "RCX_RULES": f"{environment['PLATFORM_DIR']}/rcx_patterns.rules",
        # XS - defining function for using LVT
        **(
            {
                "TIEHI_CELL_AND_PORT": "TIEHIx1_ASAP7_75t_L H",
                "TIELO_CELL_AND_PORT": "TIELOx1_ASAP7_75t_L L",
                "MIN_BUF_CELL_AND_PORTS": "BUFx2_ASAP7_75t_L A Y",
                "HOLD_BUF_CELL": "BUFx2_ASAP7_75t_L",
                "ABC_DRIVER_CELL": "BUFx2_ASAP7_75t_L",
                "FILL_CELLS": "FILLERxp5_ASAP7_75t_L",
                "TAP_CELL_NAME": "TAPCELL_ASAP7_75t_L",
                "GDS_FILES": " ".join(
                    [f"{environment['PLATFORM_DIR']}/gds/asap7sc7p5t_28_L_220121a.gds"]
                    + list_if_exists(environment, "ADDITIONAL_GDS")
                ),
                "SC_LEF": f"{environment['PLATFORM_DIR']}/lef/asap7sc7p5t_28_L_1x_220121a.lef",
                "LATCH_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_latch_L.v",
                "CLKGATE_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_clkgate_L.v",
                "ADDER_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_adders_L.v",
                "BC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_LVT_FF_nldm_220123.lib",
                "BC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_LVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_LVT_FF_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_LVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_LVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_LVT_FF_nldm_220123.lib",
                    ]
                ),
                "WC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_LVT_SS_nldm_220123.lib",
                "WC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_LVT_SS_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_LVT_SS_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_LVT_SS_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_LVT_SS_nldm_220123.lib",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_LVT_SS_nldm_211120.lib.gz",
                    ]
                ),
                "TC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib",
                "TC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_LVT_TT_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_LVT_TT_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib.gz",
                    ]
                ),
            }
            if environment.get("ASAP7_USELVT") == "1"
            else {}
        ),
        **(
            {
                "TIEHI_CELL_AND_PORT": "TIEHIx1_ASAP7_75t_SL H",
                "TIELO_CELL_AND_PORT": "TIELOx1_ASAP7_75t_SL L",
                "MIN_BUF_CELL_AND_PORTS": "BUFx2_ASAP7_75t_SL A Y",
                "HOLD_BUF_CELL": "BUFx2_ASAP7_75t_SL",
                "ABC_DRIVER_CELL": "BUFx2_ASAP7_75t_SL",
                "FILL_CELLS": "FILLERxp5_ASAP7_75t_SL",
                "TAP_CELL_NAME": "TAPCELL_ASAP7_75t_SL",
                "GDS_FILES": " ".join(
                    [f"{environment['PLATFORM_DIR']}/gds/asap7sc7p5t_28_SL_220121a.gds"]
                    + list_if_exists(environment, "ADDITIONAL_GDS")
                ),
                "SC_LEF": f"{environment['PLATFORM_DIR']}/lef/asap7sc7p5t_28_SL_1x_220121a.lef",
                "LATCH_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_latch_SL.v",
                "CLKGATE_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_clkgate_SL.v",
                "ADDER_MAP_FILE": f"{environment['PLATFORM_DIR']}/yoSys/cells_adders_SL.v",
                "BC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib",
                "BC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_SLVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_SLVT_FF_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_SLVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_SLVT_FF_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib",
                    ]
                ),
                "WC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib",
                "WC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_SLVT_SS_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_SLVT_SS_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_SLVT_SS_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_SLVT_SS_nldm_211120.lib.gz",
                    ]
                ),
                "TC_NLDM_DFF_LIB_FILE": f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib",
                "TC_NLDM_LIB_FILES": " ".join(
                    [
                        f"{lib_dir}/asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib.gz",
                        f"{lib_dir}/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib",
                        f"{lib_dir}/asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib.gz",
                    ]
                ),
            }
            if environment.get("ASAP7_USESLVT") == "1"
            else {}
        ),
        # Don't use SC library based on CORNER selection
        #
        # BC - Best case, fastest
        # WC - Worst case, slowest
        # TC - Typical case
        "CORNER": environment.get("CORNER", "BC"),
        # FIXME Need merged.lib for now, but ideally it shouldn't be necessary:
        #
        # https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/pull/2139
        "DONT_USE_SC_LIB": f"{environment['OBJECTS_DIR']}/lib/merged.lib",
        # ---------------------------------------------------------
        #  IR Drop
        # ---------------------------------------------------------
        # IR drop estimation supply net name to be analyzed and supply voltage variable
        # For multiple nets: PWR_NETS_VOLTAGES = "VDD1 1.8 VDD2 1.2"
        "GND_NETS_VOLTAGES": "VSS 0.0",
        "IR_DROP_LAYER": "M1",
        # Allow empty GDS cell
        "GDS_ALLOW_EMPTY": "fakeram.*",
    }

    variables |= {
        "LIB_FILES": " ".join(
            list_if_exists(environment, "LIB_FILES")
            + list_if_exists(
                variables,
                f"{variables['CORNER']}_{variables.get('LIB_MODEL', 'NLDM')}_LIB_FILES",
            )
            + list_if_exists(variables, "ADDITIONAL_LIBS")
        ),
        "DB_FILES": " ".join(
            list_if_exists(variables, f"{variables['CORNER']}_DB_FILES")
        ),
        "TEMPERATURE": variables.get(f"{variables['CORNER']}_TEMPERATURE"),
        "VOLTAGE": variables.get(f"{variables['CORNER']}_VOLTAGE"),
    }
    variables |= {
        "PWR_NETS_VOLTAGES": f"VDD {variables['VOLTAGE']}",
    }
    return variables
