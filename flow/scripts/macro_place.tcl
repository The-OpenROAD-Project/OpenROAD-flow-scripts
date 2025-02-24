source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_2_floorplan_io.odb 2_1_floorplan.sdc

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

write_db $::env(RESULTS_DIR)/2_3_floorplan_macro.odb
write_macro_placement $::env(RESULTS_DIR)/2_3_floorplan_macro.tcl
