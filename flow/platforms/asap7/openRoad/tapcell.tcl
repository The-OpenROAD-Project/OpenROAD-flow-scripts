set multiplier 1
if { [info exists ::env(4X)] } {
  set multiplier 4
}
puts "\[INFO-FLOW\] Tap and End Cap cell insertion"
puts "\[INFO-FLOW\]   TAP Cell          : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   ENDCAP Cell       : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   TAP Cell Distance : 25"

tapcell \
  -distance [expr 25 * $multiplier] \
  -tapcell_master "$::env(TAP_CELL_NAME)" \
  -endcap_master "$::env(TAP_CELL_NAME)" \

#  -endcap_master "DECAPx1_ASAP7_75t_R"
