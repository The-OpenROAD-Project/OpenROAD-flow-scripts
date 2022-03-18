source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_2_place_iop.odb 2_floorplan.sdc "Starting global placement"


write_def $::env(RESULTS_DIR)/3_2_place_iop.def
write_verilog $::env(RESULTS_DIR)/3_2_place_iop.v

exit
