source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 2_floorplan.odb 2_floorplan.sdc

if { [env_var_exists_and_non_empty FLOORPLAN_DEF] } {
  puts "FLOORPLAN_DEF is set. Skipping global placement without IOs"
} else {    
  set all_args [concat [list -skip_io -density [place_density_with_lb_addon] \
      -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
      -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) ] ]
  append_env_var all_args GPL_ALLOW_REVERT_IF_DIVERGE -allow_revert_if_diverge 0
  lappend all_args {*}$::env(GLOBAL_PLACEMENT_ARGS)
  
  log_cmd global_placement {*}$all_args
}

write_db $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb
