proc pin2 {fmt p q} {
    set result [list]
    for {set m 0} {$m < $p} {incr m} {
        for {set n 0} {$n < $q} {incr n} {
            lappend result [format $fmt $m $n]
        }
    }
    return $result
}

set data_width [expr {[info exists ::env(MOCK_ARRAY_DATAWIDTH)] ? $::env(MOCK_ARRAY_DATAWIDTH) : 8}]
set rows [expr {[info exists ::env(MOCK_ARRAY_HEIGHT)] ? $::env(MOCK_ARRAY_HEIGHT) : 8}]
set cols [expr {[info exists ::env(MOCK_ARRAY_WIDTH)] ? $::env(MOCK_ARRAY_WIDTH) : 8}]

set assignments [list \
    top \
    [ concat \
        {*}[pin2 {io_insDown_%d[%d]} $cols $data_width] \
        {*}[pin2 {io_outsUp_%d[%d]} $cols $data_width] \
    ] \
    bottom \
    [ concat \
        {*}[pin2 {io_insUp_%d[%d]} $cols $data_width] \
        {*}[pin2 {io_outsDown_%d[%d]} $cols $data_width] \
    ] \
    left \
    [ concat \
        {*}[pin2 {io_insRight_%d[%d]} $rows $data_width] \
        {*}[pin2 {io_outsLeft_%d[%d]} $rows $data_width] \
    ] \
    right \
    [ concat \
        {*}[pin2 {io_insLeft_%d[%d]} $rows $data_width] \
        {*}[pin2 {io_outsRight_%d[%d]} $rows $data_width] \
    ] \
]

foreach {direction names} $assignments {
    set_io_pin_constraint -region $direction:* -pin_names $names
}
