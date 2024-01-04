source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_4_floorplan_macro.odb 1_synth.sdc

if {[info exist ::env(TAPCELL_TCL)]} {
  source $::env(TAPCELL_TCL)
}

write_db $::env(RESULTS_DIR)/2_5_floorplan_tapcell.odb
