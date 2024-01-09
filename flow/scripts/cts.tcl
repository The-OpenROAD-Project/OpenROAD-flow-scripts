utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_place.odb 3_place.sdc

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

proc save_progress {stage} {
  puts "Run 'make gui_$stage.odb' to load progress snapshot"
  write_db $::env(RESULTS_DIR)/$stage.odb
  write_sdc -no_timestamp $::env(RESULTS_DIR)/$stage.sdc
}

set cts_args [list \
          -sink_clustering_enable \
          -balance_levels]

if {[info exist ::env(CTS_BUF_DISTANCE)]} {
  lappend cts_args -distance_between_buffers "$::env(CTS_BUF_DISTANCE)"
}

if {[info exist ::env(CTS_ARGS)]} {
  set cts_args $::env(CTS_ARGS)
}

puts "clock_tree_synthesis [join $cts_args " "]"

clock_tree_synthesis {*}$cts_args

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_clock_nets
}

set_propagated_clock [all_clocks]

set_dont_use $::env(DONT_USE_CELLS)

utl::push_metrics_stage "cts__{}__pre_repair"
source $::env(SCRIPTS_DIR)/report_metrics.tcl

estimate_parasitics -placement
report_metrics 4 "cts pre-repair"
utl::pop_metrics_stage

repair_clock_nets

utl::push_metrics_stage "cts__{}__post_repair"
estimate_parasitics -placement
report_metrics 4 "cts post-repair"
utl::pop_metrics_stage

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_hold_setup
}

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

puts "TNS end percent $::env(TNS_END_PERCENT)"
append additional_args " -repair_tns $::env(TNS_END_PERCENT)"

if { [info exists ::env(SKIP_PIN_SWAP)] } {
  puts "Skipping pin swapping during optimization"
  append additional_args " -skip_pin_swap"
}

if { [info exists ::env(SKIP_GATE_CLONING)] } {
  puts "Skipping gate cloning during optimization"
  append additional_args " -skip_gate_cloning"
}


if { [info exists ::env(EQUIVALENCE_CHECK)] } {
    write_eqy_verilog 4_before_rsz.v
}

repair_timing {*}$additional_args

if { [info exists ::env(EQUIVALENCE_CHECK)] } {
    run_equivalence_test
}

set result [catch {detailed_placement} msg]
if {$result != 0} {
  save_progress 4_1_error
  puts "Detailed placement failed in CTS: $msg"
  exit $result
}

check_placement -verbose

report_metrics 4 "cts final"

if { [info exists ::env(POST_CTS_TCL)] } {
  source $::env(POST_CTS_TCL)
}

if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
  write_def $::env(RESULTS_DIR)/4_1_cts.def
}
write_db $::env(RESULTS_DIR)/4_1_cts.odb
write_sdc -no_timestamp $::env(RESULTS_DIR)/4_cts.sdc
