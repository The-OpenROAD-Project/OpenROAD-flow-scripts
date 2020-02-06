if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged.lef
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/2_1_floorplan.def
}

if {![info exists ::env(FOOTPRINT)]} {
  io_placer -hor_layer $::env(IO_PLACER_H) \
            -ver_layer $::env(IO_PLACER_V) \
            -random
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_2_floorplan_io.def
  exit
}
