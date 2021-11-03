source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_5_floorplan_tapcell.odb 1_synth.sdc "Starting PDN generation"

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
  write_db $::env(RESULTS_DIR)/2_6_floorplan_pdn.odb

  if {[info exists ::env(POST_PDN_TCL)] && [file exists $::env(POST_PDN_TCL)]} {
    source $::env(POST_PDN_TCL)
  }

  exit
}
