source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_1_floorplan.odb 1_synth.sdc

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

write_db $::env(RESULTS_DIR)/2_floorplan_debug_macros.odb
