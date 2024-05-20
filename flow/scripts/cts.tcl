utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_place.odb 3_place.sdc

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

proc save_progress {stage} {
  puts "Run 'make gui_$stage.odb' to load progress snapshot"
  write_db $::env(RESULTS_DIR)/$stage.odb
  write_sdc -no_timestamp $::env(RESULTS_DIR)/$stage.sdc
}

# Run CTS
set cts_args [list \
          -sink_clustering_enable \
          -balance_levels]

if {[info exist ::env(CTS_BUF_DISTANCE)]} {
  lappend cts_args -distance_between_buffers $::env(CTS_BUF_DISTANCE)
}

if {[info exist ::env(CTS_CLUSTER_SIZE)]} {
  lappend cts_args -sink_clustering_size $::env(CTS_CLUSTER_SIZE)
}

if {[info exist ::env(CTS_CLUSTER_DIAMETER)]} {
  lappend cts_args -sink_clustering_max_diameter $::env(CTS_CLUSTER_DIAMETER)
}

if {[info exist ::env(CTS_ARGS)]} {
  set cts_args $::env(CTS_ARGS)
}

log_cmd clock_tree_synthesis {*}$cts_args

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_clock_nets
}

set_propagated_clock [all_clocks]

set_dont_use $::env(DONT_USE_CELLS)

utl::push_metrics_stage "cts__{}__pre_repair"

estimate_parasitics -placement
if {[info exist ::env(DETAILED_METRICS)]} {
  report_metrics 4 "cts pre-repair"
}
utl::pop_metrics_stage

repair_clock_nets

utl::push_metrics_stage "cts__{}__post_repair"
estimate_parasitics -placement
if {[info exist ::env(DETAILED_METRICS)]} {
  report_metrics 4 "cts post-repair"
}
utl::pop_metrics_stage

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_hold_setup
}

# process user settings
set additional_args "-verbose"
append_env_var additional_args SETUP_SLACK_MARGIN -setup_margin 1
append_env_var additional_args HOLD_SLACK_MARGIN -hold_margin 1
append_env_var additional_args TNS_END_PERCENT -repair_tns 1
append_env_var additional_args SKIP_PIN_SWAP -skip_pin_swap 0
append_env_var additional_args SKIP_GATE_CLONING -skip_gate_cloning 0

if {[info exists ::env(SKIP_CTS_REPAIR_TIMING)] == 0 || $::env(SKIP_CTS_REPAIR_TIMING) == 0} {
  if {[info exists ::env(EQUIVALENCE_CHECK)] && $::env(EQUIVALENCE_CHECK) == 1} {
      write_eqy_verilog 4_before_rsz.v
  }

  puts "repair_timing [join $additional_args " "]"
  repair_timing {*}$additional_args

  if {[info exists ::env(EQUIVALENCE_CHECK)] && $::env(EQUIVALENCE_CHECK) == 1} {
      run_equivalence_test
  }

  set result [catch {detailed_placement} msg]
  if {$result != 0} {
    save_progress 4_1_error
    puts "Detailed placement failed in CTS: $msg"
    exit $result
  }

  check_placement -verbose
}

report_metrics 4 "cts final"

if { [info exists ::env(POST_CTS_TCL)] } {
  source $::env(POST_CTS_TCL)
}

if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
  write_def $::env(RESULTS_DIR)/4_1_cts.def
}
write_db $::env(RESULTS_DIR)/4_1_cts.odb
write_sdc -no_timestamp $::env(RESULTS_DIR)/4_cts.sdc
