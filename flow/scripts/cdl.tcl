source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables final
load_design 6_final.odb

write_cdl -include_fillers -masters $::env(CDL_FILE) $::env(RESULTS_DIR)/6_final.cdl
