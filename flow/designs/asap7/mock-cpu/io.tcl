# bazel has root of OpenROAD-flow-scripts as working directory
foreach prefix {"" flow/} {
  set f ${prefix}designs/src/mock-array/util.tcl
  if { [file exists $f] } {
    source $f
  }
}

set_io_pin_constraint -order -group -region bottom:* \
  -pin_names [concat [match_pins .*] [match_pins clk input 1]]
