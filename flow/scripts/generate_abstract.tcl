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

  # Read def and sdc
  # Use -order_wires to build wire graph
  # for antenna checker read_def -order_wires $::env(RESULTS_DIR)/6_1_fill.def
  read_def $::env(RESULTS_DIR)/6_1_fill.def
  puts "Starting genration of abstract views"
# echo "ADDITIONAL_LEFS += $::env(RESULTS_DIR)/$::env(DESIGN_NICKNAME).lef" > $::env(RESULTS_DIR)/ADDITIONAL_VIEWS.mk
# echo "ADDITIONAL_LIBS += $::env(RESULTS_DIR)/$::env(DESIGN_NICKNAME).lib" >> $::env(RESULTS_DIR)/ADDITIONAL_VIEWS.mk
    
 source scripts/generate_lef.tcl 
} else {
  puts "Starting genration of abstract views"
  
 # echo "ADDITIONAL_LEFS += $::env(RESULTS_DIR)/$::env(DESIGN_NICKNAME).lef" > $::env(RESULTS_DIR)/ADDITIONAL_VIEWS.mk
 # echo "ADDITIONAL_LIBS += $::env(RESULTS_DIR)/$::env(DESIGN_NICKNAME).lib" >> $::env(RESULTS_DIR)/ADDITIONAL_VIEWS.mk
}


source scripts/generate_lef.tcl
#source scripts/generate_libs.tcl
#
#if {![info exists standalone] || $standalone} {
#  exit
#}
