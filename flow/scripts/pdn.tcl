if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_5_floorplan_tapcell.def
}

if {[info exist ::env(PDN_CFG)]} {
  pdngen $::env(PDN_CFG) -verbose
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_6_floorplan_pdn.def
  exit
}
