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

set_dont_use $::env(DONT_USE_CELLS)

source $::env(SCRIPTS_DIR)/report_metrics.tcl

estimate_parasitics -placement
report_metrics "cts pre-repair"

repair_clock_nets

estimate_parasitics -placement
report_metrics "cts post-repair"

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement

puts "Repair setup violations..."
# process user settings
set additional_args ""
if { [info exists ::env(SETUP_SLACK_MARGIN)] && $::env(SETUP_SLACK_MARGIN) > 0.0} {
  puts "Setup repair with slack margin $::env(SETUP_SLACK_MARGIN)"
  append additional_args " -slack_margin $::env(SETUP_SLACK_MARGIN)"
}
eval repair_timing -setup $additional_args

puts "Repair hold violations..."
# process user settings
set additional_args ""
if { [info exists ::env(HOLD_SLACK_MARGIN)] && $::env(HOLD_SLACK_MARGIN) > 0.0} {
  puts "Hold repair with slack margin $::env(HOLD_SLACK_MARGIN)"
  append additional_args " -slack_margin $::env(HOLD_SLACK_MARGIN)"
}
repair_timing -hold {*}$additional_args

detailed_placement
check_placement -verbose

report_metrics "cts final"

if { [info exists ::env(POST_CTS_TCL)] } {
  source $::env(POST_CTS_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_def $::env(RESULTS_DIR)/4_1_cts.def
  write_verilog $::env(RESULTS_DIR)/4_cts.v
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
}
