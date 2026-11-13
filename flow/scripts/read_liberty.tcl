#Read Liberty
if { [env_var_exists_and_non_empty CORNERS] } {
  # corners
  define_corners {*}$::env(CORNERS)
  foreach corner $::env(CORNERS) {
    set LIBKEY "[string toupper $corner]_LIB_FILES"
    foreach libFile $::env($LIBKEY) {
      log_cmd read_liberty -corner $corner [lib_file_to_read $libFile]
    }
    unset LIBKEY
  }
  unset corner
} else {
  ## no corner
  foreach libFile $::env(LIB_FILES) {
    log_cmd read_liberty [lib_file_to_read $libFile]
  }
}

# AUTO_MEMORIES: liberty views generated pre-synthesis by
# scripts/memories/gen_memories.py, named by blackboxes.txt.
foreach libFile [auto_memories_views .lib] {
  if { [env_var_exists_and_non_empty CORNERS] } {
    foreach corner $::env(CORNERS) {
      log_cmd read_liberty -corner $corner $libFile
    }
  } else {
    log_cmd read_liberty $libFile
  }
}
