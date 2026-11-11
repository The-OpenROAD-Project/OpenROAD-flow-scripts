utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
source $::env(SCRIPTS_DIR)/formal_check.tcl
erase_non_stage_variables cts
load_design 3_place.odb
source_step_tcl PRE CTS

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

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

if { $::env(DETAILED_METRICS) } {
  utl::push_metrics_stage "cts__{}__pre_repair_timing"
  log_cmd estimate_parasitics
  report_metrics 4 "cts pre-repair-timing"
  utl::pop_metrics_stage
}

set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

set result [catch { detailed_placement_helper -quiet } msg]
if { $result != 0 } {
  orfs_write_db $::env(RESULTS_DIR)/4_1_error.odb
  error "Detailed placement failed in CTS: $msg"
}

log_cmd estimate_parasitics

if { !$::env(SKIP_CTS_REPAIR_TIMING) } {
  set lec_enabled [lec_check_enabled]
  if { $lec_enabled } {
    write_lec_verilog 4_before_rsz_lec.v
  }

  repair_timing_helper

  if { $lec_enabled } {
    write_lec_verilog 4_after_rsz_lec.v
    run_lec_test 4_rsz 4_before_rsz_lec.v 4_after_rsz_lec.v
  }

  set result [catch { detailed_placement_helper -quiet } msg]
  if { $result != 0 } {
    orfs_write_db $::env(RESULTS_DIR)/4_1_error.odb
    error "Detailed placement failed in CTS: $msg"
  }

  log_cmd check_placement -placeable -verbose

  log_cmd estimate_parasitics
}

report_metrics 4 "cts final"

source_step_tcl POST CTS

orfs_write_db $::env(RESULTS_DIR)/4_1_cts.odb
