source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
dump_stage_variables place
load_design 2_floorplan.odb 2_floorplan.sdc
source_step_tcl PRE GLOBAL_PLACE_SKIP_IO

if { [env_var_exists_and_non_empty FLOORPLAN_DEF] } {
  puts "FLOORPLAN_DEF is set. Skipping global placement without IOs"
} elseif { [all_pins_placed] } {
  puts "All pins are placed. Skipping global placement without IOs"
} else {
  log_cmd global_placement -skip_io -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS]
}

source_step_tcl POST GLOBAL_PLACE_SKIP_IO

orfs_write_db $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb
