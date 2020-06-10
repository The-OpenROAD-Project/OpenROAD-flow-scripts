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
  read_def $::env(RESULTS_DIR)/4_cts.def
}

if {[info exist ::env(FASTROUTE_TCL)]} {
  source $::env(FASTROUTE_TCL)
} else {
  fastroute -output_file $::env(RESULTS_DIR)/route.guide \
            -max_routing_layer $::env(MAX_ROUTING_LAYER) \
            -unidirectional_routing true \
            -layers_adjustments {{2 0.5} {3 0.5} {4 0.5} {5 0.5} {6 0.5} {7 0.5} {8 0.5} {9 0.5} {10 0.5}} \
            -overflow_iterations 100 \
	    -verbose 2 \
}

if {![info exists standalone] || $standalone} {
  exit
}
