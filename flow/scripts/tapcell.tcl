if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def
}

if {[info exist ::env(TAPCELL_TCL)]} {
  source $::env(TAPCELL_TCL)
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_5_floorplan_tapcell.def
  exit
}
