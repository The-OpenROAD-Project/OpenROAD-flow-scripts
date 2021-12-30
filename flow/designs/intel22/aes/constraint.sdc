set clk_name clk
set clk_period 2600
#
create_clock -name $clk_name -period $clk_period [get_ports clk]

