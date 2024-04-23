source $::env(SCRIPTS_DIR)/load.tcl
load_design 5_route.odb 5_route.sdc

if {![info exist ::env(SDC_IDEAL_CLOCK)]} {
    set_propagated_clock [all_clocks]
}

density_fill -rules $::env(FILL_CONFIG)

write_db $::env(RESULTS_DIR)/6_1_fill.odb
write_verilog $::env(RESULTS_DIR)/6_1_fill.v
