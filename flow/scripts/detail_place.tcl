utl::set_metrics_stage "detailedplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_4_place_resized.odb 2_floorplan.sdc
source_step_tcl PRE DETAIL_PLACE

source $::env(PLATFORM_DIR)/setRC.tcl

proc do_dpl { } {
  # Only for use with hybrid rows
  if { $::env(BALANCE_ROWS) } {
    balance_row_usage
  }

  set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
  set dpl_args [env_var_or_empty DETAIL_PLACEMENT_ARGS]
  append_env_var dpl_args USE_NEGOTIATION -use_negotiation 0
  log_cmd detailed_placement {*}$dpl_args

  if { $::env(ENABLE_DPO) } {
    if { [env_var_exists_and_non_empty DPO_MAX_DISPLACEMENT] } {
      log_cmd improve_placement -max_displacement $::env(DPO_MAX_DISPLACEMENT)
    } else {
      log_cmd improve_placement
    }
  }
  log_cmd optimize_mirroring

  utl::info FLW 12 "Placement violations [check_placement -verbose]."

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
