# Seed this variant's results dir with the yosys synthesis outputs,
# then run the whole flow in this single OpenROAD process. Under
# bazel-orfs the synthesis results are staged in the src stage's
# variant folder and its odb is exposed via ODB_FILE, while RESULTS_DIR
# points at this run's own variant folder.
file mkdir $::env(RESULTS_DIR)
set src_results [file dirname $::env(ODB_FILE)]
file copy -force $src_results/1_2_yosys.v $::env(RESULTS_DIR)/1_2_yosys.v
file copy -force $src_results/1_2_yosys.sdc $::env(RESULTS_DIR)/1_2_yosys.sdc

source $::env(SCRIPTS_DIR)/flow.tcl
