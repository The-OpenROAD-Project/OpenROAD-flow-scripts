utl::set_metrics_stage "globalroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables grt
load_design 4_cts.odb 4_cts.sdc

# This proc is here to allow us to use 'return' to return early from this
# file which is sourced
proc global_route_helper { } {
  source_env_var_if_exists PRE_GLOBAL_ROUTE_TCL

  set res_aware ""
  append_env_var res_aware ENABLE_RESISTANCE_AWARE -resistance_aware 0

  proc do_global_route { res_aware } {
    set all_args [concat [list \
      -congestion_report_file $::global_route_congestion_report] \
      $::env(GLOBAL_ROUTE_ARGS) {*}$res_aware]

    log_cmd global_route {*}$all_args
  }
  set additional_args ""
  append_env_var additional_args dbProcessNode -db_process_node 1
  append_env_var additional_args VIA_IN_PIN_MIN_LAYER -via_in_pin_bottom_layer 1
  append_env_var additional_args VIA_IN_PIN_MAX_LAYER -via_in_pin_top_layer 1

  log_cmd pin_access {*}$additional_args

  set result [catch { do_global_route $res_aware } errMsg]

  if { $result != 0 } {
    if { !$::env(GENERATE_ARTIFACTS_ON_FAILURE) } {
      orfs_write_db $::env(RESULTS_DIR)/5_1_grt-failed.odb
      error $errMsg
    }
    orfs_write_sdc $::env(RESULTS_DIR)/5_1_grt.sdc
    orfs_write_db $::env(RESULTS_DIR)/5_1_grt.odb
    return
  }

  set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

  set_propagated_clock [all_clocks]
  log_cmd estimate_parasitics -global_routing

  if { [env_var_exists_and_non_empty DONT_USE_CELLS] } {
    set_dont_use $::env(DONT_USE_CELLS)
  }

  if { !$::env(SKIP_INCREMENTAL_REPAIR) } {
    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route pre repair design"
    }

    # Repair design using global route parasitics
    repair_design_helper
    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route post repair design"
    }

    # Running DPL to fix overlapped instances
    # Run to get modified net by DPL
    log_cmd global_route -start_incremental
    log_cmd detailed_placement
    # Route only the modified net by DPL
    log_cmd global_route -end_incremental {*}$res_aware \
      -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_design.rpt

    # Repair timing using global route parasitics
    puts "Repair setup and hold violations..."
    log_cmd estimate_parasitics -global_routing

    repair_timing_helper

    if { $::env(DETAILED_METRICS) } {
      report_metrics 5 "global route post repair timing"
    }

    # Running DPL to fix overlapped instances
    # Run to get modified net by DPL
    log_cmd global_route -start_incremental
    log_cmd detailed_placement
    # Route only the modified net by DPL
    log_cmd global_route -end_incremental {*}$res_aware \
      -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_timing.rpt
  }


  log_cmd global_route -start_incremental
  recover_power_helper
  # Route the modified nets by rsz journal restore
  log_cmd global_route -end_incremental {*}$res_aware \
    -congestion_report_file $::env(REPORTS_DIR)/congestion_post_recover_power.rpt

  if {
    !$::env(SKIP_ANTENNA_REPAIR) &&
    [env_var_exists_and_non_empty MAX_REPAIR_ANTENNAS_ITER_GRT]
  } {
    puts "Repair antennas..."
    repair_antennas -iterations $::env(MAX_REPAIR_ANTENNAS_ITER_GRT)
    check_placement -verbose
    check_antennas -report_file $::env(REPORTS_DIR)/grt_antennas.log
  }

  puts "Estimate parasitics..."
  log_cmd estimate_parasitics -global_routing

  report_metrics 5 "global route"

  # Write SDC to results with updated clock periods that are just failing.
  # Use make target update_sdc_clock to install the updated sdc.
  source [file join $::env(SCRIPTS_DIR) "write_ref_sdc.tcl"]

  write_guides $::env(RESULTS_DIR)/route.guide
  orfs_write_db $::env(RESULTS_DIR)/5_1_grt.odb
  orfs_write_sdc $::env(RESULTS_DIR)/5_1_grt.sdc
}

global_route_helper
