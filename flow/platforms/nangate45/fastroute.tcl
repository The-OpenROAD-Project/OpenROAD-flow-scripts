set_global_routing_layer_adjustment 2 0.8
set_global_routing_layer_adjustment 3 0.7
set_global_routing_layer_adjustment 4-$::env(MAX_ROUTING_LAYER) 0.4

global_route -guide_file $::env(RESULTS_DIR)/route.guide \
             -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
             -overflow_iterations 100 \
             -macro_extension 2 \
             -verbose 2 \
