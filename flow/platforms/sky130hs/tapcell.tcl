if {[info exists ::env(TAP_CELL_NAME)] && $::env(TAP_CELL_NAME) != ""} {
    tapcell \
	-distance 14 \
	-tapcell_master "$::env(TAP_CELL_NAME)"
} else {
    puts "Skipping tapcell insertion since TAP_CELL_NAME is not defined"
}
