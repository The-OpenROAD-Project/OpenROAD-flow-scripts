if {![info exists standalone] || $standalone} {
  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read lef def and sdc
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # TODO: Reading verilog instead of def because OpenDB doesn't support RECTs
  #      and doesn't' do extraction yet/
  # read_def $::env(RESULTS_DIR)/5_route.def
  read_verilog $::env(RESULTS_DIR)/5_route.v
  link_design $::env(DESIGN_NAME)

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
