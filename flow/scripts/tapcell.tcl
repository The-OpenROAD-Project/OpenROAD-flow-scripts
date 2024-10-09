source $::env(SCRIPTS_DIR)/load.tcl

if {[env_var_exists_and_non_empty TAPCELL_TCL]} {
  load_design 2_4_floorplan_macro.odb 1_synth.sdc
  source $::env(TAPCELL_TCL)
  write_db $::env(RESULTS_DIR)/2_5_floorplan_tapcell.odb
} else {
  log_cmd exec cp $::env(RESULTS_DIR)/2_4_floorplan_macro.odb $::env(RESULTS_DIR)/2_5_floorplan_tapcell.odb
}
