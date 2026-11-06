utl::set_metrics_stage "detailedroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 5_1_grt.odb 5_1_grt.sdc
source_step_tcl PRE DETAIL_ROUTE
if { ![grt::have_routes] } {
  error "Global routing failed, run `make gui_grt` and load $::global_route_congestion_report \
        in DRC viewer to view congestion"
}

if { !$::env(SKIP_DETAILED_ROUTE) } {
  erase_non_stage_variables route
  set_propagated_clock [all_clocks]

  set deprecated ""
  append_env_var deprecated OR_SEED -or_seed 1
  append_env_var deprecated OR_K -or_k 1
  append_env_var deprecated DISABLE_VIA_GEN -disable_via_gen 0
  append_env_var deprecated REPAIR_PDN_VIA_LAYER -repair_pdn_vias 1
  append_env_var deprecated DETAILED_ROUTE_END_ITERATION -droute_end_iter 1

  set additional_args ""
  append_env_var additional_args dbProcessNode -db_process_node 1
  append_env_var additional_args VIA_IN_PIN_MIN_LAYER -via_in_pin_bottom_layer 1
  append_env_var additional_args VIA_IN_PIN_MAX_LAYER -via_in_pin_top_layer 1

  # Save out a progress report a few iterations after the first two: the
  # first couple of iterations produce very large .drc reports without
  # interesting information for the user. This gives progress information
  # soon without having to go spelunking in Tcl or modify configuration
  # scripts, while not having to wait too long or generating large useless
  # reports.
  #
  # DETAILED_ROUTE_ARGS is used when debugging detailed route, e.g.
  # "-droute_end_iter 5" to look at routing violations after only 5
  # iterations, speeding up iterations on a problem where detailed routing
  # doesn't converge or converges slower than expected. A plain command line
  # in it still replaces these arguments, as it always has; the first two
  # options, the report and log files, stay.
  set fixed [list -output_drc $::env(REPORTS_DIR)/5_route_drc.rpt \
    -output_maze $::env(RESULTS_DIR)/maze.log]
  set all_args [command_args detailed_route route.main \
    [list {*}$fixed {*}$additional_args {*}$deprecated -verbose 1 -drc_report_iter_step 5] \
    $deprecated DETAILED_ROUTE_ARGS:[llength $fixed]]

  log_cmd detailed_route {*}$all_args

  set run [expr {
    !$::env(SKIP_ANTENNA_REPAIR_POST_DRT) &&
    [env_var_exists_and_non_empty MAX_REPAIR_ANTENNAS_ITER_DRT]
  }]
  if { [command_runs repair_antennas route.main $run] } {
    set antenna_args [command_args repair_antennas route.main {}]
    set repair_antennas_iters 1
    if { [repair_antennas {*}$antenna_args] } {
      detailed_route {*}$all_args
    }
    while {
      [check_antennas] && $repair_antennas_iters < $::env(MAX_REPAIR_ANTENNAS_ITER_DRT)
    } {
      repair_antennas {*}$antenna_args
      detailed_route {*}$all_args
      incr repair_antennas_iters
    }
  } else {
    utl::metric_integer "antenna_diodes_count" -1
  }

  source_step_tcl POST DETAIL_ROUTE

  check_antennas -report_file $env(REPORTS_DIR)/drt_antennas.log

  if { ![design_is_routed] } {
    error "Design has unrouted nets."
  }

  report_design_area

  # Don't report metrics as we have not extracted parasitics, which will
  # happen in final so there is no need to repeat it here.
}

orfs_write_db $::env(RESULTS_DIR)/5_2_route.odb
