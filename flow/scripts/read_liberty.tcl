if {[info exists ::env(CORNER)]} {
  # corners
  define_corners {*}$::env(CORNER)
  foreach corner $::env(CORNER) {
    set LIBKEY "[string toupper $corner]_LIB_FILES"
    foreach libFile $::env($LIBKEY) {
    read_liberty -corner $corner $libFile
    }
    unset LIBKEY
  }
  unset corner
} else {
  ## no corner
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
}
