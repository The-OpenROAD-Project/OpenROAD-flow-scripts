if {![info exists standalone] || $standalone} {
  # Read lef
  if [info exists ::env(GENERIC_TECH_LEF)] {
    read_lef $::env(GENERIC_TECH_LEF)
  } else {
    read_lef $::env(TECH_LEF)
  }
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
  read_def $::env(RESULTS_DIR)/4_cts.def
} else {
  puts "Starting detailed routing"
}

detailed_route -param $::env(OBJECTS_DIR)/TritonRoute.param
write_def $::env(RESULTS_DIR)/5_route.def
if {![info exists standalone] || $standalone} {
  exit
}
