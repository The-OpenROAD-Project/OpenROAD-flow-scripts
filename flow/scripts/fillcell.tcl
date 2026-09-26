source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables route
if { [env_var_exists_and_non_empty FILL_CELLS] } {
  load_design 5_2_route.odb 5_1_grt.sdc
  source_step_tcl PRE FILLCELL

  set_propagated_clock [all_clocks]

  log_cmd filler_placement $::env(FILL_CELLS)
  check_placement

  report_design_area
  orfs_write_db $::env(RESULTS_DIR)/5_3_fillcell.odb
} else {
  orfs_copy_db $::env(RESULTS_DIR)/5_2_route.odb $::env(RESULTS_DIR)/5_3_fillcell.odb
}

source_step_tcl POST FILLCELL
