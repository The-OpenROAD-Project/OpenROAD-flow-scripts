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
export BLACKBOX_V_FILE = ./platforms/$(PLATFORM)/NangateOpenCellLibrary.blackbox.v

# Yosys mapping files
export LATCH_MAP_FILE = ./platforms/$(PLATFORM)/cells_latch.v
export CLKGATE_MAP_FILE = ./platforms/$(PLATFORM)/cells_clkgate.v
export BLACKBOX_MAP_TCL = ./platforms/$(PLATFORM)/blackbox_map.tcl

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = FreePDK45_38x28_10R_NP_162NW_34O

# Track information for generating DEF tracks
export TRACKS_INFO_FILE = ./platforms/$(PLATFORM)/tracks.info

export IP_GLOBAL_CFG = ./platforms/$(PLATFORM)/IP_global.cfg

export TECH_LEF = ./platforms/$(PLATFORM)/lef/NangateOpenCellLibrary.tech.lef
export SC_LEF = ./platforms/$(PLATFORM)/lef/NangateOpenCellLibrary.macro.mod.lef

export LIB_FILES = ./platforms/$(PLATFORM)/lib/NangateOpenCellLibrary_typical.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard ./platforms/$(PLATFORM)/gds/*.gds) \
                     $(ADDITIONAL_GDS_FILES)

# Cell padding in SITE widths to ease rout-ability
export CELL_PAD_IN_SITES = 5

# Endcap and Welltie cells
export TAPCELL_TCL = ./platforms/$(PLATFORM)/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL   = BUF_X4
export CTS_TECH_DIR   = ./platforms/$(PLATFORM)/tritonCTS

# FastRoute options
export MAX_ROUTING_LAYER = 10

# IO Pin fix margin
export IO_PIN_MARGIN = 70

# Layer to use for parasitics estimations
export WIRE_RC_LAYER = metal3

# Resizer options
export RESIZER_BUF_CELL = BUF_X4

# KLayout technology file
export KLAYOUT_TECH_FILE = ./platforms/$(PLATFORM)/FreePDK45.lyt

# KLayout DRC ruledeck
export KLAYOUT_DRC_FILE = ./platforms/$(PLATFORM)/drc/FreePDK45.lydrc

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS = FILLCELL_X1 AOI211_X1 OAI211_X1

# Fill cells used in fill cell insertion
export FILL_CELLS = FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32

# Define default PDN config
export PDN_CFG ?= ./platforms/$(PLATFORM)/pdn.cfg

# Template definition for power grid analysis
export TEMPLATE_PGA_CFG ?= ./platforms/nangate45/template_pga.cfg

export PLACE_DENSITY ?= 0.30

# IO Placer pin layers
export IO_PLACER_H = 3
export IO_PLACER_V = 2
