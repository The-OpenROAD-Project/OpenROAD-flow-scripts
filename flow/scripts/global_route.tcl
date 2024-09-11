utl::set_metrics_stage "globalroute__{}"

# This proc is here to allow us to use 'return' to return early from this
# file which is sourced
proc global_route_helper {} {
  source $::env(SCRIPTS_DIR)/load.tcl
  load_design 4_cts.odb 4_cts.sdc

  if {[info exist ::env(PRE_GLOBAL_ROUTE)]} {
    source $::env(PRE_GLOBAL_ROUTE)
  }

  fast_route

  # The default behavior if the user didn't specify GLOBAL_ROUTE_ARGS is to
  # produce a drc report every 5 iterations.
  #
  # If GLOBAL_ROUTE_ARGS is specified, then we do only what the
  # GLOBAL_ROUTE_ARGS specifies.
  proc do_global_route {} {
    set all_args [concat [list -congestion_report_file $::env(REPORTS_DIR)/congestion.rpt] \
      [expr {[info exists ::env(GLOBAL_ROUTE_ARGS)] ? $::env(GLOBAL_ROUTE_ARGS) : \
      {-congestion_iterations 30 -congestion_report_iter_step 5 -verbose}}]]

    log_cmd global_route {*}$all_args
  }

  set result [catch {do_global_route} errMsg]

  if {$result != 0} {
    if {[expr !$::env(GENERATE_ARTIFACTS_ON_FAILURE) || \
        ![file exists $::env(REPORTS_DIR)/congestion.rpt] || \
        [file size $::env(REPORTS_DIR)/congestion.rpt] == 0]} {
      write_db $::env(RESULTS_DIR)/5_1_grt-failed.odb
      error $errMsg
    }
    write_db $::env(RESULTS_DIR)/5_1_grt.odb
    return
  }

  set_placement_padding -global \
      -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
      -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

  set_propagated_clock [all_clocks]
  estimate_parasitics -global_routing

  if {[info exist ::env(DONT_USE_CELLS)]} {
    set_dont_use $::env(DONT_USE_CELLS)
  }

  if { !$::env(SKIP_INCREMENTAL_REPAIR) } {
    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route pre repair design"
    }

    # Repair design using global route parasitics
    puts "Perform buffer insertion..."
    repair_design
    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route post repair design"
    }

    # Running DPL to fix overlapped instances
    # Run to get modified net by DPL
    global_route -start_incremental
    detailed_placement
    # Route only the modified net by DPL
    global_route -end_incremental -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_design.rpt

    # Repair timing using global route parasitics
    puts "Repair setup and hold violations..."
    estimate_parasitics -global_routing

    repair_timing_helper

    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route post repair timing"
    }

    # Running DPL to fix overlapped instances
    # Run to get modified net by DPL
    global_route -start_incremental
    detailed_placement
    # Route only the modified net by DPL
    global_route -end_incremental -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_timing.rpt
  }

  recover_power

  if {![info exist ::env(SKIP_ANTENNA_REPAIR)]} {
    puts "Repair antennas..."
    repair_antennas -iterations 5
    check_placement -verbose
    check_antennas -report_file $::env(REPORTS_DIR)/grt_antennas.log
  }

  puts "Estimate parasitics..."
  estimate_parasitics -global_routing

  report_metrics 5 "global route"

  # Write SDC to results with updated clock periods that are just failing.
  # Use make target update_sdc_clock to install the updated sdc.
  source [file join $::env(SCRIPTS_DIR) "write_ref_sdc.tcl"]

  write_guides $::env(RESULTS_DIR)/route.guide
  write_db $::env(RESULTS_DIR)/5_1_grt.odb
}

global_route_helper
