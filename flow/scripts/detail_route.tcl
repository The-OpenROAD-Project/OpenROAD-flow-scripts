if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/4_cts.def
}

detailed_route -param $::env(OBJECTS_DIR)/TritonRoute.param

if {![info exists standalone] || $standalone} {
  exit
}
