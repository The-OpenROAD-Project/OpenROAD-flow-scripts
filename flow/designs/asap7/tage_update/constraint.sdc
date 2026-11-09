# 473 ps is XiangShan's synthesis period on this library: its published
# goal is 3 GHz (333 ps) on 7 nm, 41.1 FO4 at ASAP7's published 8.1 ps,
# which is 591 ps at this flow's 14.37 ps FO4, and 0.8 of that.
set clk_name clk
set clk_port_name clock
set clk_period 473

# A macro: only reg2reg can fail closure. The boundaries are
# optimisation targets, set_max_delay in the platform's constraints.sdc,
# not set_input_delay/set_output_delay.
set in2reg_max [expr { $clk_period * 0.8 }]
set reg2out_max [expr { $clk_period * 0.8 }]
set in2out_max [expr { $clk_period * 0.6 }]

source $::env(PLATFORM_DIR)/constraints.sdc
