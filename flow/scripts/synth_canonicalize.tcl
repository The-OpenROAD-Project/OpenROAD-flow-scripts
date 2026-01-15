source $::env(SCRIPTS_DIR)/synth_preamble.tcl
read_design_sources

hierarchy -check -top $::env(DESIGN_NAME)

source_env_var_if_exists SYNTH_CANONICALIZE_TCL

# Get rid of unused modules
opt_clean -purge
# avoid source line and path info affecting the hash
setattr -unset src *
# The hash of this file will not change if files not part of synthesis do not change
#
# .rtlil is optimized for debuggability and file paths and line
# numbers are everywhere. Verilog output is a better fit for
# canonicalization w.r.t. hashes.
write_verilog -noattr $::env(RESULTS_DIR)/1_1_yosys_canonicalize.v
