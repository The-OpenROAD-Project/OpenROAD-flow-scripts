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
  # -order_wires flag is REQUIRED to run RCX
  read_def $::env(RESULTS_DIR)/6_1_fill.def
  read_sdc $::env(RESULTS_DIR)/6_1_fill.sdc
} else {
  puts "Starting final report"
}


# Delete routing obstructions for final DEF
source scripts/deleteRoutingObstructions.tcl
deleteRoutingObstructions

write_def $::env(RESULTS_DIR)/6_final.def
write_verilog $::env(RESULTS_DIR)/6_final.v

# Run extraction and STA
if {[info exist ::env(OPENRCX_ENABLED)] &&
    [file exists $::env(PLATFORM_DIR)/rcx_patterns.rules]} {
  
  # Set res and cap
  if [file exists $::env(PLATFORM_DIR)/rcx_via_resistance.tcl] {
    source $::env(PLATFORM_DIR)/rcx_via_resistance.tcl
  }

  # RCX section
  define_process_corner -ext_model_index 0 X
  extract_parasitics -ext_model_file $::env(PLATFORM_DIR)/rcx_patterns.rules
  
  # Write Spef
  write_spef $::env(RESULTS_DIR)/6_final.spef
  file delete $::env(DESIGN_NAME).totCap

  # Read Spef for OpenSTA
  read_spef $::env(RESULTS_DIR)/6_final.spef

  source $::env(SCRIPTS_DIR)/report_metrics.tcl
} else {
  puts "rcx_patterns.rules is not available! Can't run signoff flow."

  report_design_area
  report_power
}

if {![info exists standalone] || $standalone} {
  exit
}
