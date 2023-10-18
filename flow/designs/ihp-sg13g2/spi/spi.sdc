###################################################################

# Created by write_sdc on Fri Jun 20 08:42:53 2014

###################################################################
set sdc_version 1.9

create_clock [get_ports clk]  -period 20  -waveform {0 10}
set_clock_uncertainty 2  [get_clocks clk]
