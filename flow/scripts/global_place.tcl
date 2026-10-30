utl::set_metrics_stage "globalplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_2_place_iop.odb 2_floorplan.sdc
source_step_tcl PRE GLOBAL_PLACE

set_dont_use $::env(DONT_USE_CELLS)

if { $::env(GPL_TIMING_DRIVEN) } {
  remove_buffers
}

# Do not buffer chip-level designs
# by default, IO ports will be buffered
# to not buffer IO ports, set environment variable
# DONT_BUFFER_PORT = 1
if { ![env_var_exists_and_non_empty FOOTPRINT] } {
  if { [command_runs buffer_ports place.main [expr { !$::env(DONT_BUFFER_PORTS) }]] } {
    puts "Perform port buffering..."
    buffer_ports {*}[command_args buffer_ports place.main {}]
  }
}

# Parameters for routability mode in global placement
set deprecated {}
append_env_var deprecated GPL_ROUTABILITY_DRIVEN -routability_driven 0
append_env_var deprecated GPL_RANDOM_SEED -random_seed 1
set global_placement_args $deprecated

# Parameters for timing driven mode in global placement
if { $::env(GPL_TIMING_DRIVEN) } {
  lappend global_placement_args {-timing_driven}
  if { [info exists ::env(GPL_KEEP_OVERFLOW)] } {
    lappend global_placement_args -keep_resize_below_overflow $::env(GPL_KEEP_OVERFLOW)
  }
}

# Parameters for phi coefficients in global placement
set min_phi $::env(MIN_PLACE_STEP_COEF)
set max_phi $::env(MAX_PLACE_STEP_COEF)

if { $min_phi > $max_phi } {
  utl::error GPL 200 \
    "MIN_PLACE_STEP_COEF ($min_phi) cannot be greater than \
MAX_PLACE_STEP_COEF ($max_phi)"
}

lappend global_placement_args -force_center_initial_place

lappend global_placement_args -min_phi_coef $::env(MIN_PLACE_STEP_COEF)
lappend global_placement_args -max_phi_coef $::env(MAX_PLACE_STEP_COEF)

set place_ios [expr { $::env(GPL_PLACE_IOS) && ![pins_fixed_in_floorplan] }]
if { $place_ios } {
  log_cmd set_place_config {*}[place_pins_args_to_place_config]
  lappend global_placement_args -place_ios
}

proc do_placement { global_placement_args deprecated } {
  set all_args [concat [list -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)] \
    $global_placement_args]

  log_cmd global_placement \
    {*}[command_args global_placement place.main $all_args $deprecated]
}

set result [catch { do_placement $global_placement_args $deprecated } errMsg]
if { $place_ios } {
  log_cmd reset_place_config
}
if { $result != 0 } {
  orfs_write_db $::env(RESULTS_DIR)/3_3_place_gp-failed.odb
  error $errMsg
}

log_cmd estimate_parasitics -placement

if { [command_runs cluster_flops place.main $::env(CLUSTER_FLOPS)] } {
  log_cmd cluster_flops {*}[command_args cluster_flops place.main {}]
  log_cmd estimate_parasitics -placement
}

report_metrics 3 "global place" false false

source_step_tcl POST GLOBAL_PLACE

orfs_write_db $::env(RESULTS_DIR)/3_3_place_gp.odb
