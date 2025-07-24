utl::set_metrics_stage "globalplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_2_place_iop.odb 2_floorplan.sdc

set_dont_use $::env(DONT_USE_CELLS)

remove_buffers

# Do not buffer chip-level designs
# by default, IO ports will be buffered
# to not buffer IO ports, set environment variable
# DONT_BUFFER_PORT = 1
if { ![env_var_exists_and_non_empty FOOTPRINT] } {
  if { ![env_var_equals DONT_BUFFER_PORTS 1] } {
    puts "Perform port buffering..."
    buffer_ports
  }
}

if { [env_var_exists_and_non_empty FASTROUTE_TCL] } {
  log_cmd source $::env(FASTROUTE_TCL)
} else {
  log_cmd \
    set_global_routing_layer_adjustment \
    $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) $::env(ROUTING_LAYER_ADJUSTMENT)
  log_cmd set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
}

set global_placement_args {}

# Parameters for routability mode in global placement
append_env_var global_placement_args GPL_ROUTABILITY_DRIVEN -routability_driven 0

# Parameters for timing driven mode in global placement
if { $::env(GPL_TIMING_DRIVEN) } {
  lappend global_placement_args {-timing_driven}
  if { [info exists ::env(GPL_KEEP_OVERFLOW)] } {
    lappend global_placement_args -keep_resize_below_overflow $::env(GPL_KEEP_OVERFLOW)
  }
}

proc do_placement { global_placement_args } {
  set all_args [concat [list -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)] \
    $global_placement_args]

  lappend all_args {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS]

  log_cmd global_placement {*}$all_args
}

set result [catch { do_placement $global_placement_args } errMsg]
if { $result != 0 } {
  write_db $::env(RESULTS_DIR)/3_3_place_gp-failed.odb
  error $errMsg
}

estimate_parasitics -placement

if { [env_var_equals CLUSTER_FLOPS 1] } {
  cluster_flops
  estimate_parasitics -placement
}

report_metrics 3 "global place" false false

write_db $::env(RESULTS_DIR)/3_3_place_gp.odb
