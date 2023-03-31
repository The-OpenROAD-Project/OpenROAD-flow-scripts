source $::env(SCRIPTS_DIR)/load.tcl
load_design $::env(ABSTRACT_FROM).odb $::env(ABSTRACT_FROM).sdc "Starting generation of abstract views"
 
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
