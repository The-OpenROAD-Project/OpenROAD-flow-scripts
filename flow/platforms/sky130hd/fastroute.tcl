set_global_routing_layer_adjustment $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) 0.5

set_global_routing_layer_pitch 2 0.34
set_global_routing_layer_pitch 3 0.46
set_global_routing_layer_pitch 4 0.68
set_global_routing_layer_pitch 5 0.92
set_global_routing_layer_pitch 6 3.40

global_route -guide_file $::env(RESULTS_DIR)/route.guide \
          -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
          -unidirectional_routing \
          -overflow_iterations 100 \
	      -verbose 2 \
