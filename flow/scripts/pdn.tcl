if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def
}

if {[file exist $::env(PDN_CFG)]} {
  pdngen $::env(PDN_CFG) -verbose
}

if {![info exists standalone] || $standalone} {
  # write output
  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  odb::odb_write_def $block $::env(RESULTS_DIR)/2_5_floorplan_pdn.def DEF_5_6
  exit
}
