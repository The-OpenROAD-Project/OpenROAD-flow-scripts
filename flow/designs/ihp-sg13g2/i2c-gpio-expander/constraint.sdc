current_design SG13G2Top
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_max_fanout 8 [current_design]
set_max_capacitance 0.5 [current_design]
set_max_transition 3 [current_design]
set_max_area 0

set_ideal_network [get_pins sg13g2_IOPad_io_clock/p2c]
create_clock [get_pins sg13g2_IOPad_io_clock/p2c] -name clk_core -period 20.0 -waveform {0 10.0}
set_clock_uncertainty 0.15 [get_clocks clk_core]
set_clock_transition 0.25 [get_clocks clk_core]

set clock_ports [get_ports { 
	io_clock_PAD 
}]
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $clock_ports

set clk_core_inout_16mA_ports [get_ports { 
	io_gpio_0_PAD 
	io_gpio_1_PAD 
	io_gpio_2_PAD 
	io_gpio_3_PAD 
	io_gpio_4_PAD 
	io_gpio_5_PAD 
	io_gpio_6_PAD 
	io_gpio_7_PAD 
}] 
set_driving_cell -lib_cell sg13g2_IOPadInOut16mA -pin pad $clk_core_inout_16mA_ports
set_input_delay 8 -clock clk_core $clk_core_inout_16mA_ports
set_output_delay 8 -clock clk_core $clk_core_inout_16mA_ports

set clk_core_inout_4mA_ports [get_ports { 
	io_i2c_scl_PAD 
	io_i2c_sda_PAD 
}] 
set_driving_cell -lib_cell sg13g2_IOPadInOut4mA -pin pad $clk_core_inout_4mA_ports
set_input_delay 8 -clock clk_core $clk_core_inout_4mA_ports
set_output_delay 8 -clock clk_core $clk_core_inout_4mA_ports

set clk_core_input_ports [get_ports { 
	io_reset_PAD 
	io_address_0_PAD 
	io_address_1_PAD 
	io_address_2_PAD 
}] 
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $clk_core_input_ports
set_input_delay 8 -clock clk_core $clk_core_input_ports

set clk_core_output_4mA_ports [get_ports { 
	io_i2c_interrupt_PAD 
}] 
set_driving_cell -lib_cell sg13g2_IOPadOut4mA -pin pad $clk_core_output_4mA_ports
set_output_delay 8 -clock clk_core $clk_core_output_4mA_ports

set_load -pin_load 5 [all_inputs]
set_load -pin_load 5 [all_outputs]
