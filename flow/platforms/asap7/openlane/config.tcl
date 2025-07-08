# tclint-disable line-length

# Process node
set ::env(PROCESS) 7
set ::env(DEF_UNITS_PER_MICRON) 1000

# Placement site for core cells
# This can be found in the technology lef

set ::env(VDD_PIN) "VDD"
set ::env(GND_PIN) "VSS"

set ::env(STD_CELL_POWER_PINS) "VDD"
set ::env(STD_CELL_GROUND_PINS) "VSS"

# Technology LEF
set ::env(TECH_LEF) "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/techlef/asap7_tech_1x_201209.lef"
set ::env(CELLS_LEF) [glob "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lef/*.lef"]
set ::env(GDS_FILES) [glob "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/gds/*.gds"]
set ::env(STD_CELL_LIBRARY_CDL) "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/cdl/$::env(STD_CELL_LIBRARY).cdl"

set ::env(GPIO_PADS_LEF) ""

set ::env(GPIO_PADS_VERILOG) ""

# Optimization library
set ::env(TECH_LEF_OPT) "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY_OPT)/techlef/$::env(STD_CELL_LIBRARY_OPT).tlef"
set ::env(CELLS_LEF_OPT) [glob "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY_OPT)/lef/*.lef"]
set ::env(GDS_FILES_OPT) [glob "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY_OPT)/gds/*.gds"]
set ::env(STD_CELL_LIBRARY_OPT_CDL) "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY_OPT)/cdl/$::env(STD_CELL_LIBRARY_OPT).cdl"


# Optimization library slowest corner
set tmp $::env(STD_CELL_LIBRARY)
set ::env(STD_CELL_LIBRARY) $::env(STD_CELL_LIBRARY_OPT)
source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY_OPT)/config.tcl"
set ::env(LIB_SLOWEST_OPT) $::env(LIB_SLOWEST)
set ::env(STD_CELL_LIBRARY) $tmp
source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/config.tcl"

set ::env(GPIO_PADS_LEF_CORE_SIDE) ""

# magic setup
#set ::env(MAGIC_MAGICRC) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.magicrc"
#set ::env(MAGIC_TECH_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech"
set ::env(RUN_MAGIC) false
set ::env(RUN_KLAYOUT_XOR) false ;# nothing to XOR with from magic

# Klayout setup
set ::env(KLAYOUT_TECH) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/$::env(PDK).lyt"
set ::env(KLAYOUT_PROPERTIES) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/$::env(PDK).lyp"
#set ::env(KLAYOUT_DRC_TECH_SCRIPT) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/$::env(PDK)_mr.drc"
#set ::env(KLAYOUT_DRC_TECH) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/$::env(PDK).lydrc"

# netgen setup
#set ::env(NETGEN_SETUP_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/netgen/sky130A_setup.tcl"

set ::env(FP_TAPCELL_DIST) 25

# Tracks info - suppress .info conversion and use make_tracks.tcl directly
set ::env(TRACKS_INFO_FILE) ""
set ::env(TRACKS_INFO_FILE_PROCESSED) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/make_tracks.tcl"

# Latch mapping
set ::env(SYNTH_LATCH_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/cells_latch.v"

# Tri-state buffer mapping
set ::env(TRISTATE_BUFFER_MAP) ""

# Full adder mapping
set ::env(FULL_ADDER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/cells_adders.v"

# Ripple carry adder mapping
set ::env(RIPPLE_CARRY_ADDER_MAP) ""

# Carry select adder mapping
set ::env(CARRY_SELECT_ADDER_MAP) ""

# Default No Synth List
set ::env(NO_SYNTH_CELL_LIST) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/no_synth.cells"

# Default DRC Exclude List
set ::env(DRC_EXCLUDE_CELL_LIST) ""

# DRC Exclude List for Optimization library
set ::env(DRC_EXCLUDE_CELL_LIST_OPT) ""

# Open-RCX Rules File
set ::env(RCX_RULES) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rcx_patterns.rules"

# VIAS RC Values
set ::env(VIAS_RC) "\
    V1 1.00E-02,\
    V2 1.00E-02,\
    V3 1.00E-02,\
    V4 1.00E-02,\
    V5 1.00E-02,\
    V6 1.00E-02,\
    V7 1.00E-02,\
    V8 1.00E-02,\
    V9 1.00E-02"

# Layer RC Values
set ::env(LAYERS_RC) "\
	M1 1.1368e-01 1.3889e-01,\
	M2 1.3426e-01 2.4222e-02,\
	M3 1.2918e-01 2.4222e-02,\
	M4 1.1396e-01 1.6778e-02,\
	M5 1.3323e-01 1.4677e-02,\
	M6 1.1575e-01 1.0371e-02,\
	M7 1.3293e-01 9.6720e-03,\
	M8 1.1822e-01 7.4310e-03,\
	M9 1.3497e-01 6.8740e-03"

# Extra PDN configs
set ::env(FP_PDN_RAILS_LAYER) met1
set ::env(FP_PDN_LOWER_LAYER) met4
set ::env(FP_PDN_UPPER_LAYER) met5
set ::env(FP_PDN_RAIL_OFFSET) 0
set ::env(FP_PDN_VWIDTH) 1.6
set ::env(FP_PDN_HWIDTH) 1.6
set ::env(FP_PDN_VSPACING) 1.7
set ::env(FP_PDN_HSPACING) 1.7

# Core Ring PDN defaults
set ::env(FP_PDN_CORE_RING_VWIDTH) 1.6
set ::env(FP_PDN_CORE_RING_HWIDTH) 1.6
set ::env(FP_PDN_CORE_RING_VSPACING) 1.7
set ::env(FP_PDN_CORE_RING_HSPACING) 1.7
set ::env(FP_PDN_CORE_RING_VOFFSET) 6
set ::env(FP_PDN_CORE_RING_HOFFSET) 6

# PDN Macro blockages list
set ::env(MACRO_BLOCKAGES_LAYER) "li1 met1 met2 met3 met4"

# Used for parasitics estimation, IR drop analysis, etc
set ::env(WIRE_RC_LAYER) "M3"
set ::env(DATA_WIRE_RC_LAYER) "M3"
set ::env(CLOCK_WIRE_RC_LAYER) "M3"

# I/O Layer info
set ::env(FP_IO_HLAYER) "M4"
set ::env(FP_IO_VLAYER) "M5"

# Routing Layer Info
set ::env(GLB_RT_LAYER_ADJUSTMENTS) "0.5,0.5,0.5,0.5,0.5,0.5"

set ::env(RT_MIN_LAYER) "M2"
set ::env(RT_MAX_LAYER) "M7"

# Use OR default
set ::env(FP_IO_MIN_DISTANCE) ""

# Asap7 has no antenna rules nor diode cells
set ::env(DIODE_INSERTION_STRATEGY) 0
