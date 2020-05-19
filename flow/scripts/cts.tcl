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
}

# Report timing before CTS
puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

# Run CTS
clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "$::env(CTS_BUF_CELL)" \
                     -wire_unit 20

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement
check_placement

source $::env(SCRIPTS_DIR)/add_routing_blk.tcl

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/4_1_cts.def
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
  exit
}
