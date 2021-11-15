# Set the current design
current_design ethmac

create_clock [get_ports wb_clk_i] -period 2000  -waveform {0 1000}
