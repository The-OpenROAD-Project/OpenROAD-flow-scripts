source $::env(SCRIPTS_DIR)/synth_preamble.tcl
read_design_sources
write_state_hash synth__post_read_sources__hash

hierarchy -check -top $::env(DESIGN_NAME)
write_state_hash synth__post_hierarchy__hash

source_env_var_if_exists SYNTH_CANONICALIZE_TCL

# Get rid of unused modules
opt_clean -purge
# `write_state_hash` above already stripped src attrs, so the
# SYNTH_REPEATABLE_BUILD-gated stripping below is now redundant for
# this script.  Kept harmless (idempotent) for callers that source
# SYNTH_CANONICALIZE_TCL hooks that may re-introduce src attrs.
if { $::env(SYNTH_REPEATABLE_BUILD) } {
  # avoid source line and path info affecting the hash
  setattr -unset src *
  setattr -mod -unset src *
}
# The hash of this file will not change if files not part of synthesis do not change
write_rtlil $::env(RESULTS_DIR)/1_1_yosys_canonicalize.rtlil
