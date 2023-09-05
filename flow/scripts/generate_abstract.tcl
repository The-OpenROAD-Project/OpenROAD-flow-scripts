source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_final.odb 6_final.sdc "Starting generation of abstract views"

read_spef $::env(RESULTS_DIR)/6_final.spef
set_propagated_clock [all_clocks]

puts "Starting generation of abstract views"
write_timing_model $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lib
write_abstract_lef -bloat_occupied_layers $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lef

if {[info exist ::env(CDL_FILES)]} {
  cdl read_masters $::env(CDL_FILES)
  cdl out $::env(RESULTS_DIR)/6_final.cdl
}

if {![info exists standalone] || $standalone} {
  exit
}
