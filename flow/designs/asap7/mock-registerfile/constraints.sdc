set sdc_version 2.0

set clk_period 2000

set clk_name  clock
set clk_port_name clock
set clk_in_pct 0.75
set clk_out_pct 0.2

create_clock -name $clk_name       -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk_port_name]
set_clock_uncertainty 10 [get_clocks $clk_name]

create_clock -name ${clk_name}_vir -period $clk_period -waveform [list 0 [expr $clk_period/2]]
set_clock_uncertainty  10 [get_clocks ${clk_name}_vir]
set_clock_latency     250 [get_clocks ${clk_name}_vir]       ;# Matching real clock latency

set clk_port [get_ports $clk_port_name]
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_in_pct] -clock ${clk_name}_vir $non_clock_inputs 
set_output_delay [expr $clk_period * $clk_out_pct] -clock ${clk_name}_vir [all_outputs]

set_max_transition 300 [current_design]
set_max_transition 100 -clock_path [all_clocks]
