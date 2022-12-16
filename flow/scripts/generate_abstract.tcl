source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_1_fill.odb 6_1_fill.sdc "Starting generation of abstract views"
 
puts "Starting generation of abstract views"
write_timing_model $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lib
write_abstract_lef $::env(RESULTS_DIR)/$::env(DESIGN_NAME).lef

if {[info exist ::env(CDL_FILES)]} {
  cdl read_masters $::env(CDL_FILES)
  cdl out $::env(RESULTS_DIR)/6_final.cdl
}

if {![info exists standalone] || $standalone} {
  exit
}
