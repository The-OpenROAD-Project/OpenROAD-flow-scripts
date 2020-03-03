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
  read_def $::env(RESULTS_DIR)/5_route.def
  read_sdc $::env(RESULTS_DIR)/5_route.sdc
}

log_begin $::env(REPORTS_DIR)/6_final_report.rpt

puts "\n=========================================================================="
puts "report_checks -path_delay min"
puts "--------------------------------------------------------------------------"
report_checks -path_delay min

puts "\n=========================================================================="
puts "report_checks -path_delay max"
puts "--------------------------------------------------------------------------"
report_checks -path_delay max

puts "\n=========================================================================="
puts "report_checks -unconstrained"
puts "--------------------------------------------------------------------------"
report_checks -unconstrained

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_check_types -max_transition -all_violators"
puts "--------------------------------------------------------------------------"
report_check_types -max_transition -all_violators

puts "\n=========================================================================="
puts "report_power"
puts "--------------------------------------------------------------------------"
report_power

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

log_end

if {![info exists standalone] || $standalone} {
  exit
}
