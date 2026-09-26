source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_final.odb 6_final.sdc

source $::env(UTILS_DIR)/write_rc_helper.tcl

estimate_parasitics -global_routing
fetch_nets_rc grt_nets_rc

# Use STA to load and fetch nets' parasitics.
read_spef $::env(RESULTS_DIR)/6_final.spef
fetch_nets_rc rcx_nets_rc

write_nets_rc_csv $::env(RESULTS_DIR)/6_nets_rc.csv grt_nets_rc rcx_nets_rc

# Use RCX to compute and ODB APIs to fetch segments' parasitics.
# We set up RCX parameters to avoid any parasitics segment merging.
extract_parasitics -ext_model_file $::env(RCX_RULES) -max_res 0 -no_merge_via_res
fetch_segments_rc segments_rc

write_segments_rc_csv $::env(RESULTS_DIR)/6_segments_rc.csv segments_rc
