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
  read_def -order_wires $::env(RESULTS_DIR)/6_final.def
  
  read_verilog $::env(RESULTS_DIR)/6_final.v
  link_design $::env(DESIGN_NAME)
  read_sdc $::env(RESULTS_DIR)/6_1_fill.sdc
} else {
  puts "Starting RCX+STA report"
}

# Set res and cap
if [file exists $::env(PLATFORM_DIR)/rcx_via_resistance.tcl] {
  source $::env(PLATFORM_DIR)/rcx_via_resistance.tcl
}

# Run extraction and STA
if [file exists $::env(PLATFORM_DIR)/patterns.rules] {
  
  # RCX section
  define_process_corner -ext_model_index 0 X
  extract_parasitics -ext_model_file $::env(PLATFORM_DIR)/patterns.rules
  
  # Write Spef
  write_spef $::env(RESULTS_DIR)/6_final.spef
  file delete $::env(DESIGN_NAME).totCap

  # Read Spef for OpenSTA
  read_spef $::env(RESULTS_DIR)/6_final.spef

  puts "\n=========================================================================="
  puts "report_checks -path_delay min"
  puts "--------------------------------------------------------------------------"
  report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded
  
  puts "\n=========================================================================="
  puts "report_checks -path_delay max"
  puts "--------------------------------------------------------------------------"
  report_checks -path_delay max -fields {slew cap input nets fanout} -format full_clock_expanded
  
  puts "\n=========================================================================="
  puts "report_checks -unconstrained"
  puts "--------------------------------------------------------------------------"
  report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded
  
  puts "\n=========================================================================="
  puts "report_tns"
  puts "--------------------------------------------------------------------------"
  report_tns
  
  puts "\n=========================================================================="
  puts "report_wns"
  puts "--------------------------------------------------------------------------"
  report_wns
  
  puts "\n=========================================================================="
  puts "report_worst_slack"
  puts "--------------------------------------------------------------------------"
  report_worst_slack
  
  puts "\n=========================================================================="
  puts "report_check_types -max_slew -violators"
  puts "--------------------------------------------------------------------------"
  report_check_types -max_slew -max_capacitance -max_fanout -violators
  
  puts "\n=========================================================================="
  puts "report_clock_skew"
  puts "--------------------------------------------------------------------------"
  report_clock_skew
  
} else {
  puts "RCX patterns.rules is not available! Can't run signoff flow."
}

if {![info exists standalone] || $standalone} {
  exit
}
