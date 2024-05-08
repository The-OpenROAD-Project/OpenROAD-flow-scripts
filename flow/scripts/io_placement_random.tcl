source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_1_floorplan.odb 1_synth.sdc

lappend ::env(PLACE_PINS_ARGS) -random

source $::env(SCRIPTS_DIR)/io_placement_util.tcl

write_db $::env(RESULTS_DIR)/2_2_floorplan_io.odb
