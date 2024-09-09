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

# -hold_margin is only set when hold_margin is set, default 1
proc repair_timing_helper { {hold_margin 1} } {
  set additional_args "-verbose"
  append_env_var additional_args SETUP_SLACK_MARGIN -setup_margin 1
  if {$hold_margin} {
    append_env_var additional_args HOLD_SLACK_MARGIN -hold_margin 1
  }
  append_env_var additional_args TNS_END_PERCENT -repair_tns 1
  append_env_var additional_args SKIP_PIN_SWAP -skip_pin_swap 0
  append_env_var additional_args SKIP_GATE_CLONING -skip_gate_cloning 0
  append_env_var additional_args SKIP_BUFFER_REMOVAL -skip_buffer_removal 0
  puts "repair_timing [join $additional_args " "]"
  repair_timing {*}$additional_args
}
