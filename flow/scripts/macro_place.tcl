source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_3_floorplan_tdms.odb 1_synth.sdc "Starting macro placement"

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_4_floorplan_macro.odb
}
