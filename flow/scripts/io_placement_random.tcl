if {![info exists ::env(IS_CHIP)]} {
  file copy -force $::env(RESULTS_DIR)/2_1_floorplan.odb $::env(RESULTS_DIR)/2_2_floorplan_io.odb
  # Ouch! The file date is copied by Tcl, but the precision is seconds, so
  # this means that a copied file can be *older* than the source, or
  # worse, older than some *other* dependency for this target.
  exec touch $::env(RESULTS_DIR)/2_2_floorplan_io.odb
  exit
}

source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_1_floorplan.odb 1_synth.sdc "Starting random IO placement"

if {[info exists ::env(FLOORPLAN_DEF)]} {
    puts "Skipping IO placement as DEF file was used to initialize floorplan."
} else {
  if {[info exists ::env(IO_CONSTRAINTS)]} {
    source $::env(IO_CONSTRAINTS)
  }
  place_pins -hor_layer $::env(IO_PLACER_H) \
           -ver_layer $::env(IO_PLACER_V) \
           -random \
           {*}$::env(PLACE_PINS_ARGS)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_2_floorplan_io.odb
}
