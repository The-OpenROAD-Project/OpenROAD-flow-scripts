set clk_name clk
set clk_period 880 
#
create_clock [get_ports clk]  -name $clk_name  -period $clk_period
#
set_input_delay  [expr $clk_period * 0.2] -clock $clk_name [all_inputs]
set_output_delay [expr $clk_period * 0.2] -clock $clk_name [all_outputs]
