
set ::env(DESIGN_NAME) "serv_rf_top"

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(SDC_FILE)  [glob $::env(DESIGN_DIR)/src/*.sdc]

set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/src/*.lef]
set ::env(VERILOG_FILES_BLACKBOX) [glob $::env(DESIGN_DIR)/src/*.bb.v]
set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_CORE_RING) 1

set ::env(CELL_PAD) "6"
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(PL_DIAMOND_SEARCH_HEIGHT) "500"
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) "0 0 20000 20000"
#set ::env(ROUTING_CORES) "8"
#set ::env(ALLOW_CONGESTION) "1"

# Fill this
set ::env(CLOCK_PERIOD) "100.000"
set ::env(CLOCK_PORT) "clk"
set ::env(TAP_DECAP_INSERTION) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

#START Extra Options
set ::env(FP_PDN_CHECK_NODES) 0
#~END Extra Options
set ::env(PDN_CFG) [glob $::env(DESIGN_DIR)/pdn.tcl]
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/src/*.lef]

