source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_1_yosys.v 1_1_yosys.sdc
write_sdc -no_timestamp $::env(RESULTS_DIR)/1_synth.sdc
