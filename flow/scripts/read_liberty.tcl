# To remove [WARNING STA-0164] from the logs for ASAP7.
# /OpenROAD-flow-scripts/flow/platforms/asap7/lib/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz line 13178, timing group from output port.
# Added following suppress_message
if {[info exists ::env(PLATFORM)] && $::env(PLATFORM) == "asap7"} {
   suppress_message STA 164
}

#Read Liberty
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

if {[info exists ::env(PLATFORM)] && $::env(PLATFORM) == "asap7"} {
   unsuppress_message STA 164
}
