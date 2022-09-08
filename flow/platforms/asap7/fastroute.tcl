set_global_routing_layer_adjustment M1 0.1
set_global_routing_layer_adjustment M2 0.3
set_global_routing_layer_adjustment M3 0.8
set_global_routing_layer_adjustment M4 0.7
set_global_routing_layer_adjustment M5 0.7
set_global_routing_layer_adjustment M6-$::env(MAX_ROUTING_LAYER) 0.5

set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) -clock $env(MIN_CLOCK_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
set_macro_extension 2
