# Process node
export PROCESS = ihp-sg13g2

#-----------------------------------------------------
# Tech/Libs
# ----------------------------------------------------
export TECH_LEF = $(PLATFORM_DIR)/lef/sg13g2_tech.lef
export SC_LEF = $(PLATFORM_DIR)/lef/sg13g2_stdcell.lef

export LIB_FILES = $(PLATFORM_DIR)/lib/sg13g2_stdcell_typ_1p20V_25C.lib \
	                  $(ADDITIONAL_LIBS)
export GDS_FILES = $(PLATFORM_DIR)/gds/sg13g2_stdcell.gds \
	                  $(ADDITIONAL_GDS)

# Dont use cells to ease congestion
# Specify at least one filler cell if none

# The *probe* are for inserting probe points and have metal shapes
# on all layers.
# *lpflow* cells are for multi-power domains
export DONT_USE_CELLS += \
sg13g2_antennanp \
sg13g2_lgcp_1 \
sg13g2_sighold \
sg13g2_slgcp_1 \
sg13g2_dfrbp_2 


# Define fill cells
export FILL_CELLS = sg13g2_fill_1 sg13g2_fill_2 sg13g2_fill_4 sg13g2_fill_8
# -----------------------------------------------------
#  Yosys
#  ----------------------------------------------------
# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = sg13g2_tiehi L_HI
export TIELO_CELL_AND_PORT = sg13g2_tielo L_LO

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = sg13g2_buf_1 A X

# Yosys mapping files
export LATCH_MAP_FILE = $(PLATFORM_DIR)/cells_latch.v
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate.v

# Define ABC driver and load
export ABC_DRIVER_CELL = sg13g2_buf_4
export ABC_LOAD_IN_FF = 6.0
# Set yosys-abc clock period to first "clk_period" value or "-period" value found in sdc file
export ABC_CLOCK_PERIOD_IN_PS ?= $(shell sed -nE "s/^set clk_period (.+)|.* -period (.+) .*/\1\2/p" $(SDC_FILE) | head -1 | awk '{print $$1*1000}')
#--------------------------------------------------------
# Floorplan
# -------------------------------------------------------

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = CoreSite

# IO Placer pin layers
export IO_PLACER_H = Metal2
export IO_PLACER_V = Metal3

# Define default PDN config
export PDN_TCL ?= $(PLATFORM_DIR)/pdn.tcl

# There are no Endcap and Welltie cells in this PDK, so
# `cut_rows` has to be called from the tapcell script.
export TAPCELL_TCL = $(PLATFORM_DIR)/tapcell.tcl

export MACRO_PLACE_HALO ?= 40 40
export MACRO_PLACE_CHANNEL ?= 80 80

#---------------------------------------------------------
# Place
# --------------------------------------------------------
# default cell padding for cells 
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT ?= 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT ?= 1
export PLACE_DENSITY ?= 0.65
# --------------------------------------------------------
#  CTS
#  -------------------------------------------------------
# TritonCTS options
export CTS_BUF_CELL   ?= sg13g2_buf_2
# ---------------------------------------------------------
#  Route
# ---------------------------------------------------------
# FastRoute options
export MIN_ROUTING_LAYER 		?= Metal2
export MAX_ROUTING_LAYER 		?= Metal5
#export VIA_IN_PIN_MIN_LAYER ?= Metal1
#export VIA_IN_PIN_MAX_LAYER ?= Metal1
#export DISABLE_VIA_GEN      ?= 1
#
# Define fastRoute tcl
export FASTROUTE_TCL ?= $(PLATFORM_DIR)/fastroute.tcl

# KLayout technology file
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/sg13g2.lyt
#
# Rules for metal fill
export FILL_CONFIG = $(PLATFORM_DIR)/fill.json
#
# Template definition for power grid analysis
#export TEMPLATE_PGA_CFG ?= $(PLATFORM_DIR)/template_pga.cfg

# OpenRCX extRules
export RCX_RULES = $(PLATFORM_DIR)/rcx_patterns.rules

# ---------------------------------------------------------
#  IR Drop
# ---------------------------------------------------------

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  ?= "VDD 1.2"
export GND_NETS_VOLTAGES  ?= "VSS 0.0"
export IR_DROP_LAYER ?= Metal1

# DRC Check
export KLAYOUT_DRC_FILE = $(PLATFORM_DIR)/drc/sg13g2.lydrc

#LVS Check
export CDL_FILE = $(PLATFORM_DIR)/cdl/sg13g2_stdcell.cdl
#export KLAYOUT_LVS_FILE = $(PLATFORM_DIR)/lvs/$(PLATFORM).lylvs
