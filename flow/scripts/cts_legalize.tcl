opendp_external odp

# Import LEF/DEF files
odp import_lef $::env(OBJECTS_DIR)/merged_padded.lef
odp import_def $::env(RESULTS_DIR)/run/cts_no_dummies.def

# Initialize and run
odp init_opendp
odp legalize_place

# Export DEF file
odp export_def $::env(RESULTS_DIR)/run/cts_final.def

exit
