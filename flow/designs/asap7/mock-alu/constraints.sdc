set clk_name clock
set clk_port_name clock
set clk_period 300

# Match the old set_input_delay = 0.7 * clk_period (tight, stress-test)
# and set_output_delay = 0.2 * clk_period budgets, as optimization targets
# only (no set_input/output_delay — see rationale in
# $PLATFORM_DIR/constraints.sdc).
set in2reg_max [expr { $clk_period * 0.3 }]
set reg2out_max [expr { $clk_period * 0.8 }]
set in2out_max [expr { $clk_period * 0.1 }]

source $::env(PLATFORM_DIR)/constraints.sdc

set output_regs [get_cells *io_out_REG*]
if { [llength $output_regs] == 0 } {
  puts "Error: Could not find *io_out_REG*"
  exit 1
}
