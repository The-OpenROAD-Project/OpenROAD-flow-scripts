source $::env(PLATFORM_DIR)/util.tcl

set clk_name core_clock
set clk_port_name clk_i
set clk_period 590
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

convert_time_value clk_period

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay [expr { $clk_period * $clk_io_pct }] -clock $clk_name \
  $non_clock_inputs
set_output_delay [expr { $clk_period * $clk_io_pct }] -clock $clk_name \
  [all_outputs]
