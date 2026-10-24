# The tile's repair aims at a tighter clock than tpu's: the period the
# tile reaches is what sets tpu's (constraint.sdc in the parent folder).
set clk_name core_clock
set clk_port_name clk
set clk_period 337
set in2reg_max 300
set reg2out_max 100
set in2out_max 100
source $::env(PLATFORM_DIR)/constraints.sdc
