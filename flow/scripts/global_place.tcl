if {![info exists standalone] || $standalone} {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef

  # Read design files
  read_def $::env(RESULTS_DIR)/2_floorplan.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}

set_wire_rc -layer $::env(WIRE_RC_LAYER)

# Repair tie hi fanout
set tielo_cell_name [lindex $env(TIELO_CELL_AND_PORT) 0]
set tielo_lib_name [get_name [get_property [get_lib_cell */$tielo_cell_name] library]]
set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $env(TIELO_CELL_AND_PORT) 1]
repair_tie_fanout -max_fanout $::env(MAX_FANOUT) $tielo_pin

# Repair tie lo fanout
set tiehi_cell_name [lindex $env(TIEHI_CELL_AND_PORT) 0]
set tiehi_lib_name [get_name [get_property [get_lib_cell */$tiehi_cell_name] library]]
set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $env(TIEHI_CELL_AND_PORT) 1]
repair_tie_fanout -max_fanout $::env(MAX_FANOUT) $tiehi_pin

# Repair max fanout
set buffer_cell [get_lib_cell */[lindex $::env(MIN_BUF_CELL_AND_PORTS) 0]]
repair_max_fanout -max_fanout $::env(MAX_FANOUT) -buffer_cell $buffer_cell

global_placement -timing_driven -density $::env(PLACE_DENSITY)

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_1_place_gp.def
  exit
}
