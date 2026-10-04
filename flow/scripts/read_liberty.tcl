#Read Liberty
if { [env_var_exists_and_non_empty CORNERS] } {
  # corners
  define_corners {*}$::env(CORNERS)
  foreach corner $::env(CORNERS) {
    set LIBKEY "[string toupper $corner]_LIB_FILES"
    foreach libFile $::env($LIBKEY) {
      log_cmd read_liberty -corner $corner $libFile
    }
    unset LIBKEY
  }
  unset corner
} else {
  ## no corner
  foreach libFile $::env(LIB_FILES) {
    log_cmd read_liberty $libFile
  }
}

# AUTO_MEMORIES: liberty views generated pre-synthesis by
# scripts/memories/gen_memories.py. The file names are only known at
# run time, so they are globbed here rather than threaded through
# LIB_FILES. The _pre_layout variants (ideal clock) are for pre-CTS
# consumers that select lib files themselves.
set memory_libs {}
if { [env_var_exists_and_non_empty RESULTS_DIR] } {
  foreach libFile [glob -nocomplain $::env(RESULTS_DIR)/memories/*.lib] {
    if { ![string match *_pre_layout.lib $libFile] } {
      lappend memory_libs $libFile
    }
  }
}
# Generated views present but AUTO_MEMORIES not set in this stage: the
# netlist instantiates the memory macros, their LEFs are already in the
# .odb, and skipping their liberty would leave them timed as black
# boxes -- no error, just every path through them unreported.
if { [llength $memory_libs] > 0 && ![env_var_equals AUTO_MEMORIES 1] } {
  set names [lmap f $memory_libs { file rootname [file tail $f] }]
  if { [llength $names] > 5 } {
    set names [concat [lrange $names 0 4] ...]
  }
  error "$::env(RESULTS_DIR)/memories holds generated liberty for\
    [llength $memory_libs] memories ($names), but AUTO_MEMORIES is not 1\
    in this stage, so they would be timed as black boxes. Set\
    AUTO_MEMORIES=1 for every stage, or remove the stale memories\
    directory."
}
foreach libFile $memory_libs {
  if { [env_var_exists_and_non_empty CORNERS] } {
    foreach corner $::env(CORNERS) {
      log_cmd read_liberty -corner $corner $libFile
    }
  } else {
    log_cmd read_liberty $libFile
  }
}
unset memory_libs
