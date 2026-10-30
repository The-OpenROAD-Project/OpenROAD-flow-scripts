utl::set_metrics_stage "globalroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables grt
load_design 4_cts.odb 4_cts.sdc

# This proc is here to allow us to use 'return' to return early from this
# file which is sourced
proc global_route_helper { } {
  source_step_tcl PRE GLOBAL_ROUTE

  set res_aware ""
  append_env_var res_aware ENABLE_RESISTANCE_AWARE -resistance_aware 0

  set use_cugr ""
  append_env_var use_cugr GLOBAL_ROUTE_USE_CUGR -use_cugr 0

  # CUGR runs a full 3D maze pass per iteration; use a tighter default.
  set cong_iters [list -congestion_iterations 30]
  if { $use_cugr ne "" } {
    set cong_iters [list -congestion_iterations 10]
  }
  set flow [list -congestion_report_file $::global_route_congestion_report \
    {*}$cong_iters {*}$res_aware {*}$use_cugr]
  set grt_args [command_args global_route grt.main $flow $res_aware]

  # The flow's choice to accept congestion, from GLOBAL_ROUTE_ARGS, passed
  # to every incremental reroute and to repair_antennas: each call decides
  # for itself, and one without -allow_congestion reroutes a congested route
  # harder and then fails on it.
  set allow_congestion ""
  if { [lsearch -exact $grt_args -allow_congestion] >= 0 } {
    set allow_congestion -allow_congestion
  }

  proc set_grt_seed { } {
    set seed_arg [env_var_or_empty GRT_SEED]
    if { $seed_arg ne "" } {
      log_cmd set_global_routing_random -seed $seed_arg
    }
  }

  proc run_global_route_and_catch_failures { args } {
    set result [catch { log_cmd global_route {*}$args } errMsg]

    if { $result != 0 } {
      if { !$::env(GENERATE_ARTIFACTS_ON_FAILURE) } {
        log_cmd write_db $::env(RESULTS_DIR)/5_1_grt-failed.odb
        error $errMsg
      }
      orfs_write_sdc $::env(RESULTS_DIR)/5_1_grt.sdc
      orfs_write_db $::env(RESULTS_DIR)/5_1_grt.odb
      return 0
    }
    return 1
  }

  proc do_global_route { grt_args } {
    set_grt_seed
    return [run_global_route_and_catch_failures {*}$grt_args]
  }
  set additional_args ""
  append_env_var additional_args dbProcessNode -db_process_node 1
  append_env_var additional_args VIA_IN_PIN_MIN_LAYER -via_in_pin_bottom_layer 1
  append_env_var additional_args VIA_IN_PIN_MAX_LAYER -via_in_pin_top_layer 1

  log_cmd pin_access {*}$additional_args

  if { ![do_global_route $grt_args] } {
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
    report_metrics 5 "global route pre repair design" true true $::env(DETAILED_METRICS)

    # Repair design using global route parasitics
    repair_design_helper grt.main
    report_metrics 5 "global route post repair design" true true $::env(DETAILED_METRICS)

    # Running DPL to fix overlapped instances
    # Run to get modified net by DPL
    log_cmd global_route -start_incremental {*}$allow_congestion
    detailed_placement_helper grt.repair_design -quiet
    # Route only the modified net by DPL
    if {
      ![run_global_route_and_catch_failures -end_incremental {*}$res_aware \
        {*}$allow_congestion \
        -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_design.rpt]
    } {
      return
    }

    # Repair timing using global route parasitics
    puts "Repair setup and hold violations..."
    log_cmd estimate_parasitics -global_routing

    repair_timing_helper grt.main

    report_metrics 5 "global route post repair timing" true true $::env(DETAILED_METRICS)

    log_cmd global_route -start_incremental {*}$allow_congestion
    detailed_placement_helper grt.repair_timing -quiet
    log_cmd check_placement -placeable -verbose
    # Route only the modified net by DPL
    if {
      ![run_global_route_and_catch_failures -end_incremental {*}$res_aware \
        {*}$allow_congestion \
        -congestion_report_file $::env(REPORTS_DIR)/congestion_post_repair_timing.rpt]
    } {
      return
    }

    log_cmd estimate_parasitics -global_routing

    if { $::env(OPT_POST_GRT_WNS) } {
      set repair_timing_args \
        [list -setup -sequence "vt_swap reroute" -skip_last_gasp -repair_tns 0 -verbose]
      if { [env_var_exists_and_non_empty MATCH_CELL_FOOTPRINT] } {
        lappend repair_timing_args -match_cell_footprint
      }
      set deprecated {}
      if { $::env(SETUP_SLACK_MARGIN) != 0 } {
        lappend deprecated -setup_margin $::env(SETUP_SLACK_MARGIN)
      }
      lappend repair_timing_args {*}$deprecated
      log_cmd repair_timing \
        {*}[command_args repair_timing grt.wns $repair_timing_args $deprecated]

      report_metrics 5 "global route post repair timing_opt_wns" true true \
        $::env(DETAILED_METRICS)
    }
  }

  if { !$::env(OPT_POST_GRT_WNS) } {
    log_cmd global_route -start_incremental {*}$allow_congestion
    recover_power_helper
    # Route the modified nets by rsz journal restore
    if {
      ![run_global_route_and_catch_failures -end_incremental {*}$res_aware \
        {*}$allow_congestion \
        -congestion_report_file $::env(REPORTS_DIR)/congestion_post_recover_power.rpt]
    } {
      return
    }
  }

  set run [expr {
    !$::env(SKIP_ANTENNA_REPAIR) &&
    [env_var_exists_and_non_empty MAX_REPAIR_ANTENNAS_ITER_GRT]
  }]
  if { [command_runs repair_antennas grt.main $run] } {
    puts "Repair antennas..."
    set deprecated {}
    append_env_var deprecated MAX_REPAIR_ANTENNAS_ITER_GRT -iterations 1
    repair_antennas {*}[command_args repair_antennas grt.main \
      [list {*}$deprecated {*}$allow_congestion] $deprecated]
    # repair antennas calls DPL internally
    log_cmd check_placement -placeable -verbose
    check_antennas -report_file $::env(REPORTS_DIR)/grt_antennas.log
  }

  puts "Estimate parasitics..."
  log_cmd estimate_parasitics -global_routing

  report_metrics 5 "global route"

  # Write SDC to results with updated clock periods that are just failing.
  # Use make target update_sdc_clock to install the updated sdc.
  source [file join $::env(SCRIPTS_DIR) "write_ref_sdc.tcl"]

  write_guides $::env(RESULTS_DIR)/route.guide
  source_step_tcl POST GLOBAL_ROUTE
  orfs_write_db $::env(RESULTS_DIR)/5_1_grt.odb
  orfs_write_sdc $::env(RESULTS_DIR)/5_1_grt.sdc
}

global_route_helper
