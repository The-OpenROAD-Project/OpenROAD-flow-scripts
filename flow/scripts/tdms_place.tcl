if {![info exists standalone] || $standalone} {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_2_floorplan_io.def
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
}

set_wire_rc -layer $::env(WIRE_RC_LAYER)
global_placement -timing_driven

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
  exit
}
