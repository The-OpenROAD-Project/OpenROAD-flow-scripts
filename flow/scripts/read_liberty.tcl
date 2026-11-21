#Read Liberty
# With corners, every library is read once and then bound to the scene of
# each corner that lists it. define_scene resolves a library by the
# filename read_liberty was given.
if { [env_var_exists_and_non_empty CORNERS] } {
  set corner_libs [dict create]
  set read_libs {}
  foreach corner $::env(CORNERS) {
    set LIBKEY "[string toupper $corner]_LIB_FILES"
    foreach libFile $::env($LIBKEY) {
      set lib [lib_file_to_read $libFile]
      if { $lib ni $read_libs } {
        log_cmd read_liberty $lib
        lappend read_libs $lib
      }
      dict lappend corner_libs $corner $lib
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
  log_cmd read_liberty $libFile
  if { [env_var_exists_and_non_empty CORNERS] } {
    foreach corner $::env(CORNERS) {
      dict lappend corner_libs $corner $libFile
    }
  }
}

if { [env_var_exists_and_non_empty CORNERS] } {
  foreach corner $::env(CORNERS) {
    log_cmd define_scene $corner -liberty [dict get $corner_libs $corner]
  }
  # The first corner is the command scene, as define_corners left it.
  log_cmd set_scene [lindex $::env(CORNERS) 0]
  unset corner corner_libs read_libs
}
