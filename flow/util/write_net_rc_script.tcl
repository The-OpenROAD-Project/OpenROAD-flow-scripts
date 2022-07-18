source $::env(SCRIPTS_DIR)/load.tcl
# Note 6_final.def has wires that prevent global routing.
load_design 4_1_cts.odb 4_cts.sdc ""

source $::env(UTILS_DIR)/write_net_rc.tcl

estimate_parasitics -placement
record_wire_rc gpl

if {[info exist env(FASTROUTE_TCL)]} {
  source $env(FASTROUTE_TCL)
} else {
  set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
  set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
  set_macro_extension 2
}

global_route -congestion_iterations 100

estimate_parasitics -global_routing
record_wire_rc grt

read_spef -quiet -reduce_to pi_elmore $::env(RESULTS_DIR)/6_final.spef
record_wire_rc rcx

#compare_wire_rc 50 grt rcx

# write gpl/grt/rcx rc file for correlateRC.py
write_rc_csv $::env(RESULTS_DIR)/6_net_rc.csv
