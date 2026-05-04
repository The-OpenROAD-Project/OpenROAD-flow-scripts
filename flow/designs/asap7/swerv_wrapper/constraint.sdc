current_design swerv_wrapper

set clk_name core_clock
set clk_port_name clk
set clk_period 1600

# Match the old set_input/output_delay = 0.2 * clk_period budget, as
# optimization targets only (no set_input/output_delay — see rationale in
# $PLATFORM_DIR/constraints.sdc).
set in2reg_max [expr { $clk_period * 0.8 }]
set reg2out_max [expr { $clk_period * 0.8 }]
set in2out_max [expr { $clk_period * 0.6 }]

source $::env(PLATFORM_DIR)/constraints.sdc
