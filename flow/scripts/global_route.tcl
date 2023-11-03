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
               {-congestion_iterations 50 -congestion_report_iter_step 5 -verbose}}]


set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

if {[info exist env(DONT_USE_CELLS)]} {
  set_dont_use $::env(DONT_USE_CELLS)
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

source $env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "global route pre repair design"

# Repair design using global route parasitics
puts "Perform buffer insertion..."
set repair_design_args ""
if { [info exists ::env(CAP_MARGIN)] && $::env(CAP_MARGIN) > 0.0} {
  puts "Cap margin $::env(CAP_MARGIN)"
  append repair_design_args " -cap_margin $::env(CAP_MARGIN)"
}
if { [info exists ::env(SLEW_MARGIN)] && $::env(SLEW_MARGIN) > 0.0} {
  puts "Slew margin $::env(SLEW_MARGIN)"
  append repair_design_args " -slew_margin $::env(SLEW_MARGIN)"
}
# repair_design {*}$repair_design_args
repair_design
report_metrics "global route post repair design"

# Running DPL to fix overlapped instances
# Run to get modified net by DPL
global_route -start_incremental
detailed_placement
# Route only the modified net by DPL
global_route -end_incremental -congestion_report_file $env(REPORTS_DIR)/congestion_post_repair_design.rpt

# Repair timing using global route parasitics
puts "Repair setup and hold violations..."
estimate_parasitics -global_routing
# process user settings
set repair_timing_args ""
if { [info exists ::env(SETUP_SLACK_MARGIN)] && $::env(SETUP_SLACK_MARGIN) > 0.0} {
  puts "Setup slack margin $::env(SETUP_SLACK_MARGIN)"
  append repair_timing_args " -setup_margin $::env(SETUP_SLACK_MARGIN)"
}
if { [info exists ::env(HOLD_SLACK_MARGIN)] && $::env(HOLD_SLACK_MARGIN) > 0.0} {
  puts "Hold slack margin $::env(HOLD_SLACK_MARGIN)"
  append repair_timing_args " -hold_margin $::env(HOLD_SLACK_MARGIN)"
}

puts "TNS end percent $::env(TNS_END_PERCENT)"
append repair_timing_args " -repair_tns $::env(TNS_END_PERCENT)"

if { [info exists ::env(SKIP_PIN_SWAP)] } {
  puts "Skipping pin swapping during optimization"
  append repair_timing_args " -skip_pin_swap"
}

if { [info exists ::env(SKIP_GATE_CLONING)] } {
  puts "Skipping gate cloning during optimization"
  append repair_timing_args " -skip_gate_cloning"
}

# repair_timing {*}$repair_timing_args
repair_timing
report_metrics "global route post repair timing"

# Running DPL to fix overlapped instances
# Run to get modified net by DPL
global_route -start_incremental
detailed_placement
# Route only the modified net by DPL
global_route -end_incremental -congestion_report_file $env(REPORTS_DIR)/congestion_post_repair_timing.rpt

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

report_metrics "global route"

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"

repair_antennas -iterations 5
check_placement -verbose
check_antennas -report_file $env(REPORTS_DIR)/antenna.log -report_violating_nets

# Write SDC to results with updated clock periods that are just failing.
# Use make target update_sdc_clock to install the updated sdc.
source [file join $env(SCRIPTS_DIR) "write_ref_sdc.tcl"]
if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $env(RESULTS_DIR)/5_1_grt.odb
}
