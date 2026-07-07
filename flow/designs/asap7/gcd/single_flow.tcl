# Seed this variant's results dir with the synthesis outputs, then run
# the whole flow in this single OpenROAD process. Under bazel-orfs the
# synthesis results are staged in the src stage's variant folder and
# exposed via ODB_FILE, while RESULTS_DIR points at this run's own
# variant folder.
file mkdir $::env(RESULTS_DIR)
file copy -force $::env(ODB_FILE) $::env(RESULTS_DIR)/1_synth.odb
file copy -force [file rootname $::env(ODB_FILE)].sdc $::env(RESULTS_DIR)/1_synth.sdc

source $::env(SCRIPTS_DIR)/flow.tcl
