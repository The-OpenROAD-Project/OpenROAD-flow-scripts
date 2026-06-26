current_design aes_cipher_top

set clk_name clk
set clk_port_name clk
# GT2N lib uses time_unit = 1 ps. 500 ps -> 2 GHz target; first-pass
# loose, can tighten once routing is clean.
set clk_period 500
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [all_inputs -no_clocks]

set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
