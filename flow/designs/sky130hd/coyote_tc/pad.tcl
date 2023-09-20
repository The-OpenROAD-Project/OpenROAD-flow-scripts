make_fake_io_site -name IO_SITE -width 1 -height 200
make_fake_io_site -name IO_CSITE -width 200 -height 204

# Create IO Rows
make_io_sites -horizontal_site IO_SITE \
    -vertical_site IO_SITE \
    -corner_site IO_CSITE \
    -offset 0 \
    -rotation_horizontal R180 \
    -rotation_vertical R180 \
    -rotation_corner R180

######## Place Pads ########
place_pad -row IO_SOUTH -location 240.0 {u_reset_i.u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 320.0 {u_vzz_0}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 400.0 {u_v18_0}
place_pad -row IO_SOUTH -location 560.0 {u_rocc_cmd_v_o.u_io}
place_pad -row IO_SOUTH -location 640.0 {u_rocc_cmd_data_o_0.u_io}
place_pad -row IO_SOUTH -location 720.0 {u_rocc_cmd_data_o_1.u_io}
place_pad -row IO_SOUTH -location 800.0 {u_rocc_cmd_data_o_2.u_io}
place_pad -row IO_SOUTH -location 880.0 {u_rocc_cmd_data_o_3.u_io}
place_pad -row IO_SOUTH -location 960.0 {u_rocc_cmd_data_o_4.u_io}
place_pad -row IO_SOUTH -location 1040.0 {u_rocc_cmd_data_o_5.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 1120.0 {u_vzz_1}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 1200.0 {u_v18_1}
place_pad -row IO_SOUTH -location 1280.0 {u_rocc_cmd_data_o_6.u_io}
place_pad -row IO_SOUTH -location 1360.0 {u_rocc_cmd_data_o_7.u_io}
place_pad -row IO_SOUTH -location 1440.0 {u_rocc_cmd_data_o_8.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_SOUTH -location 1520.0 {u_vss_0}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_SOUTH -location 1600.0 {u_vdd_0}
place_pad -row IO_SOUTH -location 1680.0 {u_rocc_cmd_data_o_9.u_io}
place_pad -row IO_SOUTH -location 1760.0 {u_rocc_cmd_data_o_10.u_io}
place_pad -row IO_SOUTH -location 1840.0 {u_rocc_cmd_data_o_11.u_io}
place_pad -row IO_SOUTH -location 1920.0 {u_rocc_cmd_data_o_12.u_io}
place_pad -row IO_SOUTH -location 2000.0 {u_rocc_cmd_data_o_13.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 2080.0 {u_vzz_2}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 2160.0 {u_v18_2}
place_pad -row IO_SOUTH -location 2240.0 {u_rocc_cmd_data_o_14.u_io}
place_pad -row IO_SOUTH -location 2320.0 {u_rocc_cmd_data_o_15.u_io}
place_pad -row IO_SOUTH -location 2400.0 {u_rocc_cmd_ready_i.u_in}
place_pad -row IO_SOUTH -location 2480.0 {u_rocc_resp_v_i.u_in}
place_pad -row IO_SOUTH -location 2560.0 {u_rocc_resp_data_i.u_io\[0\].u_in}
place_pad -row IO_SOUTH -location 2640.0 {u_rocc_resp_data_i.u_io\[1\].u_in}
place_pad -row IO_SOUTH -location 2720.0 {u_rocc_resp_data_i.u_io\[2\].u_in}
place_pad -row IO_SOUTH -location 2800.0 {u_rocc_resp_data_i.u_io\[3\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 2880.0 {u_vzz_3}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 2960.0 {u_v18_3}
place_pad -row IO_SOUTH -location 3040.0 {u_rocc_resp_data_i.u_io\[4\].u_in}
place_pad -row IO_SOUTH -location 3120.0 {u_rocc_resp_data_i.u_io\[5\].u_in}
place_pad -row IO_SOUTH -location 3200.0 {u_rocc_resp_data_i.u_io\[6\].u_in}
place_pad -row IO_SOUTH -location 3280.0 {u_rocc_resp_data_i.u_io\[7\].u_in}
place_pad -row IO_SOUTH -location 3360.0 {u_rocc_resp_ready_o.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_SOUTH -location 3440.0 {u_vss_1}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_SOUTH -location 3520.0 {u_vdd_1}
place_pad -row IO_SOUTH -location 3600.0 {u_rocc_mem_req_v_i.u_in}
place_pad -row IO_SOUTH -location 3680.0 {u_rocc_mem_req_data_i.u_io\[0\].u_in}
place_pad -row IO_SOUTH -location 3760.0 {u_rocc_mem_req_data_i.u_io\[1\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 3840.0 {u_vzz_4}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 3920.0 {u_v18_4}
place_pad -row IO_SOUTH -location 4000.0 {u_rocc_mem_req_data_i.u_io\[2\].u_in}
place_pad -row IO_SOUTH -location 4080.0 {u_rocc_mem_req_data_i.u_io\[3\].u_in}
place_pad -row IO_SOUTH -location 4160.0 {u_rocc_mem_req_data_i.u_io\[4\].u_in}
place_pad -row IO_SOUTH -location 4240.0 {u_rocc_mem_req_data_i.u_io\[5\].u_in}
place_pad -row IO_SOUTH -location 4320.0 {u_rocc_mem_req_data_i.u_io\[6\].u_in}
place_pad -row IO_SOUTH -location 4400.0 {u_rocc_mem_req_data_i.u_io\[7\].u_in}
place_pad -row IO_SOUTH -location 4480.0 {u_rocc_mem_req_data_i.u_io\[8\].u_in}
place_pad -row IO_SOUTH -location 4560.0 {u_rocc_mem_req_data_i.u_io\[9\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_SOUTH -location 4640.0 {u_vzz_5}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_SOUTH -location 4720.0 {u_v18_5}
place_pad -row IO_SOUTH -location 4800.0 {u_rocc_mem_req_data_i.u_io\[10\].u_in}
place_pad -row IO_SOUTH -location 4880.0 {u_rocc_mem_req_data_i.u_io\[11\].u_in}

place_pad -row IO_EAST -location 234.0 {u_rocc_mem_req_data_i.u_io\[12\].u_in}
place_pad -row IO_EAST -location 314.0 {u_rocc_mem_req_data_i.u_io\[13\].u_in}
place_pad -row IO_EAST -location 394.0 {u_rocc_mem_req_data_i.u_io\[14\].u_in}
place_pad -row IO_EAST -location 474.0 {u_rocc_mem_req_data_i.u_io\[15\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_EAST -location 554.0 {u_vzz_6}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_EAST -location 634.0 {u_v18_6}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_EAST -location 714.0 {u_vss_2}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_EAST -location 794.0 {u_vdd_2}
place_pad -row IO_EAST -location 874.0 {u_rocc_mem_req_data_i.u_io\[16\].u_in}
place_pad -row IO_EAST -location 954.0 {u_rocc_mem_req_data_i.u_io\[17\].u_in}
place_pad -row IO_EAST -location 1034.0 {u_rocc_mem_req_data_i.u_io\[18\].u_in}
place_pad -row IO_EAST -location 1114.0 {u_rocc_mem_req_data_i.u_io\[19\].u_in}
place_pad -row IO_EAST -location 1194.0 {u_rocc_mem_req_data_i.u_io\[20\].u_in}
place_pad -row IO_EAST -location 1274.0 {u_rocc_mem_req_data_i.u_io\[21\].u_in}
place_pad -row IO_EAST -location 1354.0 {u_rocc_mem_req_data_i.u_io\[22\].u_in}
place_pad -row IO_EAST -location 1434.0 {u_rocc_mem_req_data_i.u_io\[23\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_EAST -location 1514.0 {u_vzz_7}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_EAST -location 1594.0 {u_v18_7}
place_pad -row IO_EAST -location 1674.0 {u_rocc_mem_req_data_i.u_io\[24\].u_in}
place_pad -row IO_EAST -location 1754.0 {u_rocc_mem_req_data_i.u_io\[25\].u_in}
place_pad -row IO_EAST -location 1834.0 {u_rocc_mem_req_data_i.u_io\[26\].u_in}
place_pad -row IO_EAST -location 1914.0 {u_rocc_mem_req_data_i.u_io\[27\].u_in}
place_pad -row IO_EAST -location 1994.0 {u_rocc_mem_req_data_i.u_io\[28\].u_in}
place_pad -row IO_EAST -location 2074.0 {u_rocc_mem_req_data_i.u_io\[29\].u_in}
place_pad -row IO_EAST -location 2154.0 {u_rocc_mem_req_data_i.u_io\[30\].u_in}
place_pad -row IO_EAST -location 2234.0 {u_rocc_mem_req_data_i.u_io\[31\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_EAST -location 2314.0 {u_vzz_8}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_EAST -location 2394.0 {u_v18_8}
place_pad -row IO_EAST -location 2474.0 {u_rocc_mem_req_ready_o.u_io}
place_pad -row IO_EAST -location 2554.0 {u_rocc_mem_resp_v_o.u_io}
place_pad -row IO_EAST -location 2634.0 {u_rocc_mem_resp_data_o_0.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_EAST -location 2714.0 {u_vss_3}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_EAST -location 2794.0 {u_vdd_3}
place_pad -row IO_EAST -location 2874.0 {u_rocc_mem_resp_data_o_1.u_io}
place_pad -row IO_EAST -location 2954.0 {u_rocc_mem_resp_data_o_2.u_io}
place_pad -row IO_EAST -location 3034.0 {u_rocc_mem_resp_data_o_3.u_io}
place_pad -row IO_EAST -location 3114.0 {u_rocc_mem_resp_data_o_4.u_io}
place_pad -row IO_EAST -location 3194.0 {u_rocc_mem_resp_data_o_5.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_EAST -location 3274.0 {u_vzz_9}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_EAST -location 3354.0 {u_v18_9}
place_pad -row IO_EAST -location 3434.0 {u_rocc_mem_resp_data_o_6.u_io}
place_pad -row IO_EAST -location 3514.0 {u_rocc_mem_resp_data_o_7.u_io}
place_pad -row IO_EAST -location 3594.0 {u_rocc_mem_resp_data_o_8.u_io}
place_pad -row IO_EAST -location 3674.0 {u_rocc_mem_resp_data_o_9.u_io}
place_pad -row IO_EAST -location 3754.0 {u_rocc_mem_resp_data_o_10.u_io}
place_pad -row IO_EAST -location 3834.0 {u_rocc_mem_resp_data_o_11.u_io}
place_pad -row IO_EAST -location 3914.0 {u_rocc_mem_resp_data_o_12.u_io}
place_pad -row IO_EAST -location 3994.0 {u_rocc_mem_resp_data_o_13.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_EAST -location 4074.0 {u_vzz_10}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_EAST -location 4154.0 {u_v18_10}
place_pad -row IO_EAST -location 4234.0 {u_rocc_mem_resp_data_o_14.u_io}
place_pad -row IO_EAST -location 4314.0 {u_rocc_mem_resp_data_o_15.u_io}

place_pad -row IO_NORTH -location 4920.0 {u_rocc_mem_resp_data_o_16.u_io}
place_pad -row IO_NORTH -location 4840.0 {u_rocc_mem_resp_data_o_17.u_io}
place_pad -row IO_NORTH -location 4760.0 {u_rocc_mem_resp_data_o_18.u_io}
place_pad -row IO_NORTH -location 4680.0 {u_rocc_mem_resp_data_o_19.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_NORTH -location 4600.0 {u_vss_4}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_NORTH -location 4520.0 {u_vdd_4}
place_pad -row IO_NORTH -location 4440.0 {u_rocc_mem_resp_data_o_20.u_io}
place_pad -row IO_NORTH -location 4360.0 {u_rocc_mem_resp_data_o_21.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_NORTH -location 4280.0 {u_vzz_11}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_NORTH -location 4200.0 {u_v18_11}
place_pad -row IO_NORTH -location 4120.0 {u_rocc_mem_resp_data_o_22.u_io}
place_pad -row IO_NORTH -location 4040.0 {u_rocc_mem_resp_data_o_23.u_io}
place_pad -row IO_NORTH -location 3960.0 {u_rocc_mem_resp_data_o_24.u_io}
place_pad -row IO_NORTH -location 3880.0 {u_rocc_mem_resp_data_o_25.u_io}
place_pad -row IO_NORTH -location 3800.0 {u_rocc_mem_resp_data_o_26.u_io}
place_pad -row IO_NORTH -location 3720.0 {u_rocc_mem_resp_data_o_27.u_io}
place_pad -row IO_NORTH -location 3640.0 {u_rocc_mem_resp_data_o_28.u_io}
place_pad -row IO_NORTH -location 3560.0 {u_rocc_mem_resp_data_o_29.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_NORTH -location 3480.0 {u_vzz_12}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_NORTH -location 3400.0 {u_v18_12}
place_pad -row IO_NORTH -location 3320.0 {u_rocc_mem_resp_data_o_30.u_io}
place_pad -row IO_NORTH -location 3240.0 {u_rocc_mem_resp_data_o_31.u_io}
place_pad -row IO_NORTH -location 3160.0 {u_rocc_mem_resp_data_o_32.u_io}
place_pad -row IO_NORTH -location 3080.0 {u_rocc_mem_resp_data_o_33.u_io}
place_pad -row IO_NORTH -location 3000.0 {u_rocc_mem_resp_data_o_34.u_io}
place_pad -row IO_NORTH -location 2920.0 {u_rocc_mem_resp_data_o_35.u_io}
place_pad -row IO_NORTH -location 2840.0 {u_rocc_mem_resp_data_o_36.u_io}
place_pad -row IO_NORTH -location 2760.0 {u_rocc_mem_resp_data_o_37.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_NORTH -location 2680.0 {u_vzz_13}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_NORTH -location 2600.0 {u_v18_13}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_NORTH -location 2520.0 {u_vss_5}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_NORTH -location 2440.0 {u_vdd_5}
place_pad -row IO_NORTH -location 2360.0 {u_rocc_mem_resp_data_o_38.u_io}
place_pad -row IO_NORTH -location 2280.0 {u_rocc_mem_resp_data_o_39.u_io}
place_pad -row IO_NORTH -location 2200.0 {u_rocc_mem_resp_data_o_40.u_io}
place_pad -row IO_NORTH -location 2120.0 {u_rocc_mem_resp_data_o_41.u_io}
place_pad -row IO_NORTH -location 2040.0 {u_rocc_mem_resp_data_o_42.u_io}
place_pad -row IO_NORTH -location 1960.0 {u_rocc_mem_resp_data_o_43.u_io}
place_pad -row IO_NORTH -location 1880.0 {u_rocc_mem_resp_data_o_44.u_io}
place_pad -row IO_NORTH -location 1800.0 {u_rocc_mem_resp_data_o_45.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_NORTH -location 1720.0 {u_vzz_14}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_NORTH -location 1640.0 {u_v18_14}
place_pad -row IO_NORTH -location 1560.0 {u_rocc_mem_resp_data_o_46.u_io}
place_pad -row IO_NORTH -location 1480.0 {u_rocc_mem_resp_data_o_47.u_io}
place_pad -row IO_NORTH -location 1400.0 {u_rocc_mem_resp_data_o_48.u_io}
place_pad -row IO_NORTH -location 1320.0 {u_rocc_mem_resp_data_o_49.u_io}
place_pad -row IO_NORTH -location 1240.0 {u_rocc_mem_resp_data_o_50.u_io}
place_pad -row IO_NORTH -location 1160.0 {u_rocc_mem_resp_data_o_51.u_io}
place_pad -row IO_NORTH -location 1080.0 {u_rocc_mem_resp_data_o_52.u_io}
place_pad -row IO_NORTH -location 1000.0 {u_rocc_mem_resp_data_o_53.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_NORTH -location 920.0 {u_vzz_15}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_NORTH -location 840.0 {u_v18_15}
place_pad -row IO_NORTH -location 760.0 {u_rocc_mem_resp_data_o_54.u_io}
place_pad -row IO_NORTH -location 680.0 {u_rocc_mem_resp_data_o_55.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_NORTH -location 600.0 {u_vdd_6}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_NORTH -location 520.0 {u_vss_6}
place_pad -row IO_NORTH -location 440.0 {u_rocc_mem_resp_data_o_56.u_io}
place_pad -row IO_NORTH -location 360.0 {u_rocc_mem_resp_data_o_57.u_io}
place_pad -row IO_NORTH -location 280.0 {u_rocc_mem_resp_data_o_58.u_io}
place_pad -row IO_NORTH -location 200.0 {u_rocc_mem_resp_data_o_59.u_io}

place_pad -row IO_WEST -location 4300.0 {u_rocc_mem_resp_data_o_60.u_io}
place_pad -row IO_WEST -location 4220.0 {u_rocc_mem_resp_data_o_61.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_WEST -location 4140.0 {u_vzz_16}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_WEST -location 4060.0 {u_v18_16}
place_pad -row IO_WEST -location 3980.0 {u_rocc_mem_resp_data_o_62.u_io}
place_pad -row IO_WEST -location 3900.0 {u_rocc_mem_resp_data_o_63.u_io}
place_pad -row IO_WEST -location 3820.0 {u_fsb_node_v_i.u_in}
place_pad -row IO_WEST -location 3740.0 {u_fsb_node_data_i.u_io\[0\].u_in}
place_pad -row IO_WEST -location 3660.0 {u_fsb_node_data_i.u_io\[1\].u_in}
place_pad -row IO_WEST -location 3580.0 {u_fsb_node_data_i.u_io\[2\].u_in}
place_pad -row IO_WEST -location 3500.0 {u_fsb_node_data_i.u_io\[3\].u_in}
place_pad -row IO_WEST -location 3420.0 {u_fsb_node_data_i.u_io\[4\].u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_WEST -location 3340.0 {u_vzz_17}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_WEST -location 3260.0 {u_v18_17}
place_pad -row IO_WEST -location 3180.0 {u_fsb_node_data_i.u_io\[5\].u_in}
place_pad -row IO_WEST -location 3100.0 {u_fsb_node_data_i.u_io\[6\].u_in}
place_pad -row IO_WEST -location 3020.0 {u_fsb_node_data_i.u_io\[7\].u_in}
place_pad -row IO_WEST -location 2940.0 {u_fsb_node_ready_o.u_io}
place_pad -row IO_WEST -location 2860.0 {u_fsb_node_v_o.u_io}
place_pad -row IO_WEST -location 2780.0 {u_fsb_node_data_o_0.u_io}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_WEST -location 2700.0 {u_vss_7}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_WEST -location 2620.0 {u_vdd_7}
place_pad -row IO_WEST -location 2540.0 {u_fsb_node_data_o_1.u_io}
place_pad -row IO_WEST -location 2460.0 {u_fsb_node_data_o_2.u_io}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_WEST -location 2380.0 {u_vzz_18}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_WEST -location 2300.0 {u_v18_18}
place_pad -row IO_WEST -location 2220.0 {u_fsb_node_data_o_3.u_io}
place_pad -row IO_WEST -location 2140.0 {u_fsb_node_data_o_4.u_io}
place_pad -row IO_WEST -location 2060.0 {u_fsb_node_data_o_5.u_io}
place_pad -row IO_WEST -location 1980.0 {u_fsb_node_data_o_6.u_io}
place_pad -row IO_WEST -location 1900.0 {u_fsb_node_data_o_7.u_io}
place_pad -row IO_WEST -location 1820.0 {u_fsb_node_yumi_i.u_in}
place_pad -row IO_WEST -location 1740.0 {u_rocc_ctrl_i_busy_.u_in}
place_pad -row IO_WEST -location 1660.0 {u_rocc_ctrl_i_interrupt_.u_in}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_WEST -location 1580.0 {u_vzz_19}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_WEST -location 1500.0 {u_v18_19}
place_pad -row IO_WEST -location 1420.0 {u_rocc_ctrl_o_s_.u_io}
place_pad -row IO_WEST -location 1340.0 {u_rocc_ctrl_o_exception_.u_io}
place_pad -row IO_WEST -location 1260.0 {u_rocc_ctrl_o_host_id_.u_io}
place_pad -master sky130_ef_io__vccd_hvc_pad -row IO_WEST -location 780.0 {u_vdd_8}
place_pad -master sky130_ef_io__vssd_hvc_pad -row IO_WEST -location 700.0 {u_vss_8}
place_pad -master sky130_ef_io__vssio_hvc_pad -row IO_WEST -location 620.0 {u_vzz_20}
place_pad -master sky130_ef_io__vddio_hvc_pad -row IO_WEST -location 540.0 {u_v18_20}
place_pad -row IO_WEST -location 220.0 {u_clk_i.u_in}

# Place corners
place_corners sky130_ef_io__corner_pad

# Place IO fill
set iofill {sky130_ef_io__com_bus_slice_20um
            sky130_ef_io__com_bus_slice_10um
            sky130_ef_io__com_bus_slice_5um
            sky130_ef_io__com_bus_slice_1um}
place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST {*}$iofill
place_io_fill -row IO_EAST {*}$iofill

# Connect ring signals
connect_by_abutment

# The bond pads are integrated into the IO cell in sky130 so none
# are placed here.  We do need to assign the terminals a location
# that aligns to the bond pad.
place_io_terminals *u_io/PAD
place_io_terminals *u_in/PAD

remove_io_rows
