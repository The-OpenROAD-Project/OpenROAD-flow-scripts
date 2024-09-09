proc log_cmd {cmd args} {
  puts "$cmd [join $args " "]"
  $cmd {*}$args
}

proc fast_route {} {
  if {[info exist ::env(FASTROUTE_TCL)]} {
    source $::env(FASTROUTE_TCL)
  } else {
    set_global_routing_layer_adjustment $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) $::env(ROUTING_LAYER_ADJUSTMENT)
    set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
    if {[info exist ::env(MACRO_EXTENSION)]} {
      set_macro_extension $::env(MACRO_EXTENSION)
    }
  }
}
