source designs/src/mock-array/util.tcl

set_io_pin_constraint -order -group -region bottom:* -pin_names [concat [match_pins .*] [match_pins clk input 1]]
