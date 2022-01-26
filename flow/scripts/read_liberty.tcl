if {[info exists ::env(CORNERS)]} {
  # corners
  define_corners {*}$::env(CORNERS)
  foreach corner $::env(CORNERS) {
    set LIBKEY "LIB_FILES_[string toupper $corner]"
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
