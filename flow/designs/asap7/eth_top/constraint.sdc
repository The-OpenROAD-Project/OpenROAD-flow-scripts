# Set the current design
current_design ethmac

create_clock [get_ports wb_clk_i] -period 1340  -waveform {0 670}
