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

  # Read def
  read_def $::env(RESULTS_DIR)/6_1_fill.def
} else {
  puts "Starting CDL"
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_cdl -masters $::env(CDL_FILE) $::env(RESULTS_DIR)/6_final.cdl
}
