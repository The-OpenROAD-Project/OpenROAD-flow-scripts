utl::set_metrics_stage "detailedplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_4_place_resized.odb 2_floorplan.sdc

source $::env(PLATFORM_DIR)/setRC.tcl

# Only for use with hybrid rows
if {[info exists ::env(BALANCE_ROWS)] && $::env(BALANCE_ROWS)} {
  balance_row_usage
}

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
set result [catch {detailed_placement} errMsg]
if {$result != 0} {
  write_db $::env(RESULTS_DIR)/3_5_place_dp-failed.odb
  error $errMsg
}

if {[info exists ::env(ENABLE_DPO)] && $::env(ENABLE_DPO)} {
  if {[info exist ::env(DPO_MAX_DISPLACEMENT)]} {
    improve_placement -max_displacement $::env(DPO_MAX_DISPLACEMENT)
  } else {
    improve_placement
  }
}
optimize_mirroring

utl::info FLW 12 "Placement violations [check_placement -verbose]."

estimate_parasitics -placement

source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics 3 "detailed place" true false

write_db $::env(RESULTS_DIR)/3_5_place_dp.odb
