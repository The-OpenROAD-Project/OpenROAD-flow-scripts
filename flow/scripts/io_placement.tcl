source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_1_place_gp_skip_io.odb 2_floorplan.sdc "Starting io placement"

if {[info exists ::env(IO_CONSTRAINTS)]} {
  source $::env(IO_CONSTRAINTS)
}
place_pins -hor_layer $::env(IO_PLACER_H) \
           -ver_layer $::env(IO_PLACER_V) \
           {*}$::env(PLACE_PINS_ARGS)

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/3_2_place_iop.odb
}
