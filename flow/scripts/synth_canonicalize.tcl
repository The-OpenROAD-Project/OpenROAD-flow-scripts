source $::env(SCRIPTS_DIR)/synth_preamble.tcl

# Apply toplevel parameters (if exist)
if {[env_var_exists_and_non_empty VERILOG_TOP_PARAMS]} {
  dict for {key value} $::env(VERILOG_TOP_PARAMS) {
    chparam -set $key $value $::env(DESIGN_NAME)
  }
}

hierarchy -check -top $::env(DESIGN_NAME)
# Get rid of unused modules
opt_clean -purge
# The hash of this file will not change if files not part of synthesis do not change
write_rtlil $::env(RESULTS_DIR)/1_synth.rtlil
