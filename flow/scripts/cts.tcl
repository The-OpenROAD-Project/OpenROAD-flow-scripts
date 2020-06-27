if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/3_place.def

  # Read SDC file
  read_sdc $::env(RESULTS_DIR)/3_place.sdc
  if [file exists platforms/$::env(PLATFORM)/derate.tcl] {
    source platforms/$::env(PLATFORM)/derate.tcl
  }
}

# Run CTS
clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "$::env(CTS_BUF_CELL)" \
                     -wire_unit 20

set buffer_cell [get_lib_cell [lindex $::env(MIN_BUF_CELL_AND_PORTS) 0]]
repair_clock_nets -max_wire_length $::env(MAX_WIRE_LENGTH) -buffer_cell $buffer_cell

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement
check_placement

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/4_1_cts.def
  write_verilog $::env(RESULTS_DIR)/4_cts.v
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
  exit
}
