# Process node
export PROCESS = 7

# Rules for metal fill
export FILL_CONFIG = $(PLATFORM_DIR)/fill.json

# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_R H
export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_R L

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_R A Y
#export MIN_BUF_CELL_AND_PORTS  = BUFx4_ASAP7_75t_R A Y

# Resizer hold buffer
export HOLD_BUF_CELL           = BUFx2_ASAP7_75t_R
#export HOLD_BUF_CELL           = BUFx4_ASAP7_75t_R

# Used in synthesis
export MAX_FANOUT              = 100

# Blackbox verilog file
# List all standard cells and cells yosys should treat as blackboxes here
#export BLACKBOX_V_FILE = $(PLATFORM_DIR)/asap7sc7p5t_27_R_1x.blackbox.v
export BLACKBOX_V_FILE = $(PLATFORM_DIR)/merged_blackbox.v

# Yosys mapping files
export LATCH_MAP_FILE = $(PLATFORM_DIR)/cells_latch.v
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate.v
export BLACKBOX_MAP_TCL = $(PLATFORM_DIR)/blackbox_map.tcl

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = asap7sc7p5t

# Track information for generating DEF tracks
export TRACKS_INFO_FILE = $(PLATFORM_DIR)/tracks.info
#export TRACKS_INFO_FILE = $(PLATFORM_DIR)/tracks2.info

export IP_GLOBAL_CFG = $(PLATFORM_DIR)/IP_global.cfg

#export TECH_LEF = $(PLATFORM_DIR)/lef/asap7_tech_1x_201209.lef
export TECH_LEF = $(PLATFORM_DIR)/lef/asap7_tech_1x_201209_mod.lef
export SC_LEF = $(PLATFORM_DIR)/lef/asap7sc7p5t_27_R_1x_201211.lef
export ADDITIONAL_LEFS += 
#export ADDITIONAL_LEFS += $(PLATFORM_DIR)/lef/asap7sc7p5t_27_SRAM_1x_201211.lef \
													$(PLATFORM_DIR)/lef/asap7sc7p5t_27_L_1x_201211.lef \
													$(PLATFORM_DIR)/lef/asap7sc7p5t_27_SL_1x_201211.lef

#export LIB_FILES = $(PLATFORM_DIR)/lib/mod.lib \
									 $(ADDITIONAL_LIBS)
export LIB_FILES = $(PLATFORM_DIR)/lib/asap7_rvt_tt_merged.lib \
									 $(ADDITIONAL_LIBS)
#export LIB_FILES = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_RVT_TT_nldm_201020.lib \
									 $(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_RVT_TT_nldm_201020.lib \
									 $(PLATFORM_DIR)/lib/asap7sc7p5t_OA_RVT_TT_nldm_201020.lib \
									 $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib \
									 $(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_TT_nldm_201020.lib \
                   $(ADDITIONAL_LIBS)

#export LIB_FILES = $(PLATFORM_DIR)/lib/temp/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib \
                   $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard $(PLATFORM_DIR)/gds/*) \
                   $(ADDITIONAL_GDS)

# Cell padding in SITE widths to ease rout-ability.  Applied to both sides
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# Endcap and Welltie cells
export TAPCELL_TCL = $(PLATFORM_DIR)/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL            = BUFx4_ASAP7_75t_R
#export CTS_TECH_DIR   = $(PLATFORM_DIR)/tritonCTS/

# FastRoute options
export MIN_ROUTING_LAYER = 1
export MAX_ROUTING_LAYER = 9

# IO Pin fix margin
export IO_PIN_MARGIN = 70

# resizer repair_long_wires -max_length
# This number is random because there are no RC values -cherry
export MAX_WIRE_LENGTH = 1000

# KLayout layer properties
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/$(PLATFORM).lyt

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS          =  SDF* ICG* 

# Cells with strength <= 1 have difficult pin access
export DONT_USE_CELLS += OAI21xp* AOI21xp* OAI21x1* AOI21x1* A2O1A1O1Ixp* A2O1A1O1Ix1* MAJIxp* NAND2x1* AO21x1* AOI22xp* AOI22x1* AOI211xp* AOI31xp* A2O1A1Ixp* HB4xp* HB3xp* HB2xp* HB1xp*

#export DONT_USE_CELLS += DFFHQNx1* DFFHQNx2*

# Fill cells used in fill cell insertion
export FILL_CELLS = FILLER*

# Define default PDN config
#TODO
export PDN_CFG ?= $(PLATFORM_DIR)/pdn.cfg

export PLACE_DENSITY ?= 0.40

# IO Placer pin layers
export IO_PLACER_H = 2
export IO_PLACER_V = 3

# Set yosys-abc clock period to first "-period" found in sdc file
export ABC_CLOCK_PERIOD_IN_PS ?= $(shell grep -E -o -m 1 "\-period\s+\S+" $(SDC_FILE) | awk '{print $$2}')
export ABC_DRIVER_CELL = BUFx2_ASAP7_75t_R
#export ABC_DRIVER_CELL = BUFx4_ASAP7_75t_R
# BUFx2_ASAP7_75t_R, pin (A) = 0.534279. Arbitrarily multiply by 4
# BUFx4_ASAP7_75t_R, pin (A) = 0.538751. Arbitrarily multiply by 4
export ABC_LOAD_IN_FF = 2.137116
#export ABC_LOAD_IN_FF = 2.155004

# adjustment parameter for placer and global router's routability-driven loop
#
# if routing resources are highly reduced in global router (e.g. higher value in below)
# placer will bloat lots of cells in each RD iteration and cause unstableness.
#
# will be used in script/global_place.tcl
export REPLACE_FASTROUTE_RESOURCE_ADJ_23=0.5
export REPLACE_FASTROUTE_RESOURCE_ADJ_OTHER=0.2

# TritonCTS options
export CTS_BUF_LIST     = BUFx4_ASAP7_75t_R

#TODO
export CTS_SQR_CAP      = 2.28541e-4
export CTS_SQR_RES      = 1.832146e-0
export CTS_SLEW_INTER   = 7.5e-13
export CTS_CAP_INTER    = 65.0e-17
export CTS_MAX_SLEW     = 1.77e-9
export CTS_MAX_CAP      = 0.968693e-12

export CTS_BUF_DISTANCE = 60
