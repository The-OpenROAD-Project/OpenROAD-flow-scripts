utl::set_metrics_stage "globalroute__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 5_1_grt.odb 4_cts.sdc "Starting fill cell"

set_propagated_clock [all_clocks]

filler_placement $::env(FILL_CELLS)
check_placement

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/5_2_fillcell.odb
}
