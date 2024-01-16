utl::set_metrics_stage "globalroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 4_cts.odb 4_cts.sdc

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
proc do_global_route {} {
  set all_args [concat [list -guide_file $::env(RESULTS_DIR)/route.guide \
    -congestion_report_file $::env(REPORTS_DIR)/congestion.rpt] \
    [expr {[info exists ::env(GLOBAL_ROUTE_ARGS)] ? $::env(GLOBAL_ROUTE_ARGS) : \
     {-congestion_iterations 30 -congestion_report_iter_step 5 -verbose}}]]

  puts "global_route [join $all_args " "]"

  global_route {*}$all_args
}

set result [catch {do_global_route} errMsg]
if {$result != 0} {
  write_db $::env(RESULTS_DIR)/5_1_grt-failed.odb
  error $errMsg
}

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

if {[info exist env(DONT_USE_CELLS)]} {
  set_dont_use $::env(DONT_USE_CELLS)
}

source $env(SCRIPTS_DIR)/report_metrics.tcl

if { ![info exists ::env(SKIP_INCREMENTAL_REPAIR)] } {
  report_metrics 5 "global route pre repair design"

  # Repair design using global route parasitics
  puts "Perform buffer insertion..."
  repair_design
  report_metrics 5 "global route post repair design"

  # Running DPL to fix overlapped instances
  # Run to get modified net by DPL
  global_route -start_incremental
  detailed_placement
  # Route only the modified net by DPL
  global_route -end_incremental -congestion_report_file $env(REPORTS_DIR)/congestion_post_repair_design.rpt

  # Repair timing using global route parasitics
  puts "Repair setup and hold violations..."
  estimate_parasitics -global_routing
  repair_timing
  report_metrics 5 "global route post repair timing"

  # Running DPL to fix overlapped instances
  # Run to get modified net by DPL
  global_route -start_incremental
  detailed_placement
  # Route only the modified net by DPL
  global_route -end_incremental -congestion_report_file $env(REPORTS_DIR)/congestion_post_repair_timing.rpt
}

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

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"

repair_antennas -iterations 5
check_placement -verbose
check_antennas -report_file $env(REPORTS_DIR)/antenna.log -report_violating_nets

estimate_parasitics -global_routing
report_metrics 5 "global route"

# Write SDC to results with updated clock periods that are just failing.
# Use make target update_sdc_clock to install the updated sdc.
source [file join $env(SCRIPTS_DIR) "write_ref_sdc.tcl"]

write_db $env(RESULTS_DIR)/5_1_grt.odb
