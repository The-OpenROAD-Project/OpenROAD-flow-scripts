set sdc_version 2.0

# Set the current design
current_design bsg_chip

create_clock -name "tag_clk" -period 5.2 -waveform {0.0 2.6} [get_ports p_bsg_tag_clk_i]
create_clock -name "bp_clk" -period 2.6 -waveform {0.0 1.3} [get_ports p_clk_A_i]
create_clock -name "io_master_clk" -period 2.6 -waveform {0.0 1.3} [get_ports p_clk_B_i]
create_clock -name "router_clk" -period 2.6 -waveform {0.0 1.3} [get_ports p_clk_C_i]
create_clock -name "sdi_a_clk" -period 5.2 -waveform {0.0 2.6} [get_ports p_ci_clk_i]
create_clock -name "sdo_a_tkn_clk" -period 5.2 -waveform {0.0 2.6} [get_ports p_ci2_tkn_i]
create_clock -name "sdi_b_clk" -period 5.2 -waveform {0.0 2.6} [get_ports p_co_clk_i]
create_clock -name "sdo_b_tkn_clk" -period 5.2 -waveform {0.0 2.6} [get_ports p_co2_tkn_i]
set_false_path -from [list \
  [get_clocks router_clk]  \
  [get_clocks tag_clk] ] -to [get_clocks bp_clk]
set_multicycle_path -to [list \
  [get_ports p_ci2_8_o]  \
  [get_ports p_ci2_7_o]  \
  [get_ports p_ci2_6_o]  \
  [get_ports p_ci2_5_o]  \
  [get_ports p_ci2_4_o]  \
  [get_ports p_ci2_3_o]  \
  [get_ports p_ci2_2_o]  \
  [get_ports p_ci2_1_o]  \
  [get_ports p_ci2_0_o]  \
  [get_ports p_ci2_v_o]  \
  [get_ports p_ci2_clk_o]  \
  [get_ports p_co2_8_o]  \
  [get_ports p_co2_7_o]  \
  [get_ports p_co2_6_o]  \
  [get_ports p_co2_5_o]  \
  [get_ports p_co2_4_o]  \
  [get_ports p_co2_3_o]  \
  [get_ports p_co2_2_o]  \
  [get_ports p_co2_1_o]  \
  [get_ports p_co2_0_o]  \
  [get_ports p_co2_v_o]  \
  [get_ports p_co2_clk_o] ] -hold -start 0
set_multicycle_path -to [list \
  [get_ports p_ci2_8_o]  \
  [get_ports p_ci2_7_o]  \
  [get_ports p_ci2_6_o]  \
  [get_ports p_ci2_5_o]  \
  [get_ports p_ci2_4_o]  \
  [get_ports p_ci2_3_o]  \
  [get_ports p_ci2_2_o]  \
  [get_ports p_ci2_1_o]  \
  [get_ports p_ci2_0_o]  \
  [get_ports p_ci2_v_o]  \
  [get_ports p_ci2_clk_o]  \
  [get_ports p_co2_8_o]  \
  [get_ports p_co2_7_o]  \
  [get_ports p_co2_6_o]  \
  [get_ports p_co2_5_o]  \
  [get_ports p_co2_4_o]  \
  [get_ports p_co2_3_o]  \
  [get_ports p_co2_2_o]  \
  [get_ports p_co2_1_o]  \
  [get_ports p_co2_0_o]  \
  [get_ports p_co2_v_o]  \
  [get_ports p_co2_clk_o] ] -setup -end 1
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks tag_clk] -add_delay 1.456 [get_ports p_bsg_tag_data_i]
set_input_delay -clock [get_clocks tag_clk] -add_delay 1.456 [get_ports p_bsg_tag_en_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_v_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_v_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_v_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_v_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_0_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_0_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_0_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_0_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_1_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_1_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_1_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_1_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_2_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_2_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_2_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_2_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_3_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_3_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_3_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_3_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_4_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_4_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_4_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_4_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_5_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_5_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_5_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_5_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_6_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_6_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_6_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_6_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_7_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_7_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_7_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_7_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -max 0.728 [get_ports p_ci_8_i]
set_input_delay -clock [get_clocks sdi_a_clk] -add_delay -min 0.052 [get_ports p_ci_8_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -max 0.728 [get_ports p_ci_8_i]
set_input_delay -clock [get_clocks sdi_a_clk] -clock_fall -add_delay -min 0.052 [get_ports p_ci_8_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_v_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_v_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_v_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_v_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_0_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_0_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_0_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_0_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_1_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_1_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_1_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_1_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_2_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_2_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_2_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_2_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_3_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_3_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_3_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_3_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_4_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_4_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_4_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_4_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_5_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_5_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_5_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_5_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_6_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_6_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_6_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_6_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_7_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_7_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_7_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_7_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -max 0.728 [get_ports p_co_8_i]
set_input_delay -clock [get_clocks sdi_b_clk] -add_delay -min 0.052 [get_ports p_co_8_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -max 0.728 [get_ports p_co_8_i]
set_input_delay -clock [get_clocks sdi_b_clk] -clock_fall -add_delay -min 0.052 [get_ports p_co_8_i]
set_wire_load_mode "enclosed"
set_clock_uncertainty -hold 0.15 [get_clocks tag_clk]
set_clock_uncertainty -setup 0.15 [get_clocks bp_clk]
set_clock_uncertainty -hold 0.15 [get_clocks bp_clk]
set_clock_uncertainty -setup 0.15 [get_clocks io_master_clk]
set_clock_uncertainty -hold 0.15 [get_clocks io_master_clk]
set_clock_uncertainty -setup 0.15 [get_clocks router_clk]
set_clock_uncertainty -hold 0.15 [get_clocks router_clk]
set_clock_uncertainty -setup 0.15 [get_clocks sdi_a_clk]
set_clock_uncertainty -hold 0.15 [get_clocks sdi_a_clk]
set_clock_uncertainty -setup 0.15 [get_clocks sdo_a_tkn_clk]
set_clock_uncertainty -hold 0.15 [get_clocks sdo_a_tkn_clk]
set_clock_uncertainty -setup 0.15 [get_clocks sdi_b_clk]
set_clock_uncertainty -hold 0.15 [get_clocks sdi_b_clk]
set_clock_uncertainty -setup 0.15 [get_clocks sdo_b_tkn_clk]
set_clock_uncertainty -hold 0.15 [get_clocks sdo_b_tkn_clk]
