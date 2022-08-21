set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) -clock $env(MIN_CLOCK_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
set_macro_extension 2
