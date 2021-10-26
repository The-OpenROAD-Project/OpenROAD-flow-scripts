# Set the current design
current_design eth_top

create_clock [get_ports wb_clk_i] -period 1000  -waveform {0 500}
