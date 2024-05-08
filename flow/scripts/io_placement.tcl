source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_1_place_gp_skip_io.odb 2_floorplan.sdc

source $::env(SCRIPTS_DIR)/io_placement_util.tcl

write_db $::env(RESULTS_DIR)/3_2_place_iop.odb
