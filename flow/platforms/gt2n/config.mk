# GT2N PDK platform - 2nm GAAFET with BSPDN (backside power)
# Uses w31 LVT cells at the tt 0.7V/25C corner. Collateral lives entirely
# under this platform dir.

export PROCESS = 2

#-----------------------------------------------------
# Tech/Libs
#-----------------------------------------------------
export TECH_LEF = $(PLATFORM_DIR)/lef/gt2_tech.lef
export SC_LEF   = $(PLATFORM_DIR)/lef/gt2_6t_w31_lvt.lef

export LIB_FILES = $(PLATFORM_DIR)/lib/gt2_6t_w31_lvt_tt_0p7v25c.lib \
                   $(ADDITIONAL_LIBS)
export GDS_FILES = $(PLATFORM_DIR)/gds/gt2_6t_std_cells_w31_lvt.gds \
                   $(ADDITIONAL_GDS)

# Cells that should not be used in synthesis/optimization
export DONT_USE_CELLS = gt2_6t_filler_w31_lvt gt2_6t_tapbspdn_w31_lvt \
                       gt2_6t_tapfspdn_w31_lvt gt2_6t_decapcc_w31_lvt \
                       gt2_6t_tiehigh_w31_lvt gt2_6t_tielow_w31_lvt

# Fill cells used in fill cell insertion
export FILL_CELLS ?= gt2_6t_filler_w31_lvt gt2_6t_decapcc_w31_lvt

#-----------------------------------------------------
# Yosys / synthesis
#-----------------------------------------------------
export SYNTH_MINIMUM_KEEP_SIZE ?= 10000

export TIEHI_CELL_AND_PORT = gt2_6t_tiehigh_w31_lvt Y
export TIELO_CELL_AND_PORT = gt2_6t_tielow_w31_lvt  Y

export MIN_BUF_CELL_AND_PORTS = gt2_6t_buf_x1_w31_lvt A Y

# No latch/adder cells in this library; skip those map files
export LATCH_MAP_FILE   =
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate.v
export ADDER_MAP_FILE   =

export ABC_DRIVER_CELL = gt2_6t_buf_x1_w31_lvt
# Cap value derived from inv_x1 input cap (~0.5 fF). Multiply by 4.
export ABC_LOAD_IN_FF = 2.0

#--------------------------------------------------------
# Floorplan
#--------------------------------------------------------
export PLACE_SITE = gt2_6t

# IO pin placement layers
export IO_PLACER_H ?= M2
export IO_PLACER_V ?= M3

# Define default PDN config
export PDN_TCL ?= $(PLATFORM_DIR)/pdn.tcl

# Endcap and Welltie cells
export TAPCELL_TCL ?= $(PLATFORM_DIR)/tapcell.tcl
export TAP_CELL_NAME = gt2_6t_tapbspdn_w31_lvt

export MACRO_PLACE_HALO ?= 1.0 1.0

#---------------------------------------------------------
# Place
#---------------------------------------------------------
export PLACE_DENSITY ?= 0.40

#---------------------------------------------------------
# Route
#---------------------------------------------------------
export MIN_ROUTING_LAYER = M2
export MIN_CLK_ROUTING_LAYER = M3
export MAX_ROUTING_LAYER = M5

export FASTROUTE_TCL ?= $(PLATFORM_DIR)/fastroute.tcl

# KLayout technology file (drives GDS export)
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/gt2.lyt

#---------------------------------------------------------
# IR Drop
#---------------------------------------------------------
export PWR_NETS_VOLTAGES ?= vdd 0.7
export GND_NETS_VOLTAGES ?= vss 0.0
export IR_DROP_LAYER ?= BPR
