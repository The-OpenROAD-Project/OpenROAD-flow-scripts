source $::env(SCRIPTS_DIR)/synth_preamble.tcl
hierarchy -check -top $::env(DESIGN_NAME)
procs
# Get rid of unused modules
clean
# The hash of this file will not change if files not part of synthesis do not change
json -o $::env(RESULTS_DIR)/1_synth.json
