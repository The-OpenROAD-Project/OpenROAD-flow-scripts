if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_5_floorplan_pdn.def
}

if {[file exist $::env(TAPCELL_TCL)]} {
  source $::env(TAPCELL_TCL)
}

if {![info exists standalone] || $standalone} {
  # write output
  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  odb::odb_write_def $block $::env(RESULTS_DIR)/2_6_floorplan_tapcell.def DEF_5_6
  exit
}
