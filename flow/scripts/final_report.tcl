# Split around the 6_final.odb write so a single-process flow
# (scripts/flow.tcl) can source the parts and perform the write itself
# at the same point.
source $::env(SCRIPTS_DIR)/final_connect.tcl
orfs_write_db $::env(RESULTS_DIR)/6_final.odb
orfs_write_sdc $::env(RESULTS_DIR)/6_final.sdc
source $::env(SCRIPTS_DIR)/final_outputs.tcl
