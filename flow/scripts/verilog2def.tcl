if {![info exists standalone] || $standalone} {
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read lef and verilog
  read_verilog $::env(RESULTS_DIR)/1_synth.v

  link_design $::env(DESIGN_NAME)
}

# create floorplan
if {[info exists ::env(CORE_UTILIZATION)] && $::env(CORE_UTILIZATION) != "" } {
  initialize_floorplan -utilization $::env(CORE_UTILIZATION) \
                       -aspect_ratio $::env(CORE_ASPECT_RATIO) \
                       -core_space $::env(CORE_MARGIN) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site $::env(PLACE_SITE)
} else {
  initialize_floorplan -die_area $::env(DIE_AREA) \
                       -core_area $::env(CORE_AREA) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site $::env(PLACE_SITE)
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_1_floorplan.def
  exit
}
