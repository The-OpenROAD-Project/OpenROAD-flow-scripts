source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_final.odb 6_final.sdc

source $::env(UTILS_DIR)/write_net_rc.tcl

estimate_parasitics -global_routing
fetch_nets_rc grt

read_spef $::env(RESULTS_DIR)/6_final.spef
fetch_nets_rc rcx

# write grt/rcx rc file for correlateRC.py
write_nets_rc_csv $::env(RESULTS_DIR)/6_net_rc.csv
