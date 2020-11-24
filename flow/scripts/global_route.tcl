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
  for {set layer $::env(MIN_ROUTING_LAYER)} {$layer <= $::env(MAX_ROUTING_LAYER)} {incr layer} {
    set_global_routing_layer_adjustment $layer 0.5
  }

  global_route -guide_file $::env(RESULTS_DIR)/route.guide \
            -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
            -unidirectional_routing \
            -overflow_iterations 100 \
            -macro_extension 2 \
            -verbose 2
}

if {![info exists standalone] || $standalone} {
  exit
}
