if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_5_floorplan_pdn.def
}

tapcell \
 -endcap_cpp "1" \
 -distance $::env(WELLTTAP_RULE) \
 -tabcell_master $::env(WELLTIE_CELL) \
 -endcap_master $::env(ENDCAP_CELL)


if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_6_floorplan_tapcell.def
  exit
}
