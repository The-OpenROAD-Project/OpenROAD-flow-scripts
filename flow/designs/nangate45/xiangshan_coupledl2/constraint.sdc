set_units -time ns -capacitance fF -resistance kOhm -voltage V -current mA -power nW
current_design CoupledL2

# The 3.8 ns target keeps the public CI runtime bounded while leaving setup
# violations for optimization experiments; it is not a measured Fmax of this
# 128 KiB MinimalConfig L2.
set clk_period 3.8
set io_delay [expr 0.20 * $clk_period]
create_clock -name core_clock -period $clk_period [get_ports clock]
create_clock -name vclk_core -period $clk_period
set_max_fanout 16 [current_design]
# Exclude the asynchronous reset from data-path timing optimization.
set_false_path -from [get_ports reset]
set_input_delay $io_delay -clock vclk_core [all_inputs -no_clocks]
set_output_delay $io_delay -clock vclk_core [all_outputs]
