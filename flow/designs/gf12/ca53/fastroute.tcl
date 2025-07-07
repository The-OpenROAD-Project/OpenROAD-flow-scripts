set_global_routing_layer_adjustment M2 0.5
set_global_routing_layer_adjustment M3 0.5
set_global_routing_layer_adjustment C4-K4 0.5
#set_global_routing_layer_adjustment H1-H2 0.5

set_routing_layers -signal M2-$::env(MAX_ROUTING_LAYER) -clock K1-$::env(MAX_ROUTING_LAYER)
