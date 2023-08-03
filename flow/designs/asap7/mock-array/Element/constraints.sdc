set sdc_version 2.0

set cols [expr {[info exists ::env(MOCK_ARRAY_COLS)] ? $::env(MOCK_ARRAY_COLS) : 8}]

set clk_name clock
set clk_port_name clock
set clk_period 1000

set clk_port [get_ports $clk_port_name]
create_clock -period $clk_period -waveform [list 0 [expr $clk_period / 2]] -name $clk_name $clk_port
set_clock_uncertainty -setup 20.0 [get_clocks $clk_name]
set_clock_uncertainty -hold 20.0 [get_clocks $clk_name]

# KISS this macro is repeated in mock-array although it lacks translational symmetry
# from an .sdc point of view.
#
# Put up some constraints here to drive optimimization, but the timing report for Element
# must be taken with a pinch of salt.
#
# The timing constraints are checked for pass/fail at the mock-array level.
#
# In the Element macro, there are some purely combinational paths, but they start in
# a register or tie cell and end in registers at the mock-array level, but give
# these inputs and outputs some delays to drive optimization.

set_input_delay -clock $clk_name [expr $clk_period * 0.05] [concat [get_ports io_ins_*] [get_ports io_lsbIns_*]]
set_output_delay -clock $clk_name [expr $clk_period * 0.05 ] [concat [get_ports io_outs_*] [get_ports io_lsbOuts_*]]

# Set driving cell and load capacitance explicitly to ensure timing results are sufficiently pessimistic
set_driving_cell [all_inputs] -lib_cell BUFx2_ASAP7_75t_R

# Assuming the load on each output is a BUFx2_ASAP7_75t_R, we pessimistically use 3 times the highest input
#  pin capacitance for this cell, which is 0.577042.
#  See platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz, line 1223.
set_load -pin_load 1.731126 [all_outputs]
