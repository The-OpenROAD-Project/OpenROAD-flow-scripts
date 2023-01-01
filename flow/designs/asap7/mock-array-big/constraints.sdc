set sdc_version 2.0
create_clock [get_ports clock] -period 250 -waveform {0 125}

set clk_name  clock
set clk_port_name clock
set clk_period 250
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs 
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
