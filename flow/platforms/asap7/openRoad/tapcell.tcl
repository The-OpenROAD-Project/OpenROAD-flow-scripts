puts "\[INFO-FLOW\] Tap and End Cap cell insertion"
puts "\[INFO-FLOW\]   TAP Cell          : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   ENDCAP Cell       : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   Halo Around Macro : $::env(MACRO_HALO_X) $::env(MACRO_HALO_Y)"
puts "\[INFO-FLOW\]   TAP Cell Distance : 25"

# allow user to set the halo around macro with MACRO_HALO_?
tapcell \
  -distance 25 \
  -tapcell_master "$::env(TAP_CELL_NAME)" \
  -endcap_master "$::env(TAP_CELL_NAME)"  \
  -halo_width_x $::env(MACRO_HALO_X) \
  -halo_width_y $::env(MACRO_HALO_X)
