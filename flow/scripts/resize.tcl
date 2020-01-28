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

# pre report
log_begin $::env(REPORTS_DIR)/3_pre_resize.rpt

report_checks
report_tns
report_wns
report_design_area

log_end

# Perform resizing and buffering
set dont_use_cells ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend $dont_use_cells [get_full_name [get_lib_cells */$cell]]
}

resize -buffer_cell [get_full_name [get_lib_cells */$::env(RESIZER_BUF_CELL)]] \
       -dont_use $dont_use_cells

set lib_port [get_full_name [get_lib_cells */[lindex $::env(TIEHI_CELL_AND_PORT) 0]]]/[lindex $::env(TIEHI_CELL_AND_PORT) 1]
puts "repair_tie_fanout on $lib_port"
repair_tie_fanout $lib_port \
                  -max_fanout $::env(MAX_FANOUT) \
                  -verbose

set lib_port [get_full_name [get_lib_cells */[lindex $::env(TIELO_CELL_AND_PORT) 0]]]/[lindex $::env(TIEHI_CELL_AND_PORT) 1]
puts "repair_tie_fanout on $lib_port"
repair_tie_fanout $lib_port \
                  -max_fanout $::env(MAX_FANOUT) \
                  -verbose

# post report
log_begin $::env(REPORTS_DIR)/3_post_resize.rpt

report_checks
report_tns
report_wns
report_design_area

log_end

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_2_place_resized.def
  write_verilog $::env(RESULTS_DIR)/3_place.v
  exit
}
