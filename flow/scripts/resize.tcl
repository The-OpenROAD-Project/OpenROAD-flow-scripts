if {![info exists standalone] || $standalone} {

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read def and sdc
  read_def $::env(RESULTS_DIR)/3_1_place_gp.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}

# Set res and cap
set_wire_rc -layer $::env(WIRE_RC_LAYER)

# pre report
log_begin $::env(REPORTS_DIR)/3_pre_resize.rpt

puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

log_end

# Set the dont use list
set dont_use_cells ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend dont_use_cells [get_full_name [get_lib_cells */$cell]]
}

# Set the buffer cell
set buffer_cell [get_lib_cell */[lindex $::env(MIN_BUF_CELL_AND_PORTS) 0]]

# Do not buffer chip-level designs
if {![info exists ::env(FOOTPRINT)]} {
  puts "Perform port buffering..."
  buffer_ports -buffer_cell $buffer_cell
}

# Perform resizing
puts "Perform resizing..."
resize -resize -dont_use $dont_use_cells

# Repair max cap
puts "Repair max cap..."
repair_max_cap -buffer_cell $buffer_cell

# Repair max slew
puts "Repair max slew..."
repair_max_slew -buffer_cell $buffer_cell

# Repair tie lo fanout
puts "Repair tie lo fanout..."
set tielo_cell_name [lindex $env(TIELO_CELL_AND_PORT) 0]
set tielo_lib_name [get_name [get_property [get_lib_cell */$tielo_cell_name] library]]
set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $env(TIELO_CELL_AND_PORT) 1]
repair_tie_fanout -max_fanout $::env(MAX_FANOUT) $tielo_pin

# Repair tie hi fanout
puts "Repair tie hi fanout..."
set tiehi_cell_name [lindex $env(TIEHI_CELL_AND_PORT) 0]
set tiehi_lib_name [get_name [get_property [get_lib_cell */$tiehi_cell_name] library]]
set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $env(TIEHI_CELL_AND_PORT) 1]
repair_tie_fanout -max_fanout $::env(MAX_FANOUT) $tiehi_pin

# Repair max fanout
puts "Repair max fanout..."
repair_max_fanout -max_fanout $::env(MAX_FANOUT) -buffer_cell $buffer_cell

# Repair max fanout
puts "Repair max fanout..."
repair_hold_violations -buffer_cell $buffer_cell

# post report
log_begin $::env(REPORTS_DIR)/3_post_resize.rpt

puts "\n=========================================================================="
puts "report_floating_nets"
puts "--------------------------------------------------------------------------"
report_floating_nets

puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

log_end

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_2_place_resized.def
  exit
}
