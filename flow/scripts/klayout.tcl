if {[info exists ::env(FILL_CONFIG)]} {
    set fill_config $::env(FILL_CONFIG)
} else {
    set fill_config ""
}

if {[info exists ::env(SEAL_GDS)]} {
    set seal_gds $::env(SEAL_GDS)
} else {
    set seal_gds ""
}

exec klayout -zz -rd design_name=$::env(DESIGN_NAME) \
	         -rd in_def=$::env(RESULTS_DIR)/6_final.def \
	         -rd in_gds="$::env(GDS_FILES) $::env(WRAPPED_GDS)" \
	         -rd config_file=$fill_config \
	         -rd seal_gds=$seal_gds \
	         -rd out_gds=$::env(RESULTS_DIR)/6_1_merged.gds \
	         -rd tech_file=$::env(OBJECTS_DIR)/klayout.lyt \
	         -rm $::env(UTILS_DIR)/def2gds.py
