set IO_OFFSET [expr { $::env(IO_BONDPAD_SIZE) + $::env(IO_SEALRING_OFFSET) }]

# padframe core power pins
add_global_connection -net {VDD} -pin_pattern {^vdd$} -power
add_global_connection -net {VSS} -pin_pattern {^vss$} -ground

# padframe io power pins
add_global_connection -net {IOVDD} -pin_pattern {^iovdd$} -power
add_global_connection -net {IOVSS} -pin_pattern {^iovss$} -ground

make_fake_io_site -name IOLibSite -width 1 -height $::env(IO_LENGTH)
make_fake_io_site -name IOLibCSite -width $::env(IO_LENGTH) -height $::env(IO_LENGTH)

make_io_sites \
  -horizontal_site IOLibSite \
  -vertical_site IOLibSite \
  -corner_site IOLibCSite \
  -offset $IO_OFFSET

# Place IO cells
place_pads -row IO_NORTH $::env(IO_NORTH_PINS)
place_pads -row IO_EAST $::env(IO_EAST_PINS)
place_pads -row IO_SOUTH $::env(IO_SOUTH_PINS)
place_pads -row IO_WEST $::env(IO_WEST_PINS)

# Place Corner Cells and Filler
place_corners sg13cmos5l_Corner

set iofill [regexp -all -inline {\S+} $::env(IO_FILLER_CELLS)]

place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_EAST {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST {*}$iofill

connect_by_abutment

set IO_BONDPAD_Y [expr { double($::env(IO_BONDPAD_SIZE)) * -1.0 }]
place_bondpad -bond $::env(IO_BONDPAD_NAME) sg13cmos5l_IOPad* -offset "5.0 $IO_BONDPAD_Y"

remove_io_rows
