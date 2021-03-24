if {![info exists standalone] || $standalone} {
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

  # Read design files
  # Read SDC and derating files
  read_def $::env(RESULTS_DIR)/4_cts.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
  if [file exists $::env(PLATFORM_DIR)/derate_final.tcl] {
    source $::env(PLATFORM_DIR)/derate_final.tcl
    puts "derate_final.tcl sourced"
  }
} else {
  puts "Starting global routing"
}

if {[info exist ::env(FASTROUTE_TCL)]} {
  source $::env(FASTROUTE_TCL)
} else {
  for {set layer $::env(MIN_ROUTING_LAYER)} {$layer <= $::env(MAX_ROUTING_LAYER)} {incr layer} {
    set_global_routing_layer_adjustment $layer 0.5
  }

  global_route -guide_file $::env(RESULTS_DIR)/route.guide \
            -layers $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) \
            -overflow_iterations 100 \
            -macro_extension 2 \
            -verbose 2
}


# Set res and cap
if [file exists $::env(PLATFORM_DIR)/setRC.tcl] {
  source $::env(PLATFORM_DIR)/setRC.tcl
}

set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

source $::env(SCRIPTS_DIR)/report_metrics.tcl

puts "\n=========================================================================="
puts "check_antennas"
puts "--------------------------------------------------------------------------"
check_antennas -report_file antenna.log


if {![info exists standalone] || $standalone} {
  exit
}
