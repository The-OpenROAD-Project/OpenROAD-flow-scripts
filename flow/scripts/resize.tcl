utl::set_metrics_stage "placeopt__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_3_place_gp.odb 2_floorplan.sdc

proc print_banner {header} {
  puts "\n=========================================================================="
  puts "$header"
  puts "--------------------------------------------------------------------------"
}

estimate_parasitics -placement


utl::push_metrics_stage "placeopt__{}__pre_opt"
source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics 3 "resizer pre" false false
utl::pop_metrics_stage

print_banner "instance_count"
puts [sta::network_leaf_instance_count]

print_banner "pin_count"
puts [sta::network_leaf_pin_count]

puts ""

set_dont_use $::env(DONT_USE_CELLS)

# Do not buffer chip-level designs
# by default, IO ports will be buffered
# to not buffer IO ports, set environment variable
# DONT_BUFFER_PORT = 1
if { ![info exists ::env(FOOTPRINT)] } {
  if { ![info exists ::env(DONT_BUFFER_PORTS)] || $::env(DONT_BUFFER_PORTS) == 0 } {
    puts "Perform port buffering..."
    buffer_ports
  }
}

puts "Perform buffer insertion..."
set additional_args ""
if { [info exists ::env(CAP_MARGIN)] && $::env(CAP_MARGIN) > 0.0} {
  puts "Cap margin $::env(CAP_MARGIN)"
  append additional_args " -cap_margin $::env(CAP_MARGIN)"
}
if { [info exists ::env(SLEW_MARGIN)] && $::env(SLEW_MARGIN) > 0.0} {
  puts "Slew margin $::env(SLEW_MARGIN)"
  append additional_args " -slew_margin $::env(SLEW_MARGIN)"
}

repair_design {*}$additional_args

if { [info exists env(TIE_SEPARATION)] } {
  set tie_separation $env(TIE_SEPARATION)
} else {
  set tie_separation 0
}

# Repair tie lo fanout
puts "Repair tie lo fanout..."
set tielo_cell_name [lindex $env(TIELO_CELL_AND_PORT) 0]
set tielo_lib_name [get_name [get_property [lindex [get_lib_cell $tielo_cell_name] 0] library]]
set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $env(TIELO_CELL_AND_PORT) 1]
repair_tie_fanout -separation $tie_separation $tielo_pin

# Repair tie hi fanout
puts "Repair tie hi fanout..."
set tiehi_cell_name [lindex $env(TIEHI_CELL_AND_PORT) 0]
set tiehi_lib_name [get_name [get_property [lindex [get_lib_cell $tiehi_cell_name] 0] library]]
set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $env(TIEHI_CELL_AND_PORT) 1]
repair_tie_fanout -separation $tie_separation $tiehi_pin

# hold violations are not repaired until after CTS

# post report

print_banner "report_floating_nets"
report_floating_nets

source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics 3 "resizer" true false

print_banner "instance_count"
puts [sta::network_leaf_instance_count]

print_banner "pin_count"
puts [sta::network_leaf_pin_count]

puts ""

write_db $::env(RESULTS_DIR)/3_4_place_resized.odb
