source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_floorplan.odb 2_floorplan.sdc "Starting global placement"

if {[info exists ::env(FLOORPLAN_DEF)] || ([info exists ::env(HAS_IO_CONSTRAINTS)] && $::env(HAS_IO_CONSTRAINTS) != 0)} {
  puts "Has top down IO Constraints. Skip global placement without IOs"
} else {
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

  if { 0 != [llength [array get ::env GLOBAL_PLACEMENT_ARGS]] } {
  global_placement -skip_io -density $place_density \
      -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
      -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
      {*}$::env(GLOBAL_PLACEMENT_ARGS)
  } else {
  global_placement -skip_io -density $place_density \
      -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
      -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
  }
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb
}
