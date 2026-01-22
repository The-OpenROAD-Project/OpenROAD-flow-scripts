utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables cts
load_design 3_place.odb 3_place.sdc

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

proc save_progress { stage } {
  puts "Run 'make gui_$stage.odb' to load progress snapshot"
  orfs_write_db $::env(RESULTS_DIR)/$stage.odb
  orfs_write_sdc $::env(RESULTS_DIR)/$stage.sdc
}

# Run CTS
set cts_args [list \
  -sink_clustering_enable \
  -repair_clock_nets]

append_env_var cts_args CTS_BUF_DISTANCE -distance_between_buffers 1
append_env_var cts_args CTS_CLUSTER_SIZE -sink_clustering_size 1
append_env_var cts_args CTS_CLUSTER_DIAMETER -sink_clustering_max_diameter 1
append_env_var cts_args CTS_BUF_LIST -buf_list 1
append_env_var cts_args CTS_LIB_NAME -library 1


if { [env_var_exists_and_non_empty CTS_ARGS] } {
  set cts_args $::env(CTS_ARGS)
}

set_dont_use $::env(DONT_USE_CELLS)

log_cmd clock_tree_synthesis {*}$cts_args

utl::push_metrics_stage "cts__{}__pre_repair_timing"
log_cmd estimate_parasitics -placement
if { $::env(DETAILED_METRICS) } {
  report_metrics 4 "cts pre-repair-timing"
}
utl::pop_metrics_stage

set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

set result [catch { detailed_placement } msg]
if { $result != 0 } {
  save_progress 4_1_error
  error "Detailed placement failed in CTS: $msg"
}

log_cmd estimate_parasitics -placement

if { $::env(CTS_SNAPSHOTS) } {
  save_progress 4_1_pre_repair_hold_setup
}

if { !$::env(SKIP_CTS_REPAIR_TIMING) } {
  if { $::env(EQUIVALENCE_CHECK) } {
    write_eqy_verilog 4_before_rsz.v
  }

  repair_timing_helper

  if { $::env(EQUIVALENCE_CHECK) } {
    run_equivalence_test
  }

  set result [catch { detailed_placement } msg]
  if { $result != 0 } {
    save_progress 4_1_error
    error "Detailed placement failed in CTS: $msg"
  }

  check_placement -verbose
}

report_metrics 4 "cts final"

source_env_var_if_exists POST_CTS_TCL

orfs_write_db $::env(RESULTS_DIR)/4_1_cts.odb
orfs_write_sdc $::env(RESULTS_DIR)/4_cts.sdc
