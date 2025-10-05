utl::set_metrics_stage "place_repair_timing__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_5_place_dp.odb 3_place.sdc

set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

puts "Repair setup and hold violations"
estimate_parasitics -placement
log_cmd repair_timing -repair_tns $::env(TNS_END_PERCENT)

# Legalize placement after timing repair
detailed_placement

puts "Estimate parasitics"
estimate_parasitics -placement
report_metrics 3 "place repair timing" true false

write_db $::env(RESULTS_DIR)/3_6_place_repair_timing.odb
