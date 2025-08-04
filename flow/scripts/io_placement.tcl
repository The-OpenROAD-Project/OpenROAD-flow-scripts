source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place

if {
  ![env_var_exists_and_non_empty FLOORPLAN_DEF] &&
  ![env_var_exists_and_non_empty FOOTPRINT] &&
  ![env_var_exists_and_non_empty FOOTPRINT_TCL]
} {
  load_design 2_floorplan.odb 2_floorplan.sdc
  # Need some information to do IO placement, so do a global placement
  log_cmd global_placement -skip_io -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS]
  log_cmd place_pins \
    -hor_layers $::env(IO_PLACER_H) \
    -ver_layers $::env(IO_PLACER_V) \
    {*}[env_var_or_empty PLACE_PINS_ARGS]
  write_db $::env(RESULTS_DIR)/3_1_place_iop.odb
  write_pin_placement $::env(RESULTS_DIR)/3_1_place_iop.tcl
} else {
  log_cmd exec cp $::env(RESULTS_DIR)/2_floorplan.odb $::env(RESULTS_DIR)/3_1_place_iop.odb
}
