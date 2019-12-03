if {[info exists standalone] && !$standalone} {
  # Do nothing
} else {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef
  
  # Read design files
  read_verilog $::env(RESULTS_DIR)/2_floorplan.v
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
  read_def $::env(RESULTS_DIR)/2_floorplan.def
}

set_wire_rc -resistance $::env(RES_UNIT_PER_MICRON) -capacitance $::env(CAP_UNIT_PER_MICRON)
global_placement -timing_driven 1

if {[info exists standalone] && !$standalone} {
  # Do nothing
} else {
  # write output
  write_def $::env(RESULTS_DIR)/3_1_place_gp.def
  exit
}
