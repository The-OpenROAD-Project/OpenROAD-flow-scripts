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
  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  read_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def
} else {
  puts "Starting tapcell"
}

if {[info exist ::env(TAPCELL_TCL)]} {
  source $::env(TAPCELL_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_def $::env(RESULTS_DIR)/2_5_floorplan_tapcell.def
}
