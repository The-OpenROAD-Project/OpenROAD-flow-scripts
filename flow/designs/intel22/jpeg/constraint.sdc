current_design jpeg_encoder
set clk_name clk
set clk_period 4400
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name $clk_name -period $clk_period [get_ports {clk}]
#
set_input_delay  [expr $clk_period * 0.2] -clock $clk_name [all_inputs]
set_output_delay [expr $clk_period * 0.2] -clock $clk_name [all_outputs]
