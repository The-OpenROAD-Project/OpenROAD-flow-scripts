if {[info exists ::env(FLOORPLAN_DEF)]} {
    puts "Skipping IO placement as DEF file was used to initialize floorplan."
} else {
  if {[info exists ::env(IO_CONSTRAINTS)]} {
    source $::env(IO_CONSTRAINTS)
  }
  set args [list -hor_layer $::env(IO_PLACER_H) \
           -ver_layer $::env(IO_PLACER_V) \
           {*}$::env(PLACE_PINS_ARGS)]
  log_cmd place_pins {*}$args
}
