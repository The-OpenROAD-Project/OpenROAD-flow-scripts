# Process node
export PROCESS = 130


# Rules for metal fill
export FILL_CONFIG = ./platforms/$(PLATFORM)/fill.json

# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 HI
export TIELO_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 LO

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = sky130_fd_sc_hs__buf_4 A X

# Used in synthesis
export MAX_FANOUT ?= 100

# Blackbox verilog file
# List all standard cells and cells yosys should treat as blackboxes here
export BLACKBOX_V_FILE = ./platforms/$(PLATFORM)/sky130_fd_sc_hs.blackbox.v

# Yosys mapping files
export LATCH_MAP_FILE = ./platforms/$(PLATFORM)/cells_latch_hs.v
export CLKGATE_MAP_FILE = ./platforms/$(PLATFORM)/cells_clkgate_hs.v
export BLACKBOX_MAP_TCL = ./platforms/$(PLATFORM)/blackbox_map.tcl

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = unit

export MACRO_PLACE_HALO ?= 1 1
export MACRO_PLACE_CHANNEL ?= 80 80

export TECH_LEF = ./platforms/$(PLATFORM)/lef/sky130_fd_sc_hs.tlef
export SC_LEF = ./platforms/$(PLATFORM)/lef/sky130_fd_sc_hs_merged.lef

export LIB_FILES = ./platforms/$(PLATFORM)/lib/sky130_fd_sc_hs__tt_025C_1v80.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard ./platforms/$(PLATFORM)/gds/*.gds) \
                     $(ADDITIONAL_GDS_FILES)

# Cell padding in SITE widths to ease rout-ability
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4

# Endcap and Welltie cells
export TAPCELL_TCL = ./platforms/$(PLATFORM)/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL   = sky130_fd_sc_hs__buf_1
export CTS_MAX_SLEW   = 1.5e-9
export CTS_MAX_CAP    = .2e-12
export CTS_TECH_DIR   = ./platforms/$(PLATFORM)/tritonCTShs

# FastRoute options
export MIN_ROUTING_LAYER = 2
export MAX_ROUTING_LAYER = 6

# IO Pin fix margin
export IO_PIN_MARGIN = 70

# Layer to use for parasitics estimations
export WIRE_RC_LAYER = met3

# KLayout technology file
export KLAYOUT_TECH_FILE = ./platforms/$(PLATFORM)/$(PLATFORM).lyt

# Dont use cells to ease congestion
# Specify at least one filler cell if none

export DONT_USE_CELLS += 

# Define ABC driver and load
export ABC_DRIVER_CELL = sky130_fd_sc_hs__buf_1
export ABC_LOAD_IN_FF = 5
export ABC_CLOCK_PERIOD_IN_PS = 10

# Define default PDN config
export PDN_CFG ?= ./platforms/$(PLATFORM)/pdn.cfg

# Define fastRoute tcl
export FASTROUTE_TCL = ./platforms/$(PLATFORM)/fastroute.tcl

# Template definition for power grid analysis
export TEMPLATE_PGA_CFG ?= ./platforms/sky130/template_pga.cfg

export PLACE_DENSITY ?= 0.50

# Define Hold Buffer
export HOLD_BUF_CELL = sky130_fd_sc_hs__buf_1

# IO Placer pin layers
export IO_PLACER_H = 4
export IO_PLACER_V = 3

# keep with gf
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# Define fill cells
export FILL_CELLS = sky130_fd_sc_hs__fill_1 sky130_fd_sc_hs__fill_2 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_8

# resizer repair_long_wires -max_length
export MAX_WIRE_LENGTH = 21000

