# https://gist.github.com/brabect1/7695ead3d79be47576890bbcd61fe426
#
# This fifo is from http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

set sdc_version 2.0

set clk_period 1000

set clk1_name clk
create_clock -name $clk1_name -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk1_name]
set_clock_uncertainty 10 [get_clocks $clk1_name]

set_false_path -from [get_ports *rst_n]
set_false_path -to [get_ports *rst_n]

# Give the world outside of the FIFO time to operate
# on the cycle it is reading/writiing to the FIFO
set input_percent 0.8
set output_percent 0.8

set_input_delay -clock $clk1_name -max [expr $clk_period * $input_percent] [get_ports w*]
set_input_delay -clock $clk1_name -max [expr $clk_period * $input_percent] [get_ports r*]

set_output_delay -clock $clk1_name -max [expr $clk_period * $output_percent] [get_ports r*]
set_output_delay -clock $clk1_name -max [expr $clk_period * $input_percent] [get_ports wfull]
set_output_delay -clock $clk1_name -max [expr $clk_period * $input_percent] [get_ports rempty]

set_max_delay -from [all_registers -clock_pins] -to [all_registers -data_pins] 2000
