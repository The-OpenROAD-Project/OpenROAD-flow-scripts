source designs/src/mock-array/util.tcl

set_io_pin_constraint -region bottom:* -pin_names [match_pins .*]

set_io_pin_constraint -region bottom:* -pin_names [match_pins clk input 1]
