# Timing-driven global placement with RePlAce

foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}

# Import LEF/DEF files
read_lef $::env(OBJECTS_DIR)/merged_padded.lef
read_def $::env(RESULTS_DIR)/2_floorplan.def

# timing-driven parameters
read_verilog $::env(RESULTS_DIR)/2_floorplan.v
read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc

global_placement -timing_driven -wire_cap $::env(CAP_PER_MICRON) \
  -wire_res $::env(RES_PER_MICRON)

legalize_placement

# Export DEF file
write_def $::env(RESULTS_DIR)/replace/3_1_place_gp.def

if {[info exists standalone] && $standalone} {
  # Do nothing
} else {
  exit
}
