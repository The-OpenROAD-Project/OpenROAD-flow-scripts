utl::set_metrics_stage "detailedplace__{}"

source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_4_place_resized.odb 2_floorplan.sdc "Starting detailed placement"


source $::env(PLATFORM_DIR)/setRC.tcl

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

if {[info exists ::env(ENABLE_DPO)] && $::env(ENABLE_DPO)} {
  if {[info exist ::env(DPO_MAX_DISPLACEMENT)]} {
    improve_placement -max_displacement $::env(DPO_MAX_DISPLACEMENT)
  } else {
    improve_placement
  }
}
optimize_mirroring
set violations [check_placement -verbose]
utl::info FLW 12 "Placement violations $violations."

if {$violations eq ""} {
  utl::metric_integer "detailedplace__design__violations" 0
} else {
  utl::metric_integer "detailedplace__design__violations" $violations
}

estimate_parasitics -placement

source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "detailed place"

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/3_5_place_dp.odb
}
