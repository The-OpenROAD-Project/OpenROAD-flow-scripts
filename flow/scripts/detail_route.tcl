if {![info exists standalone] || $standalone} {
  # Read lef
  if [info exists ::env(GENERIC_TECH_LEF)] {
    read_lef $::env(GENERIC_TECH_LEF)
  } else {
    read_lef $::env(TECH_LEF)
  }
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  read_def $::env(RESULTS_DIR)/4_cts.def
} else {
  puts "Starting detailed routing"
}

set_thread_count $::env(NUM_CORES)

set additional_args ""
if { ![info exists ::env(USE_WXL)]} {
  append additional_args " -guide $::env(RESULTS_DIR)/route.guide"
}
if { [info exists ::env(dbProcessNode)]} {
  append additional_args " -db_process_node $::env(dbProcessNode)"
}
if { [info exists ::env(OR_SEED)]} {
  append additional_args " -or_seed $::env(OR_SEED)"
}
if { [info exists ::env(OR_K)]} {
  append additional_args " -or_k $::env(OR_K)"
}

if { [info exists ::env(MIN_ROUTING_LAYER)]} {
  append additional_args " -bottom_routing_layer $::env(MIN_ROUTING_LAYER)"
}
if { [info exists ::env(MAX_ROUTING_LAYER)]} {
  append additional_args " -top_routing_layer $::env(MAX_ROUTING_LAYER)"
}
if { [info exists ::env(VIA_IN_PIN_MIN_LAYER)]} {
  append additional_args " -droute_via_in_pin_bottom_layer_num $::env(VIA_IN_PIN_MIN_LAYER)"
}
if { [info exists ::env(VIA_IN_PIN_MAX_LAYER)]} {
  append additional_args " -droute_via_in_pin_top_layer_num $::env(VIA_IN_PIN_MAX_LAYER)"
}


detailed_route -output_drc $::env(REPORTS_DIR)/5_route_drc.rpt \
               -output_guide $::env(RESULTS_DIR)/output_guide.mod \
               -output_maze $::env(RESULTS_DIR)/maze.log \
               -verbose 1 \
               {*}$additional_args

write_def $::env(RESULTS_DIR)/5_route.def

# post routing user TCL script hook
if { [info exists ::env(POST_DETAIL_ROUTE_TCL)] } {
  source $::env(POST_DETAIL_ROUTE_TCL)
}
