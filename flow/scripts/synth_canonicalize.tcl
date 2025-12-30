source $::env(SCRIPTS_DIR)/synth_preamble.tcl
read_design_sources

hierarchy -check -top $::env(DESIGN_NAME)

source_env_var_if_exists SYNTH_CANONICALIZE_TCL

# Get rid of unused modules
opt_clean -purge
# The hash of this file will not change if files not part of synthesis do not change
write_rtlil $::env(RESULTS_DIR)/1_1_yosys_canonicalize.rtlil
