if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TRITON_ROUTE_LEF)

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
