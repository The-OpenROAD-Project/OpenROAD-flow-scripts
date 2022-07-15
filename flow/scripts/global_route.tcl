utl::set_metrics_stage "globalroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 4_cts.odb 4_cts.sdc "Starting global routing"

if {[info exist env(PRE_GLOBAL_ROUTE)]} {
  source $env(PRE_GLOBAL_ROUTE)
}

if {[info exist env(FASTROUTE_TCL)]} {
  source $env(FASTROUTE_TCL)
} else {
  set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
  set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
  set_macro_extension 2
}

global_route -guide_file $env(RESULTS_DIR)/route.guide \
               -congestion_iterations 100 \
               -verbose

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

source $env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "global route"

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"
check_antennas -report_file $env(REPORTS_DIR)/antenna.log -report_violating_nets

# Write SDC to results with updated clock periods that are just failing.
# Use make target update_sdc_clock to install the updated sdc.
source [file join $env(SCRIPTS_DIR) "write_ref_sdc.tcl"]
if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $env(RESULTS_DIR)/5_1_grt.odb
}
