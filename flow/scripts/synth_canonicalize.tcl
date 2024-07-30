source $::env(SCRIPTS_DIR)/synth_preamble.tcl
hierarchy -check -top $::env(DESIGN_NAME)
# Get rid of unused modules
opt_clean -purge
# The hash of this file will not change if files not part of synthesis do not change
write_rtlil $::env(RESULTS_DIR)/1_synth.rtlil
