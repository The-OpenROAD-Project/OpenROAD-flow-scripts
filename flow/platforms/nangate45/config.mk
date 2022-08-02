# Process node
export PROCESS = 45

#-----------------------------------------------------
# Tech/Libs
# ----------------------------------------------------
export TECH_LEF = $(PLATFORM_DIR)/lef/NangateOpenCellLibrary.tech.lef
export SC_LEF = $(PLATFORM_DIR)/lef/NangateOpenCellLibrary.macro.mod.lef

export LIB_FILES = $(PLATFORM_DIR)/lib/NangateOpenCellLibrary_typical.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(sort $(wildcard $(PLATFORM_DIR)/gds/*.gds)) \
                     $(ADDITIONAL_GDS)
# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS = TAPCELL_X1 FILLCELL_X1 AOI211_X1 OAI211_X1

# Fill cells used in fill cell insertion
export FILL_CELLS = FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32

# -----------------------------------------------------
#  Yosys
#  ----------------------------------------------------
# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = LOGIC1_X1 Z
export TIELO_CELL_AND_PORT = LOGIC0_X1 Z

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = BUF_X1 A Z


# Yosys mapping files
export LATCH_MAP_FILE = $(PLATFORM_DIR)/cells_latch.v
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate.v
export ADDER_MAP_FILE ?= $(PLATFORM_DIR)/cells_adders.v
#
# Set yosys-abc clock period to first "-period" found in sdc file
export ABC_CLOCK_PERIOD_IN_PS ?= $(shell sed -nr "s/^set clk_period (.+)|.* -period (.+) .*/\1\2/p" $(SDC_FILE) | head -1 | awk '{print $$1*1000}')
export ABC_DRIVER_CELL = BUF_X1
# BUF_X1, pin (A) = 0.974659. Arbitrarily multiply by 4
export ABC_LOAD_IN_FF = 3.898

#--------------------------------------------------------
# Floorplan
# -------------------------------------------------------

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = FreePDK45_38x28_10R_NP_162NW_34O

# IO Placer pin layers
export IO_PLACER_H = metal3
export IO_PLACER_V = metal2

# Define default PDN config
export PDN_TCL ?= $(PLATFORM_DIR)/grid_strategy-M1-M4-M7.tcl

# Endcap and Welltie cells
export TAPCELL_TCL = $(PLATFORM_DIR)/tapcell.tcl

export MACRO_PLACE_HALO ?= 22.4 15.12
export MACRO_PLACE_CHANNEL ?= 18.8 19.95

#---------------------------------------------------------
# Place
# --------------------------------------------------------
# Cell padding in SITE widths to ease rout-ability.  Applied to both sides
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT ?= 0
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT ?= 0
#

export PLACE_DENSITY ?= 0.30

# --------------------------------------------------------
#  CTS
#  -------------------------------------------------------
# TritonCTS options
export CTS_BUF_CELL   ?= BUF_X4

# ---------------------------------------------------------
#  Route
# ---------------------------------------------------------
# FastRoute options
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Define fastRoute tcl
export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute.tcl

# KLayout technology file
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/FreePDK45.lyt

# KLayout DRC ruledeck
export KLAYOUT_DRC_FILE = $(PLATFORM_DIR)/drc/FreePDK45.lydrc

# KLayout LVS ruledeck
export KLAYOUT_LVS_FILE = $(PLATFORM_DIR)/lvs/FreePDK45.lylvs

# Allow empty GDS cell
export GDS_ALLOW_EMPTY = fakeram.*

export CDL_FILE = $(PLATFORM_DIR)/cdl/NangateOpenCellLibrary.cdl

# Template definition for power grid analysis
export TEMPLATE_PGA_CFG ?= $(PLATFORM_DIR)/template_pga.cfg

# OpenRCX extRules
export RCX_RULES               = $(PLATFORM_DIR)/rcx_patterns.rules
# ---------------------------------------------------------
#  IR Drop
# ---------------------------------------------------------

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  ?= "VDD 1.1"
export GND_NETS_VOLTAGES  ?= "VSS 0.0"
export IR_DROP_LAYER ?= metal1
