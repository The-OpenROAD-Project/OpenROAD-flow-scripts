for {set layer $::env(MIN_ROUTING_LAYER)} {$layer <= $::env(MAX_ROUTING_LAYER)} {incr layer} {
  set_global_routing_layer_adjustment $layer 0.5
}

set_global_routing_layer_pitch 2 0.37
set_global_routing_layer_pitch 3 0.48
set_global_routing_layer_pitch 4 0.74
set_global_routing_layer_pitch 5 0.96
# set_global_routing_layer_pitch 6 3.33

fastroute -guide_file $::env(RESULTS_DIR)/route.guide \
          -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
          -unidirectional_routing true \
          -layers_adjustments {{2 0.5} {3 0.5} {4 0.5} {5 0.5}}  \
          -overflow_iterations 100 \
	      -verbose 2 \
