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
  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  read_def $::env(RESULTS_DIR)/2_5_floorplan_tapcell.def
} else {
  puts "Starting PDN generation"
}

if {[info exist ::env(PDN_TCL)]} {
  source $::env(PDN_TCL)
  pdngen -verbose
} elseif {[info exist ::env(PDN_CFG)]} {
  pdngen $::env(PDN_CFG) -verbose
}

#foreach net_name [concat $::power_nets $::ground_nets] {
#  check_power_grid -net $net_name
#}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_6_floorplan_pdn.def
}

if {[info exists ::env(POST_PDN_TCL)] && [file exists $::env(POST_PDN_TCL)]} {
  source $::env(POST_PDN_TCL)
}
