utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_place.odb 3_place.sdc "Starting CTS"

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

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

utl::push_metrics_stage "cts__{}__pre_repair"
source $::env(SCRIPTS_DIR)/report_metrics.tcl

estimate_parasitics -placement
report_metrics "cts pre-repair"
utl::pop_metrics_stage

repair_clock_nets

utl::push_metrics_stage "cts__{}__post_repair"
estimate_parasitics -placement
report_metrics "cts post-repair"
utl::pop_metrics_stage

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement

puts "Repair setup and hold violations..."

# process user settings
set additional_args ""
if { [info exists ::env(SETUP_SLACK_MARGIN)] && $::env(SETUP_SLACK_MARGIN) > 0.0} {
  puts "Setup slack margin $::env(SETUP_SLACK_MARGIN)"
  append additional_args " -setup_margin $::env(SETUP_SLACK_MARGIN)"
}
if { [info exists ::env(HOLD_SLACK_MARGIN)] && $::env(HOLD_SLACK_MARGIN) > 0.0} {
  puts "Hold slack margin $::env(HOLD_SLACK_MARGIN)"
  append additional_args " -hold_margin $::env(HOLD_SLACK_MARGIN)"
}

repair_timing {*}$additional_args

detailed_placement
check_placement -verbose

report_metrics "cts final"

if { [info exists ::env(POST_CTS_TCL)] } {
  source $::env(POST_CTS_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
      write_def $::env(RESULTS_DIR)/4_1_cts.def
  }
  write_db $::env(RESULTS_DIR)/4_1_cts.odb
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
}
