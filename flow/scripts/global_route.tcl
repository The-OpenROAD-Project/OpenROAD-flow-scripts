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
  if {[info exist env(MACRO_EXTENSION)]} {
    set_macro_extension $env(MACRO_EXTENSION)
  }
}

# The default behavior if the user didn't specify GLOBAL_ROUTE_ARGS is to
# produce a drc report every 5 iterations.
#
# If GLOBAL_ROUTE_ARGS is specified, then we do only what the
# GLOBAL_ROUTE_ARGS specifies.
global_route -guide_file $env(RESULTS_DIR)/route.guide \
               -congestion_report_file $env(REPORTS_DIR)/congestion.rpt \
               {*}[expr {[info exists ::env(GLOBAL_ROUTE_ARGS)] ? $::env(GLOBAL_ROUTE_ARGS) : \
               {-congestion_iterations 2 -congestion_report_iter_step 5 -verbose}}]


set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

if { [info exists ::env(RECOVER_POWER)] } {
  puts "Downsizing/switching to higher Vt  for non critical gates for power recovery"
  puts "Percent of paths optimized $::env(RECOVER_POWER)"  
  report_tns
  report_wns
  report_power
  repair_timing -recover_power $::env(RECOVER_POWER)
  report_tns
  report_wns
  report_power
}

source $env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "global route"

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"
# check_antennas -report_file $env(REPORTS_DIR)/antenna.log -report_violating_nets

# Write SDC to results with updated clock periods that are just failing.
# Use make target update_sdc_clock to install the updated sdc.
source [file join $env(SCRIPTS_DIR) "write_ref_sdc.tcl"]
if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $env(RESULTS_DIR)/5_1_grt.odb
}
