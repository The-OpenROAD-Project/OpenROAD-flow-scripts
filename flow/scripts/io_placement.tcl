if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/3_1_place_gp.def
} else {
  puts "Starting io placement"
}

if {![info exists ::env(FOOTPRINT)]} {
  if {[info exists ::env(IO_CONSTRAINTS)]} {
    source $::env(IO_CONSTRAINTS)
  }
  if { 0 != [llength [array get ::env IO_PLACEMENT_MIN_DIST]] } {
  place_pins -hor_layer $::env(IO_PLACER_H) \
             -ver_layer $::env(IO_PLACER_V) \
             -min_distance $::env(IO_PLACEMENT_MIN_DIST)
  } else {
  place_pins -hor_layer $::env(IO_PLACER_H) \
             -ver_layer $::env(IO_PLACER_V)
  }
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/3_2_place_iop.def
  exit
}
