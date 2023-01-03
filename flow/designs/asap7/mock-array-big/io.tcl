proc pin3 {fmt p q r} {
    set result [list]
    for {set m 0} {$m < $p} {incr m} {
        for {set n 0} {$n < $q} {incr n} {
            for {set o 0} {$o < $r} {incr o} {               
                lappend result [format $fmt $m $n $o]
            }
        }
    }
    return $result
}

proc pin2 {fmt p q} {
    set result [list]
    for {set m 0} {$m < $p} {incr m} {
        for {set n 0} {$n < $q} {incr n} {
            lappend result [format $fmt $m $n]
        }
    }
    return $result
}

proc pin1 {fmt p} {
    set result [list]
    for {set m 0} {$m < $p} {incr m} {
        lappend result [format $fmt $m]
    }
    return $result
}

set data_width 8
set rows 8
set cols 8

set assignments [list \
    top \
    [ concat \
        {*}[pin2 {io_insHorizontal_1_%d[%d]} $cols $data_width] \
        {*}[pin2 {io_outsHorizontal_1_%d[%d]} $cols $data_width] \
    ] \
    bottom \
    [ concat \
        {*}[pin2 {io_insHorizontal_0_%d[%d]} $cols $data_width] \
        {*}[pin2 {io_outsHorizontal_0_%d[%d]} $cols $data_width] \
    ] \
    left \
    [ concat \
        {*}[pin2 {io_insVertical_1_%d[%d]} $rows $data_width] \
        {*}[pin2 {io_outsVertical_1_%d[%d]} $rows $data_width] \
    ] \
    right \
    [ concat \
        {*}[pin2 {io_insVertical_0_%d[%d]} $rows $data_width] \
        {*}[pin2 {io_outsVertical_0_%d[%d]} $rows $data_width] \
    ] \
]

foreach {direction names} $assignments {
    set_io_pin_constraint -region $direction:* -pin_names $names
}


