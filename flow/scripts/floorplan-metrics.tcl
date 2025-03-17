utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_1_floorplan.odb 2_1_floorplan.sdc

report_metrics 2 "floorplan final" false false
