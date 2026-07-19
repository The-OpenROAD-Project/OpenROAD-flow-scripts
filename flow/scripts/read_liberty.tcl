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
if { [env_var_equals AUTO_MEMORIES 1] } {
  foreach libFile [glob -nocomplain $::env(RESULTS_DIR)/memories/*.lib] {
    if { [string match *_pre_layout.lib $libFile] } {
      continue
    }
    log_cmd read_liberty $libFile
  }
}
