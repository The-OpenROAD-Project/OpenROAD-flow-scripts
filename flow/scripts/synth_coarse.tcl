source $::env(SCRIPTS_DIR)/synth_preamble.tcl

hierarchy -check -top $::env(DESIGN_NAME)

if { [env_var_equals SYNTH_GUT 1] } {
  # /deletes all cells at the top level, which will quickly optimize away
  # everything else, including macros.
  delete $::env(DESIGN_NAME)/c:*
}

if {![env_var_equals SYNTH_HIERARCHICAL 1]} {
  # Perform standard coarse-level synthesis script, flatten right away
  # (-flatten part of $synth_args per default)
  synth -run :fine {*}$::env(SYNTH_FULL_ARGS)
} else {
  # Perform standard coarse-level synthesis script,
  # defer flattening until we have decided what hierarchy to keep
  synth -run :fine

  if {[env_var_exists_and_non_empty MAX_UNGROUP_SIZE]} {
    set ungroup_threshold $::env(MAX_UNGROUP_SIZE)
    puts "Ungroup modules below estimated size of $ungroup_threshold instances"

    convert_liberty_areas
    keep_hierarchy -min_cost $ungroup_threshold
  } else {
    keep_hierarchy
  }
}

json -o $::env(RESULTS_DIR)/mem.json
# Run report and check here so as to fail early if this synthesis run is doomed
exec -- python3 $::env(SCRIPTS_DIR)/mem_dump.py --max-bits $::env(SYNTH_MEMORY_MAX_BITS) $::env(RESULTS_DIR)/mem.json

write_rtlil $::env(RESULTS_DIR)/1_yosys_coarse.rtlil
