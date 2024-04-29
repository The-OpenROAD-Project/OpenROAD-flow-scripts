# A generic constraint.sdc for macros, used in mock-array as an example
# ---------------------------------------------------------------------
# 
# From the following observations, all else follows: the only thing
# that can fail timing closure, is a register to register path. All
# other constraints give the flow an optimization target. Failure
# to meet the timing constraint of an optimization target constraint
# is not a timing closure failure.
# 
# Note that ORFS regression checks does not have the ability to distinguish
# between timing closure failures(register to register paths) and
# optimization constraints violations. Timing violations for optimization constraints
# in mock-array Element, such as maximum transit time for a combinational path
# through mock-array Element, may or may not cause timing
# violations later on higher up in mock-array on register to register paths.
# 
# For the Element constraint.sdc, the only register to register path
# are within the Element and no lower level macros are
# involved. Register to register paths within Element have to be checked
# at the Element level as they are invisible higher up in mock-array.
# 
# As for the remaining optimization constraints for Element, they
# should be for combinational through paths and from input pins to register and
# from register to output pins.
# 
# The constraints.sdc file is designed such that the clock latency & tree
# can be ignored as far constraints go;
# it is not part of the optimization constraints. The clock tree latency
# is accounted for in register to register paths within.
# 
# The timing closure for the register to register paths between
# Element macros is checked at the mock-array level.
# 
# With this in mind, the constraints.sdc file for the Element becomes
# quite general and simple. set_max_delay is used exclusively for
# optimization constraints and the clock period is used to check timing
# closure for register to register paths.
#
# set_input/output_delay are not used and can't really be used
# with the requirement that the constraint.sdc file should be articulated
# without making assumptions on the clock tree insertion latency. The time specified
# for set_input/output_delay is relative to the clock insertion point, i.e.
# the time at the clock pin for the macro, which makes it impossible to articulate
# the number that is passed in to set_input/output_delay without taking
# clock network insertion latency into account.
# 
# Since set_input_delay is not used and set_max_delay is used instead, then
# no hold cells are inserted, which is what is desired here.
# 
# Beware of [path segmentation](https://docs.xilinx.com/r/2020.2-English/ug906-vivado-design-analysis/TIMING-13-Timing-Paths-Ignored-Due-to-Path-Segmentation), which
# can occur with OpenSTA.

set sdc_version 2.0

# clk_name, clk_port_name and clk_period are set by the constraints.sdc file
# that includes this generic part.

set clk_port [get_ports $clk_port_name]
create_clock -period $clk_period -waveform [list 0 [expr $clk_period / 2]] -name $clk_name $clk_port
set_clock_uncertainty -setup 20.0 [get_clocks $clk_name]
set_clock_uncertainty -hold  20.0 [get_clocks $clk_name]

set_max_transition 250 [current_design]
set_max_transition 100 -clock_path [all_clocks]

set non_clk_inputs  [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set all_register_outputs [get_pins -of_objects [all_registers] -filter {direction == output}]

# Optimization targets. This 
set max_delay 80
set_max_delay $max_delay -from $non_clk_inputs -to [all_registers]
set_max_delay $max_delay -from $all_register_outputs -to [all_outputs]
set_max_delay $max_delay -from $non_clk_inputs -to [all_outputs]

# Set driving cell and load capacitance explicitly to ensure timing results are sufficiently pessimistic
set_driving_cell [all_inputs] -lib_cell BUFx4_ASAP7_75t_R

# Assuming the load on each output is a BUFx2_ASAP7_75t_R, we pessimistically use 3 times the highest input
#  pin capacitance for this cell, which is 0.577042.
#  See platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz, line 1223.
#set_load -pin_load 2.731126 [all_outputs]
set_load -pin_load 10 [all_outputs]
