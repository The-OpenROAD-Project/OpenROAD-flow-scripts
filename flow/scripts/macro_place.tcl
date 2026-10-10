source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_1_floorplan.odb 2_1_floorplan.sdc
source_step_tcl PRE MACRO_PLACE

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

source_step_tcl POST MACRO_PLACE

# register files in `mode netlist` become their cells
source $::env(SCRIPTS_DIR)/regfile_dissolve.tcl

report_design_area

orfs_write_db $::env(RESULTS_DIR)/2_2_floorplan_macro.odb
write_macro_placement $::env(RESULTS_DIR)/2_2_floorplan_macro.tcl
