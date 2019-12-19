if {![info exists standalone] || $standalone} {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
}

macro_placement -global_config $::env(IP_GLOBAL_CFG)

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def
  exit
}
