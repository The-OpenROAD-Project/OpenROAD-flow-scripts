source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_1_fill.odb 6_final.sdc "Starting CDL"

write_cdl -masters $::env(CDL_FILE) $::env(RESULTS_DIR)/6_final.cdl
