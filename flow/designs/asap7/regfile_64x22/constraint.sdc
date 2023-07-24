set clk_period    7500 
set clk_io_pct    0.2

foreach clk [list W0_clk R0_clk] {
  set clk_port      [get_ports $clk]

  create_clock -name $clk -period $clk_period $clk
}

#set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] W0_clk]

#set_input_delay  [expr $clk_period * $clk_io_pct] -clock W0_clk $non_clock_inputs 
#set_output_delay [expr $clk_period * $clk_io_pct] -clock W0_clk [all_outputs]

