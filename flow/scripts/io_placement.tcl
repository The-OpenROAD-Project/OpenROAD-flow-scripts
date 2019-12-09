if {[info exists standalone] && !$standalone} {
  # Do nothing
} else {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  
  # Read design files
  read_def $::env(RESULTS_DIR)/2_1_floorplan.def
}

run_io_placement -hor_layer 3 -ver_layer 2 -random

if {[info exists standalone] && !$standalone} {
  # Do nothing
} else {
  # write output
  write_def $::env(RESULTS_DIR)/2_2_floorplan_io.def
  
  exit
}
