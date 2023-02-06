set sdc_version 2.0

create_clock -name "core_clock" -period 4.0 -waveform {0.0 2.0} [get_ports clk_i]
