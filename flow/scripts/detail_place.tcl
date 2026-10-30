utl::set_metrics_stage "detailedplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_4_place_resized.odb 2_floorplan.sdc
source_step_tcl PRE DETAIL_PLACE

proc do_dpl { } {
  # Only for use with hybrid rows
  if { [command_runs balance_row_usage place.main $::env(BALANCE_ROWS)] } {
    balance_row_usage {*}[command_args balance_row_usage place.main {}]
  }

  set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
  detailed_placement_helper place.main

  if { [command_runs improve_placement place.main $::env(ENABLE_DPO)] } {
    set deprecated {}
    append_env_var deprecated DPO_MAX_DISPLACEMENT -max_displacement 1
    log_cmd improve_placement \
      {*}[command_args improve_placement place.main $deprecated $deprecated]
  }
  log_cmd optimize_mirroring

  utl::info FLW 12 "Placement violations [check_placement -placeable -verbose]."

  log_cmd estimate_parasitics -placement
}

set result [catch { do_dpl } errMsg]
if { $result != 0 } {
  orfs_write_db $::env(RESULTS_DIR)/3_5_place_dp-failed.odb
  error $errMsg
}

report_metrics 3 "detailed place" true false

source_step_tcl POST DETAIL_PLACE

orfs_write_db $::env(RESULTS_DIR)/3_5_place_dp.odb
orfs_write_sdc $::env(RESULTS_DIR)/3_place.sdc
