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
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/2_floorplan.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}

set_wire_rc -layer $::env(WIRE_RC_LAYER)

global_placement -timing_driven -density $::env(PLACE_DENSITY)

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_1_place_gp.def
  exit
}
