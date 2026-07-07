# Runs all OpenROAD stages of the flow, from 1_synth.odb/.sdc through
# the final report, in a single OpenROAD process. Produces the same
# .odb/.sdc files in $RESULTS_DIR as the stage-per-process make flow:
# the exec cp lines mirror the Makefile do-copy recipes.

# Enable keeping variables between stages
set ::env(KEEP_VARS) 1

# Floorplan
source $::env(SCRIPTS_DIR)/floorplan.tcl
source $::env(SCRIPTS_DIR)/macro_place.tcl
source $::env(SCRIPTS_DIR)/tapcell.tcl
source $::env(SCRIPTS_DIR)/pdn.tcl
exec cp $::env(RESULTS_DIR)/2_4_floorplan_pdn.odb $::env(RESULTS_DIR)/2_floorplan.odb
exec cp $::env(RESULTS_DIR)/2_1_floorplan.sdc $::env(RESULTS_DIR)/2_floorplan.sdc

# Place
source $::env(SCRIPTS_DIR)/global_place_skip_io.tcl
source $::env(SCRIPTS_DIR)/io_placement.tcl
source $::env(SCRIPTS_DIR)/global_place.tcl
source $::env(SCRIPTS_DIR)/resize.tcl
source $::env(SCRIPTS_DIR)/detail_place.tcl
exec cp $::env(RESULTS_DIR)/3_5_place_dp.odb $::env(RESULTS_DIR)/3_place.odb
exec cp $::env(RESULTS_DIR)/2_floorplan.sdc $::env(RESULTS_DIR)/3_place.sdc

# CTS (cts.tcl itself writes 4_cts.sdc)
source $::env(SCRIPTS_DIR)/cts.tcl
exec cp $::env(RESULTS_DIR)/4_1_cts.odb $::env(RESULTS_DIR)/4_cts.odb

# Route
source $::env(SCRIPTS_DIR)/global_route.tcl
source $::env(SCRIPTS_DIR)/detail_route.tcl
source $::env(SCRIPTS_DIR)/fillcell.tcl
exec cp $::env(RESULTS_DIR)/5_3_fillcell.odb $::env(RESULTS_DIR)/5_route.odb
exec cp $::env(RESULTS_DIR)/5_1_grt.sdc $::env(RESULTS_DIR)/5_route.sdc

# Finish
source $::env(SCRIPTS_DIR)/density_fill.tcl
exec cp $::env(RESULTS_DIR)/5_route.sdc $::env(RESULTS_DIR)/6_1_fill.sdc
exec cp $::env(RESULTS_DIR)/5_route.sdc $::env(RESULTS_DIR)/6_final.sdc
source $::env(SCRIPTS_DIR)/final_report.tcl
