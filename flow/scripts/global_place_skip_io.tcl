source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_floorplan.odb 2_floorplan.sdc


if { [info exists ::env(FLOORPLAN_DEF)] } {
  puts "FLOORPLAN_DEF is set. Skipping global placement without IOs"
} else {
  source $::env(SCRIPTS_DIR)/set_place_density.tcl

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

write_db $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb
