source $::env(SCRIPTS_DIR)/load.tcl

set stem [expr {[info exists ::env(ABSTRACT_SOURCE)] ? $::env(ABSTRACT_SOURCE) : "6_final"}]

set design_stage [lindex [split [file tail $stem] "_"] 0]

load_design $stem.odb $stem.sdc

if {$design_stage >= 6 && [file exists $::env(RESULTS_DIR)/$stem.spef]} {
  read_spef $::env(RESULTS_DIR)/$stem.spef
} elseif {$design_stage >= 3} {
  puts "Estimating parasitics"
  estimate_parasitics -placement
}

if {$design_stage >= 4} {
  set_propagated_clock [all_clocks]
}

puts "Generating abstract views"
write_timing_model $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lib
write_abstract_lef -bloat_occupied_layers $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lef

if {[info exist ::env(CDL_FILES)]} {
  cdl read_masters $::env(CDL_FILES)
  cdl out $::env(RESULTS_DIR)/$stem.cdl
}
