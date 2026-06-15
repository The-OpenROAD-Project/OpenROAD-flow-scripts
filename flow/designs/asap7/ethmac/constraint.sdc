set top_clk_name wb_clk_i
set clk_period 1000
set clk_io_pct 0.2
set clk_port [get_ports $top_clk_name]
create_clock -name $top_clk_name -period $clk_period $clk_port
set top_io_clk_name vclk_$top_clk_name
create_clock -name $top_io_clk_name -period $clk_period
set_clock_latency [expr $clk_period * $clk_io_pct * 0.5] [get_clocks $top_clk_name]
set_clock_latency [expr $clk_period * $clk_io_pct * 0.5] [get_clocks $top_io_clk_name]
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $top_io_clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $top_io_clk_name [all_outputs]

set tx_clk_name mtx_clk_pad_i
set tx_clk_port [get_ports $tx_clk_name]
set tx_clk_period 300
create_clock -name $tx_clk_name -period $tx_clk_period $tx_clk_port
set tx_io_clk_name vclk_$tx_clk_name
create_clock -name $tx_io_clk_name -period $tx_clk_period
set_clock_latency [expr $tx_clk_period * $clk_io_pct * 0.5] [get_clocks $tx_clk_name]
set_clock_latency [expr $tx_clk_period * $clk_io_pct * 0.5] [get_clocks $tx_io_clk_name]
set mtx_non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $tx_clk_port]
set_input_delay [expr $tx_clk_period * $clk_io_pct] -clock $tx_io_clk_name $mtx_non_clock_inputs
set_output_delay [expr $tx_clk_period * $clk_io_pct] -clock $tx_io_clk_name [all_outputs]

set rx_clk_name mrx_clk_pad_i
set rx_clk_port [get_ports $rx_clk_name]
set rx_clk_period 300
create_clock -name $rx_clk_name -period $rx_clk_period $rx_clk_port
set rx_io_clk_name vclk_$rx_clk_name
create_clock -name $rx_io_clk_name -period $rx_clk_period
set_clock_latency [expr $rx_clk_period * $clk_io_pct * 0.5] [get_clocks $rx_clk_name]
set_clock_latency [expr $rx_clk_period * $clk_io_pct * 0.5] [get_clocks $rx_io_clk_name]
set mrx_non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $rx_clk_port]
set_input_delay [expr $rx_clk_period * $clk_io_pct] -clock $rx_io_clk_name $mrx_non_clock_inputs
set_output_delay [expr $rx_clk_period * $clk_io_pct] -clock $rx_io_clk_name [all_outputs]

set_clock_groups -name core_clock -logically_exclusive \
  -group [concat [get_clocks $top_clk_name] [get_clocks $top_io_clk_name]] \
  -group [concat [get_clocks $tx_clk_name] [get_clocks $tx_io_clk_name]] \
  -group [concat [get_clocks $rx_clk_name] [get_clocks $rx_io_clk_name]]

set_max_fanout 10 [current_design]
