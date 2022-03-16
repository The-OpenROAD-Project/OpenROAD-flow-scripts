source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_1_floorplan.odb 1_synth.sdc "Starting random IO placement"

if {[info exists ::env(IO_CONSTRAINTS)]} {
  source $::env(IO_CONSTRAINTS)
}
place_pins -hor_layer $::env(IO_PLACER_H) \
           -ver_layer $::env(IO_PLACER_V) \
           -random \
           {*}$::env(PLACE_PINS_ARGS)

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_2_floorplan_io.odb
}
