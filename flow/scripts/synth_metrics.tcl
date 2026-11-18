utl::set_metrics_stage "synth__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_2_yosys.v

report_metrics 1 "Post synthesis" false false
