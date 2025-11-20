# Derived from cva6_synth.tcl and Makefiles

source $::env(PLATFORM_DIR)/util.tcl

set clk_name main_clk
set clk_port clk_i
set clk_ports_list [list $clk_port]
set clk_period 1125

convert_time_value clk_period

set input_delay [convert_time_value 0.46]
set output_delay [convert_time_value 0.11]


create_clock [get_ports $clk_port] -name $clk_name -period $clk_period
