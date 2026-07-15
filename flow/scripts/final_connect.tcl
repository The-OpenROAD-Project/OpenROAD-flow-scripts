utl::set_metrics_stage "finish__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables final
load_design 6_1_fill.odb 6_1_fill.sdc
source_step_tcl PRE FINAL_REPORT

set_propagated_clock [all_clocks]

# Ensure all OR created (rsz/cts) instances are connected
global_connect
