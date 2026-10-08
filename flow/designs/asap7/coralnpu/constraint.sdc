current_design CoreMiniAxi

set clk_name io_aclk
set clk_port_name io_aclk
# Just under the 1,957 ps the flow reaches here at CTS with a 1,000 ps
# target (ORFS's previous setup, a 10 ps clock, implies about 2,040 ps at
# global route), so repair has a real target.
set clk_period 1900

# IO budgets as optimization targets, the platform's set_max_delay
# model: 0.8 of the period for a path with a register at one end, 0.6
# for a combinational path straight through.
set in2reg_max [expr { $clk_period * 0.8 }]
set reg2out_max [expr { $clk_period * 0.8 }]
set in2out_max [expr { $clk_period * 0.6 }]

# Functional mode: io_te, the test enable, selects the reset bypass and
# opens every clock gate in test.
set_case_analysis 0 [get_ports io_te]

# io_aresetn is asynchronous and reaches the core through RstSync's
# synchroniser; its recovery and removal are not what sets the core's
# frequency.
set_false_path -from [get_ports io_aresetn]

source $::env(PLATFORM_DIR)/constraints.sdc
