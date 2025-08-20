set clk_name clock
set clk_port_name clock
set clk_period 300
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [all_inputs -no_clocks]

set_input_delay [expr $clk_period * 0.7] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

set output_regs [get_cells *io_out_REG*]
if { [llength $output_regs] == 0 } {
  puts "Error: Could not find *io_out_REG*"
  exit 1
}
