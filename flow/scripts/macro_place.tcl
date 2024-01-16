source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_3_floorplan_tdms.odb 1_synth.sdc

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

write_db $::env(RESULTS_DIR)/2_4_floorplan_macro.odb
