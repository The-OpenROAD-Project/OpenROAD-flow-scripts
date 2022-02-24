source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_floorplan.odb 2_floorplan.sdc "Starting global placement"

set_dont_use $::env(DONT_USE_CELLS)

# set fastroute layer reduction
if {[info exist env(FASTROUTE_TCL)]} {
  source $env(FASTROUTE_TCL)
} else {
  set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
  set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
  set_macro_extension 2
}

# check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON if it exists
if {[info exist ::env(PLACE_DENSITY_LB_ADDON)]} {
  set place_density_lb [gpl::get_global_placement_uniform_density \
  -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
  -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)]
  set place_density [expr $place_density_lb + $::env(PLACE_DENSITY_LB_ADDON) + 0.01]
  if {$place_density > 1.0} {
    set place_density 1.0
  }
} else {
  set place_density $::env(PLACE_DENSITY)
}

set global_placement_args ""
if {$::env(GPL_ROUTABILITY_DRIVEN)} {
    append global_placement_args " -routability_driven"
}
if {$::env(GPL_TIMING_DRIVEN)} {
    append global_placement_args " -timing_driven"
}


if { 0 != [llength [array get ::env GLOBAL_PLACEMENT_ARGS]] } {
global_placement -density $place_density \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}$global_placement_args \
    $::env(GLOBAL_PLACEMENT_ARGS)
} else {
global_placement -density $place_density \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}$global_placement_args
}

estimate_parasitics -placement

source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "global place" false

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/3_1_place_gp.odb
}
