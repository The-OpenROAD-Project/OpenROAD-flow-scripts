current_design CoreMiniAxi

set clk_name io_aclk
set clk_port_name io_aclk
set clk_period 10.00

set clk_port [get_ports $clk_port_name]

create_clock -period $clk_period -name $clk_name $clk_port
