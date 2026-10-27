source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan

load_design 2_2_floorplan_macro.odb
source_step_tcl PRE TAPCELL

if { [env_var_exists_and_non_empty TAPCELL_TCL] } {
  source $::env(TAPCELL_TCL)
} else {
  cut_rows
}

source_step_tcl POST TAPCELL

report_design_area

orfs_write_db $::env(RESULTS_DIR)/2_3_floorplan_tapcell.odb
