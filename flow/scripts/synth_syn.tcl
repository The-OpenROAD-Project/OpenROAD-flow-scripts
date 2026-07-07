utl::set_metrics_stage "synth__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables synth

source_env_var_if_exists PLATFORM_TCL
source $::env(SCRIPTS_DIR)/read_liberty.tcl

log_cmd read_lef $::env(TECH_LEF)
log_cmd read_lef $::env(SC_LEF)
if { [env_var_exists_and_non_empty ADDITIONAL_LEFS] } {
  foreach lef $::env(ADDITIONAL_LEFS) {
    log_cmd read_lef $lef
  }
}
if { [env_var_exists_and_non_empty DONT_USE_CELLS] } {
  log_cmd set_dont_use $::env(DONT_USE_CELLS)
}

# Setup verilog include directories
set vIdirsArgs ""
if { [env_var_exists_and_non_empty VERILOG_INCLUDE_DIRS] } {
  foreach dir $::env(VERILOG_INCLUDE_DIRS) {
    lappend vIdirsArgs "-I$dir"
  }
  set vIdirsArgs [join $vIdirsArgs]
}

set elaborate_args [list \
  -D SYNTHESIS --compat=vcs --ignore-assertions --no-implicit-memories --top $::env(DESIGN_NAME) \
  {*}$vIdirsArgs {*}[env_var_or_empty VERILOG_DEFINES]]

lappend elaborate_args {*}$::env(VERILOG_FILES)

# Apply top-level parameters
dict for {key value} [env_var_or_empty VERILOG_TOP_PARAMS] {
  lappend elaborate_args -G "$key=$value"
}

# Apply module blackboxing based on module names as they appear
# in the input, that is before any module name mangling done
# by elaboration and synthesis
if { [env_var_exists_and_non_empty SYNTH_BLACKBOXES] } {
  foreach m $::env(SYNTH_BLACKBOXES) {
    lappend elaborate_args --blackboxed-module "$m"
  }
}

lappend elaborate_args {*}$::env(SYNTH_SLANG_ARGS)

# If the sources are solely .v files, enable Verilog compatibility
set has_non_v_files false
foreach fn $::env(VERILOG_FILES) {
  if { [file extension [string trim $fn]] != ".v" } {
    set has_non_v_files true
  }
}
if { !$has_non_v_files } {
  lappend elaborate_args --std=1364-2005
}

log_cmd sv_elaborate {*}$elaborate_args
log_cmd syn::stats

log_cmd synthesize

log_cmd read_sdc $::env(SDC_FILE)
log_cmd repair_design -pre_placement

report_metrics 1 "synth" false false

orfs_write_db $::env(RESULTS_DIR)/1_synth.odb
# Canonicalize 1_synth.sdc. The original SDC_FILE provided by
# the user could have dependencies, such as sourcing util.tcl,
# which are read in here and a canonicalized version is written
# out by OpenSTA that has no dependencies. Sole writer of
# 1_synth.sdc.
orfs_write_sdc $::env(RESULTS_DIR)/1_synth.sdc
