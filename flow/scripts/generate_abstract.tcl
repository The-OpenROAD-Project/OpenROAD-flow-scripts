source $::env(SCRIPTS_DIR)/load.tcl

set stem [expr {[info exists ::env(ABSTRACT_SOURCE)] ? $::env(ABSTRACT_SOURCE) : "6_final"}]

load_design $stem.odb $stem.sdc "Starting generation of abstract views"

if {[file exists $::env(RESULTS_DIR)/$stem.spef]} {
  read_spef $::env(RESULTS_DIR)/$stem.spef
  set_propagated_clock [all_clocks]
}

puts "Starting generation of abstract views"
write_timing_model $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lib
write_abstract_lef -bloat_occupied_layers $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lef

if {[info exist ::env(CDL_FILES)]} {
  cdl read_masters $::env(CDL_FILES)
  cdl out $::env(RESULTS_DIR)/$stem.cdl
}

if {![info exists standalone] || $standalone} {
  exit
}
