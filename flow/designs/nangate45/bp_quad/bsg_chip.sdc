###################################################################

# Created by write_sdc on Wed Sep 29 06:31:20 2021

###################################################################
set sdc_version 2.0
set clk_period 3
set clk_uncertainty 150
set bp_clk_hp [expr ${clk_period}/2]
set l_clk_p1 [expr ${clk_period}*2]
set l_clk_p2 [expr ${clk_period}*4]
set wv1 [list 0 $bp_clk_hp]
set wv2 [list 0 $clk_period]
set wv3 [list 0 $l_clk_p1]
set mx_delay1 [expr ${l_clk_p1}*0.28]
set mx_delay2 [expr ${l_clk_p2}*0.28]
set mn_delay1 [expr ${l_clk_p1}*0.02]


set_units -time ps -resistance kOhm -capacitance fF -power mW -voltage V \
  -current uA
create_clock [get_ports p_bsg_tag_clk_i] -name tag_clk -period $l_clk_p2 -waveform $wv3
set_clock_uncertainty -hold $clk_uncertainty [get_clocks tag_clk]
create_clock [get_ports p_clk_A_i] -name bp_clk -period $clk_period -waveform $wv1
set_clock_uncertainty $clk_uncertainty [get_clocks bp_clk]
create_clock [get_ports p_clk_B_i] -name io_master_clk -period $clk_period -waveform $wv1
set_clock_uncertainty $clk_uncertainty [get_clocks io_master_clk]
create_clock [get_ports p_clk_C_i] -name router_clk -period $clk_period -waveform $wv1
set_clock_uncertainty $clk_uncertainty [get_clocks router_clk]
create_clock [get_ports p_ci_clk_i] -name sdi_a_clk -period $l_clk_p1 -waveform $wv2
set_clock_uncertainty $clk_uncertainty [get_clocks sdi_a_clk]
create_clock [get_ports p_ci2_tkn_i] -name sdo_a_tkn_clk -period $l_clk_p1 -waveform $wv2
set_clock_uncertainty $clk_uncertainty [get_clocks sdo_a_tkn_clk]
create_clock [get_ports p_co_clk_i] -name sdi_b_clk -period $l_clk_p1 -waveform $wv2
set_clock_uncertainty $clk_uncertainty [get_clocks sdi_b_clk]
create_clock [get_ports p_co2_tkn_i] -name sdo_b_tkn_clk -period $l_clk_p1 -waveform $wv2
set_clock_uncertainty $clk_uncertainty [get_clocks sdo_b_tkn_clk]
#
set_multicycle_path 0 -hold -to [list [get_ports p_ci2_clk_o] [get_ports \
  p_ci2_v_o] [get_ports p_ci2_0_o] [get_ports p_ci2_1_o] [get_ports p_ci2_2_o] \
  [get_ports p_ci2_3_o] [get_ports p_ci2_4_o] [get_ports p_ci2_5_o] [get_ports \
    p_ci2_6_o] [get_ports p_ci2_7_o] [get_ports p_ci2_8_o]]
set_multicycle_path 1 -setup -to [list [get_ports p_ci2_clk_o] [get_ports \
  p_ci2_v_o] [get_ports p_ci2_0_o] [get_ports p_ci2_1_o] [get_ports p_ci2_2_o] \
  [get_ports p_ci2_3_o] [get_ports p_ci2_4_o] [get_ports p_ci2_5_o] [get_ports \
    p_ci2_6_o] [get_ports p_ci2_7_o] [get_ports p_ci2_8_o]]
set_multicycle_path 0 -hold -to [list [get_ports p_co2_clk_o] [get_ports \
  p_co2_v_o] [get_ports p_co2_0_o] [get_ports p_co2_1_o] [get_ports p_co2_2_o] \
  [get_ports p_co2_3_o] [get_ports p_co2_4_o] [get_ports p_co2_5_o] [get_ports \
    p_co2_6_o] [get_ports p_co2_7_o] [get_ports p_co2_8_o]]
set_multicycle_path 1 -setup -to [list [get_ports p_co2_clk_o] [get_ports \
  p_co2_v_o] [get_ports p_co2_0_o] [get_ports p_co2_1_o] [get_ports p_co2_2_o] \
  [get_ports p_co2_3_o] [get_ports p_co2_4_o] [get_ports p_co2_5_o] [get_ports \
    p_co2_6_o] [get_ports p_co2_7_o] [get_ports p_co2_8_o]]
set_false_path -from [get_clocks router_clk] -to [get_clocks bp_clk]
set_false_path -from [get_clocks tag_clk] -to [get_clocks bp_clk]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_clk_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_clk_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_clk_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_clk_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_clk_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_clk_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_clk_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_clk_i]
set_input_delay -clock tag_clk $mx_delay2 [get_ports p_bsg_tag_data_i]
set_input_delay -clock tag_clk $mx_delay2 [get_ports p_bsg_tag_en_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_v_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_v_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_v_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_v_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_0_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_0_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_0_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_0_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_1_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_1_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_1_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_1_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_2_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_2_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_2_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_2_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_3_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_3_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_3_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_3_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_4_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_4_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_4_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_4_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_5_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_5_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_5_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_5_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_6_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_6_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_6_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_6_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_7_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_7_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_7_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_7_i]
set_input_delay -clock sdi_a_clk -max $mx_delay1 [get_ports p_ci_8_i]
set_input_delay -clock sdi_a_clk -min $mn_delay1 [get_ports p_ci_8_i]
set_input_delay -clock sdi_a_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_ci_8_i]
set_input_delay -clock sdi_a_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_ci_8_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_v_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_v_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_v_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_v_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_0_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_0_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_0_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_0_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_1_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_1_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_1_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_1_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_2_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_2_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_2_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_2_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_3_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_3_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_3_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_3_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_4_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_4_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_4_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_4_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_5_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_5_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_5_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_5_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_6_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_6_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_6_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_6_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_7_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_7_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_7_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_7_i]
set_input_delay -clock sdi_b_clk -max $mx_delay1 [get_ports p_co_8_i]
set_input_delay -clock sdi_b_clk -min $mn_delay1 [get_ports p_co_8_i]
set_input_delay -clock sdi_b_clk -clock_fall -max $mx_delay1 -add_delay [get_ports p_co_8_i]
set_input_delay -clock sdi_b_clk -clock_fall -min $mn_delay1 -add_delay [get_ports p_co_8_i]
set_timing_derate -early -cell_delay 0.97 [get_cells {bp_processor/cc/y_0__x_0__tile_node/tile/core/fe/mem/icache/tag_mem/macro_bmem/db1_wb_0__bank/macro_mem}] ;# tclint-disable-line line-length
