if {![info exists standalone] || $standalone} {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/3_2_place_resized.def
}

legalize_placement

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/3_3_place_dp.def
  exit
}
