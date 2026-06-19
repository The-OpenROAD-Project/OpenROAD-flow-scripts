# Post-detailed-placement timing repair: coarse + fine.
# Runs after detailed placement (3_5_place_dp) and before CTS, on placement
# parasitics; we re-legalize afterward.
#
# Note: "reroute" (part of FINE) is a no-op here -- it needs global routes
# (stage 5), which don't exist yet at post-placement.
utl::set_metrics_stage "place_repair_timing__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_5_place_dp.odb 2_floorplan.sdc

set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

puts "Repair setup violations after detailed placement (coarse + fine)..."
log_cmd estimate_parasitics -placement
repair_timing_helper -setup -phases "COARSE FINE"

# Re-legalize after timing repair.
set dpl_args {}
append_env_var dpl_args USE_NEGOTIATION -use_negotiation 0
log_cmd detailed_placement {*}$dpl_args

log_cmd estimate_parasitics -placement
report_metrics 3 "place repair timing" true false

orfs_write_db $::env(RESULTS_DIR)/3_6_place_repair_timing.odb
