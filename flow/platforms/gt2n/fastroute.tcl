set_global_routing_layer_adjustment M2-M3 0.5
set_global_routing_layer_adjustment M4-$::env(MAX_ROUTING_LAYER) 0.25

set_routing_layers -clock $::env(MIN_CLK_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
