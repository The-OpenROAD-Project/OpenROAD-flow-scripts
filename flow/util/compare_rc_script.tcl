source $::env(UTILS_DIR)/compare_rc.tcl

set golden_spef ""
set sta_report_default_digits 4

# Read lef
read_lef $::env(TECH_LEF)
read_lef $::env(SC_LEF)
if {[info exist ::env(ADDITIONAL_LEFS)]} {
  foreach lef $::env(ADDITIONAL_LEFS) {
    read_lef $lef
  }
}

# Read liberty files
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}

# Note 6_final.def has wires that prevent global routing.
read_def $env(RESULTS_DIR)/4_cts.def

source $::env(PLATFORM_DIR)/setRC.tcl

estimate_parasitics -placement
record_wire_caps gpl

if {[info exist env(FASTROUTE_TCL)]} {
  source $env(FASTROUTE_TCL)
} else {
  set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
  set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
  set_macro_extension 2
}

global_route

estimate_parasitics -global_routing
record_wire_caps grt

read_spef -quiet $::env(RESULTS_DIR)/6_final.spef
record_wire_caps rcx

# write gpl/grt/rcx capacitances file for correlateRC.py
write_caps_csv $::env(RESULTS_DIR)/6_net_caps.csv
