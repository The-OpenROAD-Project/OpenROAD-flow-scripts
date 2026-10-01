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

# The data array is a two-cycle macro, a contract the RTL states:
# readMCP2 = true, "read data is set MultiCycle Path 2", and its request,
# way, set and write data "must hold for 2 cycles"; the RTL asserts both
# that they hold and that no request follows a request
# (coupledL2/DataStorage.scala:52-80, 119-131). Into the array and out of
# it, setup has two cycles and hold stays at the launching edge. The
# clock gate's enable is not part of the contract: it is a one-cycle
# pulse, a register in this design, and keeps one cycle.
set data_srams [get_cells -hierarchical -filter "ref_name == l2_data_sram"]
if { [llength $data_srams] == 0 } {
  error "constraint.sdc: no l2_data_sram instance, the multicycle contract has nothing to hold"
}
set_multicycle_path -setup 2 -to $data_srams
set_multicycle_path -hold 1 -to $data_srams
set_multicycle_path -setup 2 -from $data_srams
set_multicycle_path -hold 1 -from $data_srams
