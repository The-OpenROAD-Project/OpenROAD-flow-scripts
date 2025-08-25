utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables synth
load_design 1_synth.v 1_synth.sdc

write_db $::env(RESULTS_DIR)/1_3_synth.odb
# Canonicalize 1_synth.sdc. The original SDC_FILE provided by
# the user could have dependencies, such as sourcing util.tcl,
# which are read in here and a canonicalized version is written
# out by OpenSTA that has no dependencies.
write_sdc -no_timestamp $::env(RESULTS_DIR)/1_3_synth.sdc

# Final output of the synthesis stage, the other files are written out for
# consistency and logging of .odb hashes
exec cp $::env(RESULTS_DIR)/1_3_synth.sdc $::env(RESULTS_DIR)/1_synth.sdc
exec cp $::env(RESULTS_DIR)/1_3_synth.odb $::env(RESULTS_DIR)/1_synth.odb
