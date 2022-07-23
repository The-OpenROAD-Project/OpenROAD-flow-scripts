source $::env(SCRIPTS_DIR)/load.tcl
load_design 5_route.odb 5_route.sdc "Starting density fill"

set_propagated_clock [all_clocks]

# Delete routing obstructions for final DEF
source $::env(SCRIPTS_DIR)/deleteRoutingObstructions.tcl
deleteRoutingObstructions

density_fill -rules $::env(FILL_CONFIG)

write_db $::env(RESULTS_DIR)/6_1_fill.odb
write_verilog $::env(RESULTS_DIR)/6_1_fill.v
