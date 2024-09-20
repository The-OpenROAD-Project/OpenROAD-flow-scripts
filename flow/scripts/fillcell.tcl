if {[expr [file exists $::env(REPORTS_DIR)/congestion.rpt] && \
    [file size $::env(REPORTS_DIR)/congestion.rpt] != 0]} {
  error "Global routing failed, run `make gui_grt` and load $::env(REPORTS_DIR)/congestion.rpt \
    in DRC viewer to view congestion"
}

source $::env(SCRIPTS_DIR)/load.tcl
load_design 5_2_route.odb 4_cts.sdc

set_propagated_clock [all_clocks]

filler_placement $::env(FILL_CELLS)
check_placement

write_db $::env(RESULTS_DIR)/5_3_fillcell.odb
