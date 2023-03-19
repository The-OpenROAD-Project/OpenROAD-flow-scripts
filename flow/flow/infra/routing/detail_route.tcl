utl::set_metrics_stage "detailedroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
if { [info exists ::env(USE_WXL)]} {
  set db_file 4_cts.odb
} else {
  set db_file 5_1_grt.odb
}
load_design $db_file 4_cts.sdc "Starting detailed routing"
set_propagated_clock [all_clocks]

set_thread_count $::env(NUM_CORES)

set additional_args ""
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
  append additional_args " -via_in_pin_bottom_layer $::env(VIA_IN_PIN_MIN_LAYER)"
}
if { [info exists ::env(VIA_IN_PIN_MAX_LAYER)]} {
  append additional_args " -via_in_pin_top_layer $::env(VIA_IN_PIN_MAX_LAYER)"
}
if { [info exists ::env(DISABLE_VIA_GEN)]} {
  append additional_args " -disable_via_gen"
}
if { [info exists ::env(REPAIR_PDN_VIA_LAYER)]} {
  append additional_args " -repair_pdn_vias $::env(REPAIR_PDN_VIA_LAYER)"
}

append additional_args " -save_guide_updates -verbose 1"

# DETAILED_ROUTE_ARGS is used when debugging detailed, route, e.g. append
# "-droute_end_iter 5" to look at routing violations after only 5 iterations,
# speeding up iterations on a problem where detailed routing doesn't converge
# or converges slower than expected.
set arguments [expr {[info exists ::env(DETAILED_ROUTE_ARGS)] ? $::env(DETAILED_ROUTE_ARGS) : $additional_args}]

puts "detailed_route arguments: $arguments"

detailed_route -output_drc $::env(REPORTS_DIR)/5_route_drc.rpt \
               -output_maze $::env(RESULTS_DIR)/maze.log \
               {*}$arguments

if { [info exists ::env(POST_DETAIL_ROUTE_TCL)] } {
  source $::env(POST_DETAIL_ROUTE_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/5_2_route.odb
}
