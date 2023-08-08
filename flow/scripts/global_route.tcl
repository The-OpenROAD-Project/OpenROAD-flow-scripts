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
# first make an attempt with a few iterations, if this is a hard global
# route, start from scratch, try harder and logging. The goal here is to make
# ORFS handle the simple cases without fuzz and to make the harder
# cases more easily debuggable without having to go spelunking in Tcl.
#
# If GLOBAL_ROUTE_ARGS is specified, then we do only what the
# GLOBAL_ROUTE_ARGS specifies.
set common_args [list -guide_file $env(RESULTS_DIR)/route.guide \
                      -congestion_report_file $env(REPORTS_DIR)/congestion.rpt]
if {[info exists ::env(GLOBAL_ROUTE_ARGS)]} {
  global_route {*}$common_args {*}$::env(GLOBAL_ROUTE_ARGS)
} else {
  for {set i 0} {$i < 2} {incr i} {
    set congestion_args [list -verbose]
    if {$i == 1} {
      global_route {*}$common_args {*}$congestion_args -congestion_iterations 20 -congestion_report_iter_step 1
      break
    } else {
      try {
          global_route {*}$common_args {*}$congestion_args -congestion_iterations 5
          break
      } catch {
          puts "First attempt failed. Retrying, reporting each iteration..."
      }
    }
  }
}

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
