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

  read_def $::env(RESULTS_DIR)/6_final.def

  read_sdc $::env(RESULTS_DIR)/3_place.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }

  source $::env(PLATFORM_DIR)/setRC.tcl
  set_propagated_clock [all_clocks]

  if {[info exist ::env(RCX_RULES)]} {
    puts "Loading spef"
#    read_spef $::env(RESULTS_DIR)/6_final.spef
  } else {
    puts "Estimating parasitics"
#    estimate_parasitics -placement
  }
}
