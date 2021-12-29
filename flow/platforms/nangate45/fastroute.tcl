set_global_routing_layer_adjustment metal2 0.8
set_global_routing_layer_adjustment metal3 0.7
set_global_routing_layer_adjustment metal4-$::env(MAX_ROUTING_LAYER) 0.25

set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
set_macro_extension 2
