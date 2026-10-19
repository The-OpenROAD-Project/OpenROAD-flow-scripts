source $::env(PLATFORM_DIR)/ca53_cpu/sdc/ca53_cpu.sdc

set clk_period 1550
create_clock -name clk -period $clk_period [get_ports clk]
