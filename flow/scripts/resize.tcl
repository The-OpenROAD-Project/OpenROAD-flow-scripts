if {![info exists standalone] || $standalone} {
  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read lef def and sdc
  read_lef $::env(OBJECTS_DIR)/merged.lef
  read_def $::env(RESULTS_DIR)/3_1_place_gp.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}

# Set res and cap
set_wire_rc -layer $::env(WIRE_RC_LAYER)

# initial report
report_checks > $::env(REPORTS_DIR)/checks.rpt
report_tns > $::env(REPORTS_DIR)/tns.rpt
report_wns > $::env(REPORTS_DIR)/wns.rpt

# Perform resizing and buffering
set dont_use_cells ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend $dont_use_cells [get_full_name [get_lib_cells */$cell]]
}

resize -buffer_cell [get_full_name [get_lib_cells */$::env(RESIZER_BUF_CELL)]] \
       -dont_use $dont_use_cells


# final report
report_checks > $::env(REPORTS_DIR)/3_resize_checks.rpt
report_tns > $::env(REPORTS_DIR)/3_resize_tns.rpt
report_wns > $::env(REPORTS_DIR)/3_resize_wns.rpt
report_design_area

if {![info exists standalone] || $standalone} {
  # write output
  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  odb::odb_write_def $block $::env(RESULTS_DIR)/3_2_place_resized.def DEF_5_6
  write_verilog $::env(RESULTS_DIR)/3_place.v
  exit
}
