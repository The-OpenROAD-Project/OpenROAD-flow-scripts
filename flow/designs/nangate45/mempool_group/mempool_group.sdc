set sdc_version 2.0
set_units -time ns -resistance kOhm -capacitance fF -power mW -voltage V -current uA

set clock_cycle 3
set uncertainty [expr $clock_cycle*0.02]
set io_delay 0
set maxFanout 16
set maxTransition [expr $clock_cycle*0.01]
set pre_cts_clock_latency_estimate 0.070
set clock_port_mempool_tile clk_i

create_clock -name clk_i -period $clock_cycle [get_ports $clock_port_mempool_tile]
set_clock_uncertainty $uncertainty [all_clocks]
set_input_delay -clock [get_clocks clk_i] -add_delay -max $io_delay \
  [get_ports * -filter "direction==in && is_on_clock_network==false"]
set_output_delay -clock [get_clocks clk_i] -add_delay -max $io_delay \
  [get_ports * -filter "direction==out && is_on_clock_network==false"]
set_max_transition $maxTransition -clock_path [get_clocks clk_i]
set_clock_latency $pre_cts_clock_latency_estimate [get_clocks clk_i]
#set_propagated_clock [get_clocks clk_i]


# Create virtual clock.
create_clock -name "vclk_i" -period $clock_cycle
set_clock_uncertainty $uncertainty [get_clocks vclk_i]
set_clock_latency $pre_cts_clock_latency_estimate [get_clocks vclk_i]
set_max_transition $maxTransition -clock_path [get_clocks vclk_i]


set_case_analysis 0 [get_ports scan_enable_i]
set_max_fanout $maxFanout [current_design]


# False path some of the quasi-static signals.
#set_false_path -from tile_id_i

# TCDM Master
set_input_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter { name =~ tcdm_master_.*req_.*_i}]
set_output_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter { name =~ tcdm_master_*req_*_o}]

set_input_delay [expr 0.65*$clock_cycle] -clock vclk_i \
  [get_ports -filter {name =~ tcdm_master_*resp_*_i}]
set_output_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter {name =~ tcdm_master_*resp_*_o}]

# TCDM Slave
#set_input_delay  [expr 0.65*$clock_cycle] -clock vclk_i \
#  [get_ports -filter {name =~ tcdm_slave_*req_*_i}]
set_output_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter {name =~ tcdm_slave_*req_*_o}]

set_input_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter {name =~ tcdm_slave_*resp_*_i}]
set_output_delay [expr 0.85*$clock_cycle] -clock vclk_i \
  [get_ports -filter {name =~ tcdm_slave_*resp_*_o}]

# Refill port
#set_input_delay  [expr 0.50*$clock_cycle] -clock vclk_i [get_ports -filter  {name =~ refill_*_i}]
#set_output_delay [expr 0.50*$clock_cycle] -clock vclk_i [get_ports -filter {name =~ refill_*_o}]

# Reset
set_input_delay [expr 0.30*$clock_cycle] -clock vclk_i rst_ni

# Critical range
# Depending on the synthesis tool used, this can be helpful.
#set_critical_range 0.100 [current_design]
