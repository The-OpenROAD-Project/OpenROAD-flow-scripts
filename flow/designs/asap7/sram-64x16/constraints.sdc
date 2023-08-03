set sdc_version 2.0

set clk_period 500
set clk_port_name io_clk
set clk_name io_clk
set clk_port [get_ports $clk_port_name]
create_clock $clk_port -period $clk_period -waveform [list 0 [expr $clk_period/2]]

set clk_io_pct 0.2

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs 
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# 50 is just picked out the hat, there were slew for the clock on the SRAM
# of >100 if this is not present.
#
# setting it to 10 causes resizing to run for a long time.
set_max_transition 50 [current_design]
