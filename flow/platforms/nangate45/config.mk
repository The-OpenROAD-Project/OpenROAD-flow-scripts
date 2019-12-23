# Process node
export PROCESS = 45

# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = LOGIC1_X1 Z
export TIELO_CELL_AND_PORT = LOGIC0_X1 Z

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = BUF_X1 A Z

# Used in synthesis
export MAX_FANOUT = 100

# Blackbox verilog file
# List all standard cells and cells yosys should treat as blackboxes here
export BLACKBOX_V_FILE = ./platforms/nangate45/NangateOpenCellLibrary.blackbox.v

# Latch mapping file
# Yosys latch mapping file
export LATCH_MAP_FILE = ./platforms/nangate45/cells_latch.v

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = FreePDK45_38x28_10R_NP_162NW_34O

# Track information for generating DEF tracks
export TRACKS_INFO_FILE = ./platforms/nangate45/tracks.info

export IP_GLOBAL_CFG = ./platforms/nangate45/IP_global.cfg

export TECH_LEF = ./platforms/nangate45/NangateOpenCellLibrary.tech.lef
export SC_LEF = ./platforms/nangate45/NangateOpenCellLibrary.macro.mod.lef

export LIB_FILES = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard ./platforms/nangate45/gds/*) \
                     $(ADDITIONAL_GDS_FILES)

# Cell padding in SITE widths to ease rout-ability
export CELL_PAD_IN_SITES = 8

# Endcap and Welltie cells
# Use fillers if kit doesn't have them
export ENDCAP_CELL   = FILLCELL_X1
export WELLTIE_CELL  = FILLCELL_X1
export WELLTTAP_RULE = 120

# TritonCTS options
export CTS_DUMMY_CELL = BUF_X1
export CTS_BUF_CELL   = BUF_X4
export CTS_TECH_DIR   = ./platforms/nangate45/tritonCTS

# FastRoute Options
export MAX_ROUTING_LAYER = 10

# IO Pin fix margin
export IO_PIN_MARGIN = 70

# Layer to use for parasitics estimations
export WIRE_RC_LAYER = metal3

# Resizer options
export RESIZER_BUF_CELL = BUF_X4

# Magic technology file
export MAGIC_TECH_FILE = ./platforms/nangate45/magic.tech

# KLayout layer properties
export KLAYOUT_TECH_FILE = ./platforms/nangate45/FreePDK45.lyt

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS = FILLCELL_X1 AOI211_X1 OAI211_X1

# Define default PDN config
export PDN_CFG ?= ./platforms/nangate45/pdn.cfg

export PLACE_DENSITY ?= 0.70
