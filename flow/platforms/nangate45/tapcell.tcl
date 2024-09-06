if {[info exists ::env(TAP_CELL_NAME)] && $::env(TAP_CELL_NAME) != "" &&
    [info exists ::env(ENDCAP_CELL_NAME)] && $::env(ENDCAP_CELL_NAME) != ""} {
    tapcell \
      -distance 120 \
      -tapcell_master "$::env(TAP_CELL_NAME)" \
      -endcap_master "$::env(ENDCAP_CELL_NAME)"
} else {
    puts "Skipping tapcell insertion since TAP_CELL_NAME and/or ENDCAP_CELL_NAME are not defined"
}
    
