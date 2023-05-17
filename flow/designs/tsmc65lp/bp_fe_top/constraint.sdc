current_design bp_fe_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name CLK -period 5.4 -waveform {0 2.7} [get_ports {clk_i}]

set clk_name CLK
set clk_port [get_ports CLK]
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  -max 0.6 -clock $clk_name $non_clock_inputs 
set_input_delay  -min 1.2 -clock $clk_name $non_clock_inputs 
set_output_delay 0.6 -clock $clk_name [all_outputs]
