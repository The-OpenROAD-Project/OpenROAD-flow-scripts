current_design I2cDeviceCtrl/I2cDeviceCtrl
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_max_fanout 8 [current_design]
set_max_capacitance 0.5 [current_design]
set_max_transition 3 [current_design]
set_max_area 0

create_clock [get_ports clock] -name clock -period 20.0 -waveform {0 10.0}
create_clock -name vclk -period 20.0
set input_delay_value_clock 4.0
set output_delay_value_clock 4.0
set_clock_latency [expr $input_delay_value_clock * 0.5] [get_clocks {clock}]
set_clock_latency [expr $input_delay_value_clock * 0.5] [get_clocks {vclk}]
set_ideal_network [get_ports clock]
set_clock_uncertainty 0.15 [get_clocks clock]
set_clock_transition 0.25 [get_clocks clock]
set clk_indx_clock [lsearch [all_inputs] [get_port clock]]
set all_inputs_wo_clk_rst_clock [lreplace [all_inputs] $clk_indx_clock $clk_indx_clock ""]
set_input_delay $input_delay_value_clock -clock [get_clocks {vclk}] $all_inputs_wo_clk_rst_clock
set_output_delay $output_delay_value_clock -clock [get_clocks {vclk}] [all_outputs]

set_timing_derate -early 0.95
set_timing_derate -late 1.05
