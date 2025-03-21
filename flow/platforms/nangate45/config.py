import glob
import os


def get_defaults(variables):
    gds_files = (
        " ".join(
            sorted(glob.glob(os.path.join(variables["PLATFORM_DIR"], "gds", "*.gds")))
        )
        + " "
        + variables.get("ADDITIONAL_GDS", "")
    ).strip()
    return {
        "PROCESS": "45",
        # -----------------------------------------------------
        # Tech/Libs
        # -----------------------------------------------------
        "TECH_LEF": f"{variables['PLATFORM_DIR']}/lef/NangateOpenCellLibrary.tech.lef",
        "SC_LEF": f"{variables['PLATFORM_DIR']}/lef/NangateOpenCellLibrary.macro.mod.lef",
        "LIB_FILES": f"{variables['PLATFORM_DIR']}/lib/NangateOpenCellLibrary_typical.lib {variables.get('ADDITIONAL_LIBS', '')}",
        "GDS_FILES": gds_files,
        # Don't use cells to ease congestion
        # Specify at least one filler cell if none
        "DONT_USE_CELLS": "TAPCELL_X1 FILLCELL_X1 AOI211_X1 OAI211_X1",
        # Fill cells used in fill cell insertion
        "FILL_CELLS": "FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32",
        # -----------------------------------------------------
        # Yosys
        # -----------------------------------------------------
        # Ungroup size for hierarchical synthesis
        "SYNTH_MINIMUM_KEEP_SIZE": 10000,
        # Set the TIEHI/TIELO cells
        # These are used in yosys synthesis to avoid logical 1/0's in the netlist
        "TIEHI_CELL_AND_PORT": "LOGIC1_X1 Z",
        "TIELO_CELL_AND_PORT": "LOGIC0_X1 Z",
        # Used in synthesis
        "MIN_BUF_CELL_AND_PORTS": "BUF_X1 A Z",
        # Yosys mapping files
        "LATCH_MAP_FILE": f"{variables['PLATFORM_DIR']}/cells_latch.v",
        "CLKGATE_MAP_FILE": f"{variables['PLATFORM_DIR']}/cells_clkgate.v",
        "ADDER_MAP_FILE": f"{variables['PLATFORM_DIR']}/cells_adders.v",
        "ABC_DRIVER_CELL": "BUF_X1",
        # BUF_X1, pin (A) = 0.974659. Arbitrarily multiply by 4
        "ABC_LOAD_IN_FF": 3.898,
        # --------------------------------------------------------
        # Floorplan
        # --------------------------------------------------------
        # Placement site for core cells
        # This can be found in the technology lef
        "PLACE_SITE": "FreePDK45_38x28_10R_NP_162NW_34O",
        # IO Placer pin layers
        "IO_PLACER_H": "metal5",
        "IO_PLACER_V": "metal6",
        # Define default PDN config
        "PDN_TCL": f"{variables['PLATFORM_DIR']}/grid_strategy-M1-M4-M7.tcl",
        # Endcap and Welltie cells
        "TAPCELL_TCL": f"{variables['PLATFORM_DIR']}/tapcell.tcl",
        "TAP_CELL_NAME": "TAPCELL_X1",
        "MACRO_PLACE_HALO": "22.4 15.12",
        # ---------------------------------------------------------
        # Place
        # ---------------------------------------------------------
        "PLACE_DENSITY": 0.30,
        # ---------------------------------------------------------
        # Route
        # ---------------------------------------------------------
        # FastRoute options
        "MIN_ROUTING_LAYER": "metal2",
        "MAX_ROUTING_LAYER": "metal10",
        # Define fastRoute tcl
        "FASTROUTE_TCL": f"{variables['PLATFORM_DIR']}/fastroute.tcl",
        # KLayout technology file
        "KLAYOUT_TECH_FILE": f"{variables['PLATFORM_DIR']}/FreePDK45.lyt",
        # KLayout DRC ruledeck
        "KLAYOUT_DRC_FILE": f"{variables['PLATFORM_DIR']}/drc/FreePDK45.lydrc",
        # KLayout LVS ruledeck
        "KLAYOUT_LVS_FILE": f"{variables['PLATFORM_DIR']}/lvs/FreePDK45.lylvs",
        # Allow empty GDS cell
        "GDS_ALLOW_EMPTY": "fakeram.*",
        "CDL_FILE": f"{variables['PLATFORM_DIR']}/cdl/NangateOpenCellLibrary.cdl",
        # Template definition for power grid analysis
        "TEMPLATE_PGA_CFG": f"{variables['PLATFORM_DIR']}/template_pga.cfg",
        # OpenRCX extRules
        "RCX_RULES": f"{variables['PLATFORM_DIR']}/rcx_patterns.rules",
        # ---------------------------------------------------------
        # IR Drop
        # ---------------------------------------------------------
        # IR drop estimation supply net name to be analyzed and supply voltage variable
        # For multiple nets: PWR_NETS_VOLTAGES = "VDD1 1.8 VDD2 1.2"
        "PWR_NETS_VOLTAGES": "VDD 1.1",
        "GND_NETS_VOLTAGES": "VSS 0.0",
        "IR_DROP_LAYER": "metal1",
    }
