# GT2N PDK platform - 2nm GAAFET with BSPDN (backside power)
# Collateral lives entirely under this platform dir; all corners shipped
# at tt 0.7V/25C only (SS/FF are upstream-under-development).
#
# Multi-W / multi-Vt setup (Cartesian product of two ordered lists,
# modeled on asap7's ASAP7_USE_VT). All loaded (W, Vt) combos share
# the same gt2_6t site (0.042 x 0.144) and the same tech LEF, so they
# can coexist in a single block and synthesis can size + W/Vt-trade
# across the full menu:
#
#   GT2N_USE_W   ordered list of nanosheet-width families to load.
#                w13 = 13 nm sheet (lower drive / lower cap / lower
#                leakage); w31 = 31 nm sheet. Default w31 only.
#   GT2N_USE_VT  ordered list of Vt flavors to load. Default loads
#                all five (lvt hvt svt ulvt elvt) so ABC has the
#                full menu without forcing the user to enumerate.
#
# The first word of each list is the primary value. The (primary W,
# primary Vt) tuple drives canonical single-cell references (tap,
# tiehi/tielo, buffer, ABC driver). The rest of the Cartesian product
# rides along as additional LEF / lib / GDS. Reorder either list to
# pick a different synthesis default.

export PROCESS = 2

export GT2N_USE_W  ?= w31 w13
export GT2N_USE_VT ?= lvt hvt svt ulvt elvt

export PRIMARY_W  = $(word 1, $(GT2N_USE_W))
export OTHER_W    = $(wordlist 2, $(words $(GT2N_USE_W)),  $(GT2N_USE_W))
export PRIMARY_VT = $(word 1, $(GT2N_USE_VT))
export OTHER_VT   = $(wordlist 2, $(words $(GT2N_USE_VT)), $(GT2N_USE_VT))

# Cartesian product of (W, Vt) used by every cell-name template below.
ALL_WVT     = $(foreach w,$(GT2N_USE_W), $(foreach vt,$(GT2N_USE_VT),$(w)_$(vt)))
PRIMARY_WVT = $(PRIMARY_W)_$(PRIMARY_VT)
OTHER_WVT   = $(filter-out $(PRIMARY_WVT),$(ALL_WVT))

#-----------------------------------------------------
# Tech/Libs
#-----------------------------------------------------
export TECH_LEF = $(PLATFORM_DIR)/lef/gt2_tech.lef
export SC_LEF   = $(PLATFORM_DIR)/lef/gt2_6t_$(PRIMARY_WVT).lef
export ADDITIONAL_LEFS += $(foreach wvt,$(OTHER_WVT), \
                            $(PLATFORM_DIR)/lef/gt2_6t_$(wvt).lef)

export LIB_FILES = $(PLATFORM_DIR)/lib/gt2_6t_$(PRIMARY_WVT)_tt_0p7v25c.lib \
                   $(foreach wvt,$(OTHER_WVT), \
                     $(PLATFORM_DIR)/lib/gt2_6t_$(wvt)_tt_0p7v25c.lib) \
                   $(ADDITIONAL_LIBS)

export GDS_FILES = $(PLATFORM_DIR)/gds/gt2_6t_std_cells_$(PRIMARY_WVT).gds \
                   $(foreach wvt,$(OTHER_WVT), \
                     $(PLATFORM_DIR)/gds/gt2_6t_std_cells_$(wvt).gds) \
                   $(ADDITIONAL_GDS)

# Cells that should not be used in synthesis/optimization (tap / filler
# / decap / tie across every loaded W,Vt combo).
export DONT_USE_CELLS = $(foreach wvt,$(ALL_WVT), \
                          gt2_6t_filler_$(wvt) \
                          gt2_6t_tapfspdn_$(wvt) \
                          gt2_6t_tapbspdn_$(wvt) \
                          gt2_6t_decapcc_$(wvt) \
                          gt2_6t_tiehigh_$(wvt) \
                          gt2_6t_tielow_$(wvt))

# Fill cells used in fill cell insertion.
export FILL_CELLS ?= $(foreach wvt,$(ALL_WVT), \
                       gt2_6t_filler_$(wvt) \
                       gt2_6t_decapcc_$(wvt))

#-----------------------------------------------------
# Yosys / synthesis
#-----------------------------------------------------
export SYNTH_MINIMUM_KEEP_SIZE ?= 10000

export TIEHI_CELL_AND_PORT = gt2_6t_tiehigh_$(PRIMARY_WVT) Y
export TIELO_CELL_AND_PORT = gt2_6t_tielow_$(PRIMARY_WVT)  Y

export MIN_BUF_CELL_AND_PORTS = gt2_6t_buf_x1_$(PRIMARY_WVT) A Y

# No latch/adder cells in this library; skip those map files
export LATCH_MAP_FILE   =
export CLKGATE_MAP_FILE = $(PLATFORM_DIR)/cells_clkgate.v
export ADDER_MAP_FILE   =

export ABC_DRIVER_CELL = gt2_6t_buf_x1_$(PRIMARY_WVT)
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
# The PDN here is backside-only, so pick the backside-PDN tap variant
# (BPR pins only, half-width, no M1 shapes).
export TAP_CELL_NAME = gt2_6t_tapbspdn_$(PRIMARY_WVT)

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
export MAX_ROUTING_LAYER = M13

export FASTROUTE_TCL ?= $(PLATFORM_DIR)/fastroute.tcl

# KLayout technology file (drives GDS export)
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/gt2.lyt

#---------------------------------------------------------
# IR Drop
#---------------------------------------------------------
export PWR_NETS_VOLTAGES ?= vdd 0.7
export GND_NETS_VOLTAGES ?= vss 0.0
export IR_DROP_LAYER ?= BPR
