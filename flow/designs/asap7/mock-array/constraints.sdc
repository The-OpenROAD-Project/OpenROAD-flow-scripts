# see README.md
set sdc_version 2.0

set clk_name clock
set clk_port_name clock
set clk_period 250

set clk_port [get_ports $clk_port_name]
create_clock -period $clk_period -waveform [list 0 [expr $clk_period / 2]] -name $clk_name $clk_port
set_clock_uncertainty -setup 20.0 [get_clocks $clk_name]
set_clock_uncertainty -hold  20.0 [get_clocks $clk_name]

set_max_transition 250 [current_design]
set_max_transition 100 -clock_path [all_clocks]

set non_clk_inputs  [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set all_register_outputs [get_pins -of_objects [all_registers] -filter {direction == output}]

# Optimization targets
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
