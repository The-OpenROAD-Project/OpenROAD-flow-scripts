# Derived from cva6_synth.tcl and Makefiles

set clk_name main_clk
set clk_port clk_i
set clk_ports_list [list $clk_port]
set clk_period 1000
set input_delay 0.46
set output_delay 0.11
create_clock [get_ports $clk_port] -name $clk_name -period $clk_period

# #set_dont_touch to keep sram as black boxes
# set_dont_touch i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_tag_srams[*].i_tag_sram
# set_dont_touch i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_data_banks[*].i_data_sram
# set_dont_touch i_cache_subsystem/i_cva6_icache/gen_sram[*].data_sram
# set_dont_touch i_cache_subsystem/i_cva6_icache/gen_sram[*].tag_sram
# #constraint the timing to and from the sram black boxes
# set_input_delay -clock main_clk -max $input_delay \
#   i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_tag_srams_*__i_tag_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/rdata_o[*]
# set_input_delay -clock main_clk -max $input_delay \
#   i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_data_banks_*__i_data_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/rdata_o[*]
# set_input_delay -clock main_clk -max $input_delay \
#   i_cache_subsystem/i_cva6_icache/gen_sram_*__data_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/rdata_o[*]
# set_input_delay -clock main_clk -max $input_delay \
#   i_cache_subsystem/i_cva6_icache/gen_sram_*__tag_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/rdata_o[*]

# set_output_delay $output_delay -max -clock main_clk \
#   i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_tag_srams_*__i_tag_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/addr_i[*]
# set_output_delay $output_delay -max -clock main_clk \
#   i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_data_banks_*__i_data_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/addr_i[*]
# set_output_delay $output_delay -max -clock main_clk \
#   i_cache_subsystem/i_cva6_icache/gen_sram_*__data_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/addr_i[*]
# set_output_delay $output_delay -max -clock main_clk \
#   i_cache_subsystem/i_cva6_icache/gen_sram_*__tag_sram/gen_cut_*__gen_mem_i_tc_sram_wrapper/addr_i[*]


set_false_path -to [get_ports {rvfi_probes_o}]
set_max_fanout 10 [current_design]
