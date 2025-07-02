set_global_routing_layer_adjustment M2 0.6
set_global_routing_layer_adjustment M3 0.6
set_global_routing_layer_adjustment C4-C5 0.5
set_global_routing_layer_adjustment K1-K4 0.45

set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
  -clock K1-$::env(MAX_ROUTING_LAYER)
