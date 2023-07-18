set sdc_version 2.0

# Some sort of clock distribution strategy is chosen at a higher level that
# where there are 8 clock inputs all synchronized in the same clock domain.
#
# https://www.semiconductor-digest.com/clock-tree-optimization-methodologies-for-power-and-latency-reduction/

lassign [split $::env(MOCK_ARRAY_TABLE)] width height

set clk_period 1000

set clk_io_pct 0.2

for {set row 0} {$row < $height} {incr row} {
  set clk_name  "io_clocks_$row"
  set clk_port_name "io_clocks_$row"
  
  create_clock [get_ports $clk_port_name] -period $clk_period -waveform [list 0 [expr $clk_period/2]]

  set clk_port [get_ports $clk_port_name]

  set row_inputs [list io_insLeft_$row io_insRight_$row]
  set row_outputs [list io_outsLeft_$row io_outsRight_$row]

  set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $row_inputs
  set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $row_outputs
  for {set column 0} {$column < $width} {incr column} {
    set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name io_lsbs_[expr $row * $width + $column]
  }
}

# top
set_input_delay [expr $clk_period * $clk_io_pct] -clock io_clocks_[expr $height - 1] [concat [get_ports io_insDown*]]
set_output_delay [expr $clk_period * $clk_io_pct] -clock io_clocks_[expr $height - 1] [concat [get_ports io_outsUp*]]

# bottom
set_input_delay [expr $clk_period * $clk_io_pct] -clock io_clocks_0 [concat [get_ports io_insUp*]]
set_output_delay [expr $clk_period * $clk_io_pct] -clock io_clocks_0 [concat [get_ports io_outsDown*]]
