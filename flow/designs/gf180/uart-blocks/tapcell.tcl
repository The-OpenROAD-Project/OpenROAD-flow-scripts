tapcell \
  -endcap_cpp "12" \
  -distance 100 \
  -tapcell_master $::env(TIE_CELL) \
  -endcap_master $::env(ENDCAP_CELL) \
  -halo_width_x $::env(MACRO_ROWS_HALO_X) \
  -halo_width_y $::env(MACRO_ROWS_HALO_Y)
