source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_1_fill.odb 6_1_fill.sdc "Starting generation of abstract views"

source scripts/generate_lef.tcl 
