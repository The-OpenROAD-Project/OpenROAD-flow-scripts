proc match_pins { regex {direction .*} {is_clock 0}} {
    set pins {}
    # The regex for get_ports is not the tcl regex
    foreach pin [get_ports -regex $regex] {
        set name [get_property $pin name]
        # We want the Tcl regex
        if {![regexp $regex $name]} {
            continue
        }
        lappend pins $name
    }
    return $pins
}

# wishbone pins on the left
set left_pints m_wb_
set_io_pin_constraint -region left:* -pin_names [match_pins $left_pints.*]
# the rest of the pins on top
set_io_pin_constraint -region top:* -pin_names [match_pins ^(?!$left_pints).*]
