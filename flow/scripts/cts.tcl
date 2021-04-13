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
  read_def $::env(RESULTS_DIR)/3_place.def

  # Read SDC file
  read_sdc $::env(RESULTS_DIR)/3_place.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
} else {
  puts "Starting CTS"
}

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

source $::env(PLATFORM_DIR)/setRC.tcl

# Run CTS
if {[info exist ::env(CTS_CLUSTER_SIZE)]} {
  set cluster_size "$::env(CTS_CLUSTER_SIZE)"
} else {
  set cluster_size 30
}
if {[info exist ::env(CTS_CLUSTER_DIAMETER)]} {
  set cluster_diameter "$::env(CTS_CLUSTER_DIAMETER)"
} else {
  set cluster_diameter 100
}

if {[info exist ::env(CTS_BUF_DISTANCE)]} {
clock_tree_synthesis -root_buf "$::env(CTS_BUF_CELL)" -buf_list "$::env(CTS_BUF_CELL)" \
                     -sink_clustering_enable \
                     -sink_clustering_size $cluster_size \
                     -sink_clustering_max_diameter $cluster_diameter \
                     -distance_between_buffers "$::env(CTS_BUF_DISTANCE)"
} else {
clock_tree_synthesis -root_buf "$::env(CTS_BUF_CELL)" -buf_list "$::env(CTS_BUF_CELL)" \
                     -sink_clustering_enable \
                     -sink_clustering_size $cluster_size \
                     -sink_clustering_max_diameter $cluster_diameter \

}


set_propagated_clock [all_clocks]

estimate_parasitics -placement
set_dont_use $::env(DONT_USE_CELLS)
repair_clock_nets

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement

puts "Repair hold violations..."
if { [catch {repair_timing -hold }]} {
  puts "hold utilization limit caught, continuing"
}
puts "Repair setup violations..."
if { [catch {repair_timing -setup }]} {
  puts "setup utilization limit caught, continuing"
}

puts "\n=========================================================================="
puts "post cts report_checks -path_delay min"
puts "--------------------------------------------------------------------------"
report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_checks -path_delay max"
puts "--------------------------------------------------------------------------"
report_checks -path_delay max -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_checks -unconstrained"
puts "--------------------------------------------------------------------------"
report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "post cts report_wns"
puts "--------------------------------------------------------------------------"
report_wns
report_worst_slack

puts "\n=========================================================================="
puts "post cts report_check_types -max_slew -violators"
puts "--------------------------------------------------------------------------"
report_check_types -max_slew -max_capacitance -max_fanout -violators

puts "\n=========================================================================="
puts "post cts report_clock_skew"
puts "--------------------------------------------------------------------------"
report_clock_skew

detailed_placement
check_placement

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/4_1_cts.def
  write_verilog $::env(RESULTS_DIR)/4_cts.v
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
  exit
}
