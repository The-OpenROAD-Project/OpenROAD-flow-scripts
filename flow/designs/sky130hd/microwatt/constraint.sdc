current_design microwatt

set clk_name ext_clk
set clk_port_name ext_clk
set clk_period 15.0
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

# Should we create a virtual clock to constrain the UART since it is a much slower clock?
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports uart0_rxd]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports uart0_txd]

# Synchronous reset needs constraining
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports ext_rst]

# alt_reset is considered constant and shouldn't need constraining

# SPI
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports spi_flash_clk]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports spi_flash_cs_n]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports spi_flash_sdat_o]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports spi_flash_sdat_oe]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports spi_flash_sdat_i]

# GPIO bus
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports gpio_out]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports gpio_dir]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports gpio_in]

# Simple bus
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_clk]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_bus_out]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_parity_out]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_enabled]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_bus_in]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_parity_in]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_ports simplebus_irq]

set jtag_clk_name jtag_tck
set jtag_clk_port_name jtag_tck
set jtag_clk_period 100.0
set jtag_clk_io_pct 0.2

set jtag_clk_port [get_ports $jtag_clk_port_name]

create_clock -name $jtag_clk_name -period $jtag_clk_period $jtag_clk_port

set_clock_groups -name group1 -logically_exclusive \
    -group [get_clocks $jtag_clk_name]\
    -group [get_clocks $clk_name]

set_input_delay [expr $jtag_clk_period * $jtag_clk_io_pct] -clock $jtag_clk_name [get_ports jtag_tdi]
set_input_delay [expr $jtag_clk_period * $jtag_clk_io_pct] -clock $jtag_clk_name [get_ports jtag_tms]
set_input_delay [expr $jtag_clk_period * $jtag_clk_io_pct] -clock $jtag_clk_name [get_ports jtag_trst]
set_output_delay [expr $jtag_clk_period * $jtag_clk_io_pct] -clock $jtag_clk_name [get_ports jtag_tdo]

set_max_fanout 10 [current_design]

set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin Y [all_inputs]
set_load 0.03344 [all_outputs]

set_clock_uncertainty 0.25 [get_clocks $clk_name]
set_clock_uncertainty 0.25 [get_clocks $jtag_clk_name]

set_clock_transition 0.15 [get_clocks $clk_name]
set_clock_transition 0.15 [get_clocks $jtag_clk_name]

set_timing_derate -early 0.95
set_timing_derate -late 1.05
