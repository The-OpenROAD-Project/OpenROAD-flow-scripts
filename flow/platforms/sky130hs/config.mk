# Process node
export PROCESS = 130

#-----------------------------------------------------
# Tech/Libs
# ----------------------------------------------------
export TECH_LEF = $(PLATFORM_DIR)/lef/sky130_fd_sc_hs.tlef
export SC_LEF = $(PLATFORM_DIR)/lef/sky130_fd_sc_hs_merged.lef

export LIB_FILES = $(PLATFORM_DIR)/lib/sky130_fd_sc_hs__tt_025C_1v80.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard $(PLATFORM_DIR)/gds/*.gds) \
                     $(ADDITIONAL_GDS)

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS += 

# Define fill cells
export FILL_CELLS ?= sky130_fd_sc_hs__fill_1 sky130_fd_sc_hs__fill_2 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_8

# -----------------------------------------------------
#  Yosys
#  ----------------------------------------------------
# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 HI
export TIELO_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 LO

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = sky130_fd_sc_hs__buf_4 A X


# Yosys mapping files
export LATCH_MAP_FILE = $(PLATFORM_DIR)/cells_latch_hs.v
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate_hs.v
export ADDER_MAP_FILE ?= $(PLATFORM_DIR)/cells_adders_hs.v
# 
# Define ABC driver and load
export ABC_DRIVER_CELL = sky130_fd_sc_hs__buf_1
export ABC_LOAD_IN_FF = 5
#--------------------------------------------------------
# Floorplan
# -------------------------------------------------------

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = unit

# IO Placer pin layers
export IO_PLACER_H = met3
export IO_PLACER_V = met2

# Define default PDN config
export PDN_TCL ?= $(PLATFORM_DIR)/pdn.tcl

# Endcap and Welltie cells
export TAP_CELL_NAME = sky130_fd_sc_hs__tapvpwrvgnd_1
export TAPCELL_TCL ?= $(PLATFORM_DIR)/tapcell.tcl

export MACRO_PLACE_HALO ?= 40 40
export MACRO_PLACE_CHANNEL ?= 80 80

#---------------------------------------------------------
# Place
# --------------------------------------------------------
export PLACE_DENSITY ?= 0.50

# ---------------------------------------------------------
#  Route
# ---------------------------------------------------------
# FastRoute options
export MIN_ROUTING_LAYER = met1
export MAX_ROUTING_LAYER = met5
#
# Define fastRoute tcl
export FASTROUTE_TCL ?= $(PLATFORM_DIR)/fastroute.tcl


# KLayout technology file
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/$(PLATFORM).lyt
#
# Rules for metal fill
export FILL_CONFIG = $(PLATFORM_DIR)/fill.json
#
# Template definition for power grid analysis
export TEMPLATE_PGA_CFG ?= $(PLATFORM_DIR)/template_pga.cfg

# OpenRCX extRules
export RCX_RULES = $(PLATFORM_DIR)/rcx_patterns.rules
# ---------------------------------------------------------
#  IR Drop
# ---------------------------------------------------------

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  ?= "VDD 1.8"
export GND_NETS_VOLTAGES  ?= "VSS 0.0"
export IR_DROP_LAYER ?= met1
