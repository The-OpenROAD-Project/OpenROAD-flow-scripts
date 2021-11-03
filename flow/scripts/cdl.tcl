source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_1_fill.db 6_final.sdc "Starting CDL"

cdl read_masters $::env(CDL_FILE)
cdl out $::env(RESULTS_DIR)/6_final.cdl

if {![info exists standalone] || $standalone} {
  exit
}
