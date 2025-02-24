set IO_LENGTH 180
set IO_WIDTH 80
set BONDPAD_SIZE 70
set SEALRING_OFFSET 70

proc calc_horizontal_pad_location {index total} {
    global IO_LENGTH
    global IO_WIDTH
    global BONDPAD_SIZE
    global SEALRING_OFFSET

    set DIE_WIDTH [expr {[lindex $::env(DIE_AREA) 2] - [lindex $::env(DIE_AREA) 0]}]
    set PAD_OFFSET [expr {$IO_LENGTH + $BONDPAD_SIZE + $SEALRING_OFFSET}]
    set PAD_AREA_WIDTH [expr {$DIE_WIDTH - ($PAD_OFFSET * 2)}]
    set HORIZONTAL_PAD_DISTANCE [expr {($PAD_AREA_WIDTH / $total) - $IO_WIDTH}]

    return [expr {$PAD_OFFSET + (($IO_WIDTH + $HORIZONTAL_PAD_DISTANCE) * $index) + ($HORIZONTAL_PAD_DISTANCE / 2)}]
}

proc calc_vertical_pad_location {index total} {
    global IO_LENGTH
    global IO_WIDTH
    global BONDPAD_SIZE
    global SEALRING_OFFSET

    set DIE_HEIGHT [expr {[lindex $::env(DIE_AREA) 3] - [lindex $::env(DIE_AREA) 1]}]
    set PAD_OFFSET [expr {$IO_LENGTH + $BONDPAD_SIZE + $SEALRING_OFFSET}]
    set PAD_AREA_HEIGHT [expr {$DIE_HEIGHT - ($PAD_OFFSET * 2)}]
    set VERTICAL_PAD_DISTANCE [expr {($PAD_AREA_HEIGHT / $total) - $IO_WIDTH}]

    return [expr {$PAD_OFFSET + (($IO_WIDTH + $VERTICAL_PAD_DISTANCE) * $index) + ($VERTICAL_PAD_DISTANCE / 2)}]
}

make_fake_io_site -name IOLibSite -width 1 -height $IO_LENGTH
make_fake_io_site -name IOLibCSite -width $IO_LENGTH -height $IO_LENGTH

set IO_OFFSET [expr {$BONDPAD_SIZE + $SEALRING_OFFSET}]
# Create IO Rows
make_io_sites \
    -horizontal_site IOLibSite \
    -vertical_site IOLibSite \
    -corner_site IOLibCSite \
    -offset $IO_OFFSET

# Place Pads\n# IO pin io_clock
place_pad -row IO_SOUTH -location [calc_horizontal_pad_location 0 5] {sg13g2_IOPad_io_clock} -master sg13g2_IOPadIn
# IO pin io_reset
place_pad -row IO_SOUTH -location [calc_horizontal_pad_location 1 5] {sg13g2_IOPad_io_reset} -master sg13g2_IOPadIn
# IO pin io_i2c_scl
place_pad -row IO_SOUTH -location [calc_horizontal_pad_location 2 5] {sg13g2_IOPad_io_i2c_scl} -master sg13g2_IOPadInOut4mA
# IO pin io_i2c_sda
place_pad -row IO_SOUTH -location [calc_horizontal_pad_location 3 5] {sg13g2_IOPad_io_i2c_sda} -master sg13g2_IOPadInOut4mA
# IO pin io_i2c_interrupt
place_pad -row IO_SOUTH -location [calc_horizontal_pad_location 4 5] {sg13g2_IOPad_io_i2c_interrupt} -master sg13g2_IOPadOut4mA
place_pad -row IO_EAST -location [calc_vertical_pad_location 0 5] {sg13g2_IOPadVdd_east_0} -master sg13g2_IOPadVdd
place_pad -row IO_EAST -location [calc_vertical_pad_location 1 5] {sg13g2_IOPadVss_east_1} -master sg13g2_IOPadVss
# IO pin io_address_0
place_pad -row IO_EAST -location [calc_vertical_pad_location 2 5] {sg13g2_IOPad_io_address_0} -master sg13g2_IOPadIn
# IO pin io_address_1
place_pad -row IO_EAST -location [calc_vertical_pad_location 3 5] {sg13g2_IOPad_io_address_1} -master sg13g2_IOPadIn
# IO pin io_address_2
place_pad -row IO_EAST -location [calc_vertical_pad_location 4 5] {sg13g2_IOPad_io_address_2} -master sg13g2_IOPadIn
# IO pin io_gpio_0
place_pad -row IO_NORTH -location [calc_horizontal_pad_location 0 5] {sg13g2_IOPad_io_gpio_0} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_1
place_pad -row IO_NORTH -location [calc_horizontal_pad_location 1 5] {sg13g2_IOPad_io_gpio_1} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_2
place_pad -row IO_NORTH -location [calc_horizontal_pad_location 2 5] {sg13g2_IOPad_io_gpio_2} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_3
place_pad -row IO_NORTH -location [calc_horizontal_pad_location 3 5] {sg13g2_IOPad_io_gpio_3} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_4
place_pad -row IO_NORTH -location [calc_horizontal_pad_location 4 5] {sg13g2_IOPad_io_gpio_4} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_5
place_pad -row IO_WEST -location [calc_vertical_pad_location 0 5] {sg13g2_IOPad_io_gpio_5} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_6
place_pad -row IO_WEST -location [calc_vertical_pad_location 1 5] {sg13g2_IOPad_io_gpio_6} -master sg13g2_IOPadInOut16mA
# IO pin io_gpio_7
place_pad -row IO_WEST -location [calc_vertical_pad_location 2 5] {sg13g2_IOPad_io_gpio_7} -master sg13g2_IOPadInOut16mA
place_pad -row IO_WEST -location [calc_vertical_pad_location 3 5] {sg13g2_IOPadIOVss_west_3} -master sg13g2_IOPadIOVss
place_pad -row IO_WEST -location [calc_vertical_pad_location 4 5] {sg13g2_IOPadIOVdd_west_4} -master sg13g2_IOPadIOVdd
# Place Corner Cells and Filler
place_corners sg13g2_Corner

set iofill {
    sg13g2_Filler10000
    sg13g2_Filler4000
    sg13g2_Filler2000
    sg13g2_Filler1000
    sg13g2_Filler400
    sg13g2_Filler200
}

place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST {*}$iofill
place_io_fill -row IO_EAST {*}$iofill

connect_by_abutment

place_bondpad -bond bondpad_70x70 sg13g2_IOPad* -offset {5.0 -70.0}

remove_io_rows
