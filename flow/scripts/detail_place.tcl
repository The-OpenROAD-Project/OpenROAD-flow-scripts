if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  read_def $::env(RESULTS_DIR)/3_3_place_resized.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
} else {
  puts "Starting detailed placement"
}

source $::env(PLATFORM_DIR)/setRC.tcl

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement
optimize_mirroring
set violations [check_placement -verbose]
utl::info FLW 12 "Placement violations $violations."
utl::metric "detailedplace__design__violations" $violations

estimate_parasitics -placement

source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "detailed place"

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/3_4_place_dp.def
}
