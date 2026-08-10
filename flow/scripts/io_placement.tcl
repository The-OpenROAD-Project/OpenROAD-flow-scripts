source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place

if {
  [env_var_exists_and_non_empty FLOORPLAN_DEF] ||
  [env_var_exists_and_non_empty FOOTPRINT] ||
  [env_var_exists_and_non_empty FOOTPRINT_TCL]
} {
  puts "Pin placement already provided by floorplan initialization. Writing empty placeholder script."
  close [open $::env(RESULTS_DIR)/3_1_place_iop.tcl w]
} else {
  load_design 2_floorplan.odb 2_floorplan.sdc
  source_step_tcl PRE IO_PLACEMENT

  set global_placement_args {}
  append_env_var global_placement_args GPL_RANDOM_SEED -random_seed 1

  log_cmd global_placement -skip_io -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS] \
    {*}$global_placement_args

  log_cmd place_pins \
    -hor_layers $::env(IO_PLACER_H) \
    -ver_layers $::env(IO_PLACER_V) \
    {*}[env_var_or_empty PLACE_PINS_ARGS]

  report_design_area

  write_pin_placement $::env(RESULTS_DIR)/3_1_place_iop.tcl

  if { [env_var_exists_and_non_empty DEBUG_IO_PLACEMENT_ODB] } {
    orfs_write_db $::env(RESULTS_DIR)/3_1_place_iop_debug.odb
  }

  source_step_tcl POST IO_PLACEMENT
}
