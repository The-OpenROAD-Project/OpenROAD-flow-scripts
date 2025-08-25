# https://gist.github.com/brabect1/7695ead3d79be47576890bbcd61fe426
#
# This fifo is from http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

source designs/src/mock-array/util.tcl

set sdc_version 2.0

set clk_period 333
set clk2_period 1000

set clk1_name clk
create_clock -name $clk1_name -period $clk_period -waveform \
  [list 0 [expr $clk_period/2]] [get_ports $clk1_name]
set_clock_uncertainty 10 [get_clocks $clk1_name]

set clk2_name clk_uncore
create_clock -name $clk2_name -period $clk2_period -waveform \
  [list 0 [expr $clk_period/2]] [get_ports $clk2_name]
set_clock_uncertainty 10 [get_clocks $clk2_name]
set_clock_groups -group $clk1_name -group $clk2_name -asynchronous -allow_paths

set_false_path -from [get_ports *rst_n]
set_false_path -to [get_ports *rst_n]

# The mock-cpu is a macro connecting to a slower peripheral bus and possibly DRAM.
# Avoid using set_input/output_delay here.
# Register-to-register paths are checked at the mock-cpu level or from the mock-cpu
# .lib file to an external register.
# Timing closure is ensured at the SoC level where the mock-cpu is connected.
# Instead, set strict optimization targets for inputs and outputs to ensure
# constraints are not too loose.
set non_clk_inputs {}
set clock_ports [list [get_ports $clk1_name] [get_ports $clk2_name]]
foreach input [all_inputs] {
  if { [lsearch -exact $clock_ports $input] == -1 } {
    lappend non_clk_inputs $input
  }
}

set_max_delay 80 -from $non_clk_inputs -to [all_outputs]
group_path -name in2out -from $non_clk_inputs -to [all_outputs]

set all_register_outputs [get_pins -of_objects [all_registers] -filter {direction == output}]
set_max_delay 80 -from $non_clk_inputs -to [all_registers]
set_max_delay 80 -from $all_register_outputs -to [all_outputs]
group_path -name in2reg -from $non_clk_inputs -to [all_registers]
group_path -name reg2out -from [all_registers] -to [all_outputs]
group_path -name reg2reg -from [all_registers] -to [all_registers]

## Dual clock fifo timing constraints
# Using fastest clock as constaint
set cdc_max_delay $clk_period

# rdata from fifo_out goes directly to I/O-pins so we need special handling of this case
# to ignore timing path from wclk -> rdata for this special case
# In normal cases fifo output (rdata) will most likely have a FF on I/O output signal
set_false_path -from $clk1_name -to [match_pins rdata* output 0]

# Set timing constraint between clock domains
set_max_delay $cdc_max_delay -from $clk1_name -to $clk2_name -ignore_clock_latency
set_max_delay $cdc_max_delay -from $clk2_name -to $clk1_name -ignore_clock_latency

# Hold times between clock domain makes no sense, and should just be ignored
set_false_path -hold -from $clk1_name -to $clk2_name
set_false_path -hold -from $clk2_name -to $clk1_name
