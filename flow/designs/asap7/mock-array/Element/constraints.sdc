set sdc_version 2.0

set cols [expr {[info exists ::env(MOCK_ARRAY_WIDTH)] ? $::env(MOCK_ARRAY_WIDTH) : 8}]

set clk_name clock
set clk_port_name clock
set clk_period 8000

set clk_port [get_ports $clk_port_name]
create_clock -period $clk_period -waveform [list 0 [expr $clk_period / 2]] -name $clk_name $clk_port
set_clock_uncertainty -setup 20.0 [get_clocks $clk_name]
set_clock_uncertainty -hold 20.0 [get_clocks $clk_name]

# io_ins_x -> REG_x
set_input_delay -clock $clk_name -min [expr $clk_period / 2] [get_ports {io_ins_*}]
set_input_delay -clock $clk_name -max [expr $clk_period / 2] [get_ports {io_ins_*}]

# REG_x -> io_outs_x
set_output_delay -clock $clk_name -min [expr $clk_period / 2] [get_ports {io_outs_*}]
set_output_delay -clock $clk_name -max [expr $clk_period / 2] [get_ports {io_outs_*}]

# For combinational buses routed through the elements, IO delays need to be set to accomodate requirements
#  for each instance's position across the entire array. For simplicity, we budget the clock period evenly
#  between all elements (with some headroom).
set budget_per_element [expr $clk_period / $cols]
set headroom [expr $budget_per_element * .2]
# For in -> reg and reg -> out paths, min delay captures the case where a signal hasn't flowed through any
#  other element before this one
set min_delay $headroom
# For in -> reg and reg -> out paths, max delay captures the case where a signal has flowed through all
#  other elements before this one
set max_delay [expr $budget_per_element * ($cols - 1) + $headroom]

# REG[0] (io_outs_left[0] in the source) -> io_lsbOuts_7
set_output_delay -clock $clk_name -min $min_delay [get_ports {io_lsbOuts_7}]
set_output_delay -clock $clk_name -max $max_delay [get_ports {io_lsbOuts_7}]

# All remaining non-clock IOs are only connected to one another without going through any
#  registers (in -> out paths). Such paths should not be checked for setup/hold violations
#  and do not need to be constrained.
set non_clk_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set_false_path -from $non_clk_inputs -to [all_outputs]

# Set driving cell and load capacitance explicitly to ensure timing results are sufficiently pessimistic
set_driving_cell [all_inputs] -lib_cell BUFx2_ASAP7_75t_R
# Assuming the load on each output is a BUFx2_ASAP7_75t_R, we pessimistically use 3 times the highest input
#  pin capacitance for this cell, which is 0.577042.
#  See platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz, line 1223.
set_load -pin_load 1.731126 [all_outputs]
