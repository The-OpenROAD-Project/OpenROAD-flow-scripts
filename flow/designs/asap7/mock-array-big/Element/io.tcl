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
set assignments [list \
    top \
    [ concat \
        {*}[pin1 {io_ins_2[%d]} $data_width] \
        {*}[pin1 {io_outs_2[%d]} $data_width] \
    ] \
    bottom \
    [ concat \
        {*}[pin1 {io_ins_0[%d]} $data_width] \
        {*}[pin1 {io_outs_0[%d]} $data_width] \
    ] \
    left \
    [ concat \
        {*}[pin1 {io_ins_3[%d]} $data_width] \
        {*}[pin1 {io_outs_3[%d]} $data_width] \
    ] \
    right \
    [ concat \
        {*}[pin1 {io_ins_1[%d]} $data_width] \
        {*}[pin1 {io_outs_1[%d]} $data_width] \
    ] \
]

foreach {direction names} $assignments {
    set_io_pin_constraint -region $direction:* -pin_names $names
}


