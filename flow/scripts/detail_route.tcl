if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TRITON_ROUTE_LEF)

  # Read design files
  read_def $::env(RESULTS_DIR)/4_cts.def
} else {
  puts "Starting detailed routing"
}

detailed_route -param $::env(OBJECTS_DIR)/TritonRoute.param

if {![info exists standalone] || $standalone} {
  exit
}
