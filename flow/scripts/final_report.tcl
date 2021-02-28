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

  # Read def and sdc
  # Use -order_wires to build wire graph
  # for antenna checker read_def -order_wires $::env(RESULTS_DIR)/6_1_fill.def
  read_def $::env(RESULTS_DIR)/6_1_fill.def
} else {
  puts "Starting final report"
}


# Delete routing obstructions for final DEF
source scripts/deleteRoutingObstructions.tcl
deleteRoutingObstructions

write_def $::env(RESULTS_DIR)/6_final.def
write_verilog $::env(RESULTS_DIR)/6_final.v

report_design_area
report_power

if {![info exists standalone] || $standalone} {
  exit
}
