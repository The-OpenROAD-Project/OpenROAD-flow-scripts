puts "\[INFO-FLOW\] Tap and End Cap cell insertion"
puts "\[INFO-FLOW\]   TAP Cell          : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   ENDCAP Cell       : $::env(TAP_CELL_NAME)"
puts "\[INFO-FLOW\]   TAP Cell Distance : 25"

tapcell \
  -distance 25 \
  -tapcell_master "$::env(TAP_CELL_NAME)" \
  -endcap_master "$::env(TAP_CELL_NAME)"
