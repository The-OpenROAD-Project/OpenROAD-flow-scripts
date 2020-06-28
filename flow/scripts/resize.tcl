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
  if [file exists platforms/$::env(PLATFORM)/derate.tcl] {
    source platforms/$::env(PLATFORM)/derate.tcl
  }
}

proc print_banner {header} {
  puts "\n=========================================================================="
  puts "$header"
  puts "--------------------------------------------------------------------------"
}

# Set res and cap
if [file exists platforms/$::env(PLATFORM)/setRC.tcl] {
  source platforms/$::env(PLATFORM)/setRC.tcl
}

# pre report
log_begin $::env(REPORTS_DIR)/3_pre_resize.rpt

print_banner "report_checks"
report_checks

print_banner "report_tns"
report_tns

print_banner "report_wns"
report_wns

print_banner "report_design_area"
report_design_area

print_banner "instance_count"
puts [sta::network_leaf_instance_count]

print_banner "pin_count"
puts [sta::network_leaf_pin_count]

puts ""

log_end

# Set the buffer cell
set buffer_cell [get_lib_cell [lindex $::env(MIN_BUF_CELL_AND_PORTS) 0]]
set_dont_use $::env(DONT_USE_CELLS)

# Do not buffer chip-level designs
if {![info exists ::env(FOOTPRINT)]} {
  puts "Perform port buffering..."
#  buffer_ports -buffer_cell $buffer_cell
}

puts "Perform buffer insertion..."
set_max_fanout $::env(MAX_FANOUT) [current_design]
repair_design -max_wire_length $::env(MAX_WIRE_LENGTH) -buffer_cell $buffer_cell

# Perform resizing
puts "Perform resizing after buffer insertion..."
resize

if { [info exists env(TIE_SEPARATION)] } {
  set tie_separation $env(TIE_SEPARATION)
} else {
  set tie_separation 0
}

# Repair tie lo fanout
puts "Repair tie lo fanout..."
set tielo_cell_name [lindex $env(TIELO_CELL_AND_PORT) 0]
set tielo_lib_name [get_name [get_property [get_lib_cell $tielo_cell_name] library]]
set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $env(TIELO_CELL_AND_PORT) 1]
repair_tie_fanout -separation $tie_separation $tielo_pin

# Repair tie hi fanout
puts "Repair tie hi fanout..."
set tiehi_cell_name [lindex $env(TIEHI_CELL_AND_PORT) 0]
set tiehi_lib_name [get_name [get_property [get_lib_cell $tiehi_cell_name] library]]
set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $env(TIEHI_CELL_AND_PORT) 1]
repair_tie_fanout -separation $tie_separation $tiehi_pin

# Repair hold violations
puts "Repair hold violations..."
repair_hold_violations -buffer_cell $buffer_cell

# post report
log_begin $::env(REPORTS_DIR)/3_post_resize.rpt

print_banner "report_floating_nets"
report_floating_nets

print_banner "report_checks"
report_checks -path_delay max -fields {slew cap input}

report_checks -path_delay min -fields {slew cap input}

print_banner "report_tns"
report_tns

print_banner "report_wns"
report_wns

print_banner "report_slew_violations"
report_check_types -max_slew -max_capacitance -max_fanout -violators

print_banner "report_design_area"
report_design_area

print_banner "instance_count"
puts [sta::network_leaf_instance_count]

print_banner "pin_count"
puts [sta::network_leaf_pin_count]

puts ""

log_end

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_2_place_resized.def
  exit
}
