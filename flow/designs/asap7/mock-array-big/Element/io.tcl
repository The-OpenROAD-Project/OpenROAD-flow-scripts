proc pin1 {fmt p} {
    set result [list]
    for {set m 0} {$m < $p} {incr m} {
        lappend result [format $fmt $m]
    }
    return $result
}

set data_width [expr {[info exists ::env(MOCK_ARRAY_DATAWIDTH)] ? $::env(MOCK_ARRAY_DATAWIDTH) : 8}]
set cols [expr {[info exists ::env(MOCK_ARRAY_WIDTH)] ? $::env(MOCK_ARRAY_WIDTH) : 8}]

set assignments [list \
    top bottom \
    [list [ concat \
        {*}[pin1 {io_ins_down[%d]} $data_width] \
        {*}[pin1 {io_outs_up[%d]} $data_width] \
    ] \
    [ concat \
        {*}[pin1 {io_outs_down[%d]} $data_width] \
        {*}[pin1 {io_ins_up[%d]} $data_width] \
    ]] \
    left right \
    [list [ concat \
        {*}[pin1 {io_ins_right[%d]} $data_width] \
        {*}[pin1 {io_outs_left[%d]} $data_width] \
    ] \
    [ concat \
        {*}[pin1 {io_outs_right[%d]} $data_width] \
        {*}[pin1 {io_ins_left[%d]} $data_width] \
    ]] \
    left right \
    [list [ concat \
        {*}[pin1 {io_lsbIns_%d} $cols] \
    ] \
    [ concat \
        {*}[pin1 {io_lsbOuts_%d} $cols] \
    ]]
]

proc zip {list1 list2} {
    set result {}
    set length [llength $list1]
    for {set i 0} {$i < $length} {incr i} {
        lappend result [lindex $list1 $i] [lindex $list2 $i]
    }
    return $result
}


foreach {direction direction2 names} $assignments {
    set mirrored [zip {*}$names]
    set_io_pin_constraint -region $direction:* -pin_names [lindex $names 0]
    set_io_pin_constraint -order -group -pin_names [lindex $names 0]
    set_io_pin_constraint -mirrored_pins $mirrored
}

set_io_pin_constraint -region top:* -pin_names clock
