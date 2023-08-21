source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_1_floorplan.odb 1_synth.sdc "Debug floorplan"

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_floorplan_debug_macros.odb
}
