if {![info exists standalone] || $standalone} {
  # Read process files
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  
  # Read design files
  read_def $::env(RESULTS_DIR)/3_place.def

  # Read verilog  
  read_verilog $::env(RESULTS_DIR)/3_place.v
  
  # Read SDC file
  read_sdc $::env(RESULTS_DIR)/3_place.sdc 
}

# Report timing before CTS
report_checks

# Run CTS
clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "$::env(CTS_BUF_CELL)" \
                     -wire_unit 20 

legalize_placement

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/4_cts.def
  write_verilog $::env(RESULTS_DIR)/4_cts.v
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
  exit
}
