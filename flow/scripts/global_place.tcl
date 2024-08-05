utl::set_metrics_stage "globalplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_2_place_iop.odb 2_floorplan.sdc

set_dont_use $::env(DONT_USE_CELLS)

# set fastroute layer reduction
if {[info exist env(FASTROUTE_TCL)]} {
  source $env(FASTROUTE_TCL)
} else {
  set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
  set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
  if {[info exist env(MACRO_EXTENSION)]} {
    set_macro_extension $env(MACRO_EXTENSION)
  }
}

source $::env(SCRIPTS_DIR)/set_place_density.tcl

set global_placement_args {}

# Parameters for routability mode in global placement
if {$::env(GPL_ROUTABILITY_DRIVEN)} {
  lappend global_placement_args {-routability_driven}
    if { [info exists ::env(GPL_TARGET_RC)] } { 
      lappend global_placement_args {-routability_target_rc_metric} $::env(GPL_TARGET_RC)
  }
}

# Parameters for timing driven mode in global placement
if {$::env(GPL_TIMING_DRIVEN)} {
  lappend global_placement_args {-timing_driven}
}

proc do_placement {place_density global_placement_args} {
  set all_args [concat [list -density $place_density \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)] \
    $global_placement_args]

  if { 0 != [llength [array get ::env GLOBAL_PLACEMENT_ARGS]] } {
    lappend all_args {*}$::env(GLOBAL_PLACEMENT_ARGS)
  }

  log_cmd global_placement {*}$all_args
}

set result [catch {do_placement $place_density $global_placement_args} errMsg]
if {$result != 0} {
  write_db $::env(RESULTS_DIR)/3_3_place_gp-failed.odb
  error $errMsg
}

estimate_parasitics -placement

if {[info exist ::env(CLUSTER_FLOPS)]} {
  cluster_flops
  estimate_parasitics -placement
}

report_metrics 5 "global place" false false

write_db $::env(RESULTS_DIR)/3_3_place_gp.odb
