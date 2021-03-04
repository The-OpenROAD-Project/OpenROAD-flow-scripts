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

  # Read design files
  # Read SDC and derating files
  read_def $::env(RESULTS_DIR)/4_cts.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
  if [file exists $::env(PLATFORM_DIR)/derate_final.tcl] {
    source $::env(PLATFORM_DIR)/derate_final.tcl
    puts "derate_final.tcl sourced"
  }
} else {
  puts "Starting global routing"
}

if {[info exist ::env(FASTROUTE_TCL)]} {
  source $::env(FASTROUTE_TCL)
} else {
  for {set layer $::env(MIN_ROUTING_LAYER)} {$layer <= $::env(MAX_ROUTING_LAYER)} {incr layer} {
    set_global_routing_layer_adjustment $layer 0.5
  }

  global_route -guide_file $::env(RESULTS_DIR)/route.guide \
            -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
            -unidirectional_routing \
            -overflow_iterations 100 \
            -macro_extension 2 \
            -verbose 2
}


# Set res and cap
if [file exists $::env(PLATFORM_DIR)/setRC.tcl] {
  source $::env(PLATFORM_DIR)/setRC.tcl
}

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing
estimate_rc -global_routing

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

puts "\n=========================================================================="
puts "report_power"
puts "--------------------------------------------------------------------------"
report_power

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"
check_antennas -report_file antenna.log


if {![info exists standalone] || $standalone} {
  exit
}
