module coyote_tc (
  clk_i,
  reset_i,
  rocc_cmd_v_o,
  rocc_cmd_data_o_0,
  rocc_cmd_data_o_1,
  rocc_cmd_data_o_2,
  rocc_cmd_data_o_3,
  rocc_cmd_data_o_4,
  rocc_cmd_data_o_5,
  rocc_cmd_data_o_6,
  rocc_cmd_data_o_7,
  rocc_cmd_data_o_8,
  rocc_cmd_data_o_9,
  rocc_cmd_data_o_10,
  rocc_cmd_data_o_11,
  rocc_cmd_data_o_12,
  rocc_cmd_data_o_13,
  rocc_cmd_data_o_14,
  rocc_cmd_data_o_15,
  rocc_cmd_ready_i,
  rocc_resp_v_i,
  rocc_resp_data_i,
  rocc_resp_ready_o,
  rocc_mem_req_v_i,
  rocc_mem_req_data_i,
  rocc_mem_req_ready_o,
  rocc_mem_resp_v_o,
  rocc_mem_resp_data_o_0,
  rocc_mem_resp_data_o_1,
  rocc_mem_resp_data_o_2,
  rocc_mem_resp_data_o_3,
  rocc_mem_resp_data_o_4,
  rocc_mem_resp_data_o_5,
  rocc_mem_resp_data_o_6,
  rocc_mem_resp_data_o_7,
  rocc_mem_resp_data_o_8,
  rocc_mem_resp_data_o_9,
  rocc_mem_resp_data_o_10,
  rocc_mem_resp_data_o_11,
  rocc_mem_resp_data_o_12,
  rocc_mem_resp_data_o_13,
  rocc_mem_resp_data_o_14,
  rocc_mem_resp_data_o_15,
  rocc_mem_resp_data_o_16,
  rocc_mem_resp_data_o_17,
  rocc_mem_resp_data_o_18,
  rocc_mem_resp_data_o_19,
  rocc_mem_resp_data_o_20,
  rocc_mem_resp_data_o_21,
  rocc_mem_resp_data_o_22,
  rocc_mem_resp_data_o_23,
  rocc_mem_resp_data_o_24,
  rocc_mem_resp_data_o_25,
  rocc_mem_resp_data_o_26,
  rocc_mem_resp_data_o_27,
  rocc_mem_resp_data_o_28,
  rocc_mem_resp_data_o_29,
  rocc_mem_resp_data_o_30,
  rocc_mem_resp_data_o_31,
  rocc_mem_resp_data_o_32,
  rocc_mem_resp_data_o_33,
  rocc_mem_resp_data_o_34,
  rocc_mem_resp_data_o_35,
  rocc_mem_resp_data_o_36,
  rocc_mem_resp_data_o_37,
  rocc_mem_resp_data_o_38,
  rocc_mem_resp_data_o_39,
  rocc_mem_resp_data_o_40,
  rocc_mem_resp_data_o_41,
  rocc_mem_resp_data_o_42,
  rocc_mem_resp_data_o_43,
  rocc_mem_resp_data_o_44,
  rocc_mem_resp_data_o_45,
  rocc_mem_resp_data_o_46,
  rocc_mem_resp_data_o_47,
  rocc_mem_resp_data_o_48,
  rocc_mem_resp_data_o_49,
  rocc_mem_resp_data_o_50,
  rocc_mem_resp_data_o_51,
  rocc_mem_resp_data_o_52,
  rocc_mem_resp_data_o_53,
  rocc_mem_resp_data_o_54,
  rocc_mem_resp_data_o_55,
  rocc_mem_resp_data_o_56,
  rocc_mem_resp_data_o_57,
  rocc_mem_resp_data_o_58,
  rocc_mem_resp_data_o_59,
  rocc_mem_resp_data_o_60,
  rocc_mem_resp_data_o_61,
  rocc_mem_resp_data_o_62,
  rocc_mem_resp_data_o_63,
  fsb_node_v_i,
  fsb_node_data_i,
  fsb_node_ready_o,
  fsb_node_v_o,
  fsb_node_data_o_0,
  fsb_node_data_o_1,
  fsb_node_data_o_2,
  fsb_node_data_o_3,
  fsb_node_data_o_4,
  fsb_node_data_o_5,
  fsb_node_data_o_6,
  fsb_node_data_o_7,
  fsb_node_yumi_i,
  rocc_ctrl_i_busy_,
  rocc_ctrl_i_interrupt_,
  rocc_ctrl_o_s_,
  rocc_ctrl_o_exception_,
  rocc_ctrl_o_host_id_
);

  output rocc_cmd_data_o_0;
  output rocc_cmd_data_o_1;
  output rocc_cmd_data_o_2;
  output rocc_cmd_data_o_3;
  output rocc_cmd_data_o_4;
  output rocc_cmd_data_o_5;
  output rocc_cmd_data_o_6;
  output rocc_cmd_data_o_7;
  output rocc_cmd_data_o_8;
  output rocc_cmd_data_o_9;
  output rocc_cmd_data_o_10;
  output rocc_cmd_data_o_11;
  output rocc_cmd_data_o_12;
  output rocc_cmd_data_o_13;
  output rocc_cmd_data_o_14;
  output rocc_cmd_data_o_15;
  input [7:0] rocc_resp_data_i;
  input [31:0] rocc_mem_req_data_i;
  output rocc_mem_resp_data_o_0;
  output rocc_mem_resp_data_o_1;
  output rocc_mem_resp_data_o_2;
  output rocc_mem_resp_data_o_3;
  output rocc_mem_resp_data_o_4;
  output rocc_mem_resp_data_o_5;
  output rocc_mem_resp_data_o_6;
  output rocc_mem_resp_data_o_7;
  output rocc_mem_resp_data_o_8;
  output rocc_mem_resp_data_o_9;
  output rocc_mem_resp_data_o_10;
  output rocc_mem_resp_data_o_11;
  output rocc_mem_resp_data_o_12;
  output rocc_mem_resp_data_o_13;
  output rocc_mem_resp_data_o_14;
  output rocc_mem_resp_data_o_15;
  output rocc_mem_resp_data_o_16;
  output rocc_mem_resp_data_o_17;
  output rocc_mem_resp_data_o_18;
  output rocc_mem_resp_data_o_19;
  output rocc_mem_resp_data_o_20;
  output rocc_mem_resp_data_o_21;
  output rocc_mem_resp_data_o_22;
  output rocc_mem_resp_data_o_23;
  output rocc_mem_resp_data_o_24;
  output rocc_mem_resp_data_o_25;
  output rocc_mem_resp_data_o_26;
  output rocc_mem_resp_data_o_27;
  output rocc_mem_resp_data_o_28;
  output rocc_mem_resp_data_o_29;
  output rocc_mem_resp_data_o_30;
  output rocc_mem_resp_data_o_31;
  output rocc_mem_resp_data_o_32;
  output rocc_mem_resp_data_o_33;
  output rocc_mem_resp_data_o_34;
  output rocc_mem_resp_data_o_35;
  output rocc_mem_resp_data_o_36;
  output rocc_mem_resp_data_o_37;
  output rocc_mem_resp_data_o_38;
  output rocc_mem_resp_data_o_39;
  output rocc_mem_resp_data_o_40;
  output rocc_mem_resp_data_o_41;
  output rocc_mem_resp_data_o_42;
  output rocc_mem_resp_data_o_43;
  output rocc_mem_resp_data_o_44;
  output rocc_mem_resp_data_o_45;
  output rocc_mem_resp_data_o_46;
  output rocc_mem_resp_data_o_47;
  output rocc_mem_resp_data_o_48;
  output rocc_mem_resp_data_o_49;
  output rocc_mem_resp_data_o_50;
  output rocc_mem_resp_data_o_51;
  output rocc_mem_resp_data_o_52;
  output rocc_mem_resp_data_o_53;
  output rocc_mem_resp_data_o_54;
  output rocc_mem_resp_data_o_55;
  output rocc_mem_resp_data_o_56;
  output rocc_mem_resp_data_o_57;
  output rocc_mem_resp_data_o_58;
  output rocc_mem_resp_data_o_59;
  output rocc_mem_resp_data_o_60;
  output rocc_mem_resp_data_o_61;
  output rocc_mem_resp_data_o_62;
  output rocc_mem_resp_data_o_63;
  input [7:0] fsb_node_data_i;
  output fsb_node_data_o_0;
  output fsb_node_data_o_1;
  output fsb_node_data_o_2;
  output fsb_node_data_o_3;
  output fsb_node_data_o_4;
  output fsb_node_data_o_5;
  output fsb_node_data_o_6;
  output fsb_node_data_o_7;
  input clk_i;
  input reset_i;
  input rocc_cmd_ready_i;
  input rocc_resp_v_i;
  input rocc_mem_req_v_i;
  input fsb_node_v_i;
  input fsb_node_yumi_i;
  input rocc_ctrl_i_busy_;
  input rocc_ctrl_i_interrupt_;
  output rocc_cmd_v_o;
  output rocc_resp_ready_o;
  output rocc_mem_req_ready_o;
  output rocc_mem_resp_v_o;
  output fsb_node_ready_o;
  output fsb_node_v_o;
  output rocc_ctrl_o_s_;
  output rocc_ctrl_o_exception_;
  output rocc_ctrl_o_host_id_;

  wire [7:0] fsb_node_datai;
  wire [31:0] rocc_mem_req_data;

  reg [68:0] rocc_resp_data_int;
  reg [122:0] rocc_mem_req_data_int;
  reg [79:0] fsb_node_data_i_int;

  always @(posedge clk or negedge reset) begin
    if (~reset)
    begin
      rocc_resp_data_int <= 69'b0;
      rocc_mem_req_data_int <= 123'b0;
      fsb_node_data_i_int <= 80'b0;
    end
    else
    begin
      rocc_resp_data_int <= {61'b0,rocc_resp_data};
      rocc_mem_req_data_int <= {91'b0,rocc_mem_req_data};
      fsb_node_data_i_int <= {72'b0,fsb_node_datai};
    end
  end

  bsg_rocket_node_client_rocc u_coyote (
    .clk_i(clk),
    .reset_i(reset),
    .en_i(en),
    .rocc_cmd_v_o(rocc_cmd_v),
    .rocc_cmd_data_o(rocc_cmd_data_int),
    .rocc_cmd_ready_i(rocc_cmd_ready),
    .rocc_resp_v_i(rocc_resp_v),
    .rocc_resp_data_i(rocc_resp_data_int),
    .rocc_resp_ready_o(rocc_resp_ready),
    .rocc_mem_req_v_i(rocc_mem_req_v),
    .rocc_mem_req_data_i(rocc_mem_req_data_int),
    .rocc_mem_req_ready_o(rocc_mem_req_ready),
    .rocc_mem_resp_v_o(rocc_mem_resp_v),
    .rocc_mem_resp_data_o(rocc_mem_resp_data_int),
    .fsb_node_v_i(fsb_node_vi),
    .fsb_node_data_i(fsb_node_data_i_int),
    .fsb_node_ready_o(fsb_node_ready),
    .fsb_node_v_o(fsb_node_vo),
    .fsb_node_data_o(fsb_node_data_o_int),
    .fsb_node_yumi_i(fsb_node_yumi),
    .rocc_ctrl_i_busy_(rocc_ctrl_busy),
    .rocc_ctrl_i_interrupt_(rocc_ctrl_interrupt),
    .rocc_ctrl_o_s_(rocc_ctrl_s),
    .rocc_ctrl_o_exception_(rocc_ctrl_exception),
    .rocc_ctrl_o_host_id_(rocc_ctrl_host_id)
  );  
  
  core_pg_pads #(.NUM_PAIRS(9)) u_core_pg ();
  io_pg_pads #(.NUM_PAIRS(20)) u_io_pg ();

  `INPUT_PAD(clk_i, clk);
  `INPUT_PAD(reset_i, reset);
  `INPUT_PAD(en_i, en);
  `INPUT_PAD(rocc_cmd_ready_i, rocc_cmd_ready);
  `INPUT_PAD(rocc_resp_v_i, rocc_resp_v);
  `INPUT_PAD(rocc_mem_req_v_i, rocc_mem_req_v);
  `INPUT_PAD(fsb_node_v_i, fsb_node_vi);
  `INPUT_PAD(fsb_node_yumi_i, fsb_node_yumi);
  `INPUT_PAD(rocc_ctrl_i_busy_, rocc_ctrl_busy);
  `INPUT_PAD(rocc_ctrl_i_interrupt_, rocc_ctrl_interrupt);

  input_bus #(.WIDTH(8)) u_rocc_resp_data_i (.PAD(rocc_resp_data_i), .y(rocc_resp_data), `ABUT);
  input_bus #(.WIDTH(32)) u_rocc_mem_req_data_i (.PAD(rocc_mem_req_data_i), .y(rocc_mem_req_data), `ABUT);
  input_bus #(.WIDTH(8)) u_fsb_node_data_i (.PAD(fsb_node_data_i), .y(fsb_node_datai), `ABUT);

  `OUTPUT_PAD(rocc_cmd_data_o_0, rocc_cmd_data_int[0]);
  `OUTPUT_PAD(rocc_cmd_data_o_1, rocc_cmd_data_int[1]);
  `OUTPUT_PAD(rocc_cmd_data_o_2, rocc_cmd_data_int[2]);
  `OUTPUT_PAD(rocc_cmd_data_o_3, rocc_cmd_data_int[3]);
  `OUTPUT_PAD(rocc_cmd_data_o_4, rocc_cmd_data_int[4]);
  `OUTPUT_PAD(rocc_cmd_data_o_5, rocc_cmd_data_int[5]);
  `OUTPUT_PAD(rocc_cmd_data_o_6, rocc_cmd_data_int[6]);
  `OUTPUT_PAD(rocc_cmd_data_o_7, rocc_cmd_data_int[7]);
  `OUTPUT_PAD(rocc_cmd_data_o_8, rocc_cmd_data_int[8]);
  `OUTPUT_PAD(rocc_cmd_data_o_9, rocc_cmd_data_int[9]);
  `OUTPUT_PAD(rocc_cmd_data_o_10, rocc_cmd_data_int[10]);
  `OUTPUT_PAD(rocc_cmd_data_o_11, rocc_cmd_data_int[11]);
  `OUTPUT_PAD(rocc_cmd_data_o_12, rocc_cmd_data_int[12]);
  `OUTPUT_PAD(rocc_cmd_data_o_13, rocc_cmd_data_int[13]);
  `OUTPUT_PAD(rocc_cmd_data_o_14, rocc_cmd_data_int[14]);
  `OUTPUT_PAD(rocc_cmd_data_o_15, rocc_cmd_data_int[15]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_0, rocc_mem_resp_data_int[0]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_1, rocc_mem_resp_data_int[1]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_2, rocc_mem_resp_data_int[2]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_3, rocc_mem_resp_data_int[3]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_4, rocc_mem_resp_data_int[4]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_5, rocc_mem_resp_data_int[5]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_6, rocc_mem_resp_data_int[6]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_7, rocc_mem_resp_data_int[7]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_8, rocc_mem_resp_data_int[8]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_9, rocc_mem_resp_data_int[9]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_10, rocc_mem_resp_data_int[10]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_11, rocc_mem_resp_data_int[11]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_12, rocc_mem_resp_data_int[12]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_13, rocc_mem_resp_data_int[13]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_14, rocc_mem_resp_data_int[14]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_15, rocc_mem_resp_data_int[15]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_16, rocc_mem_resp_data_int[16]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_17, rocc_mem_resp_data_int[17]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_18, rocc_mem_resp_data_int[18]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_19, rocc_mem_resp_data_int[19]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_20, rocc_mem_resp_data_int[20]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_21, rocc_mem_resp_data_int[21]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_22, rocc_mem_resp_data_int[22]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_23, rocc_mem_resp_data_int[23]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_24, rocc_mem_resp_data_int[24]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_25, rocc_mem_resp_data_int[25]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_26, rocc_mem_resp_data_int[26]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_27, rocc_mem_resp_data_int[27]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_28, rocc_mem_resp_data_int[28]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_29, rocc_mem_resp_data_int[29]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_30, rocc_mem_resp_data_int[30]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_31, rocc_mem_resp_data_int[31]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_32, rocc_mem_resp_data_int[32]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_33, rocc_mem_resp_data_int[33]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_34, rocc_mem_resp_data_int[34]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_35, rocc_mem_resp_data_int[35]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_36, rocc_mem_resp_data_int[36]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_37, rocc_mem_resp_data_int[37]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_38, rocc_mem_resp_data_int[38]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_39, rocc_mem_resp_data_int[39]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_40, rocc_mem_resp_data_int[40]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_41, rocc_mem_resp_data_int[41]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_42, rocc_mem_resp_data_int[42]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_43, rocc_mem_resp_data_int[43]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_44, rocc_mem_resp_data_int[44]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_45, rocc_mem_resp_data_int[45]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_46, rocc_mem_resp_data_int[46]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_47, rocc_mem_resp_data_int[47]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_48, rocc_mem_resp_data_int[48]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_49, rocc_mem_resp_data_int[49]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_50, rocc_mem_resp_data_int[50]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_51, rocc_mem_resp_data_int[51]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_52, rocc_mem_resp_data_int[52]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_53, rocc_mem_resp_data_int[53]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_54, rocc_mem_resp_data_int[54]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_55, rocc_mem_resp_data_int[55]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_56, rocc_mem_resp_data_int[56]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_57, rocc_mem_resp_data_int[57]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_58, rocc_mem_resp_data_int[58]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_59, rocc_mem_resp_data_int[59]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_60, rocc_mem_resp_data_int[60]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_61, rocc_mem_resp_data_int[61]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_62, rocc_mem_resp_data_int[62]);
  `OUTPUT_PAD(rocc_mem_resp_data_o_63, rocc_mem_resp_data_int[63]);
  `OUTPUT_PAD(fsb_node_data_o_0, fsb_node_data_o_int[0]);
  `OUTPUT_PAD(fsb_node_data_o_1, fsb_node_data_o_int[1]);
  `OUTPUT_PAD(fsb_node_data_o_2, fsb_node_data_o_int[2]);
  `OUTPUT_PAD(fsb_node_data_o_3, fsb_node_data_o_int[3]);
  `OUTPUT_PAD(fsb_node_data_o_4, fsb_node_data_o_int[4]);
  `OUTPUT_PAD(fsb_node_data_o_5, fsb_node_data_o_int[5]);
  `OUTPUT_PAD(fsb_node_data_o_6, fsb_node_data_o_int[6]);
  `OUTPUT_PAD(fsb_node_data_o_7, fsb_node_data_o_int[7]);

  `OUTPUT_PAD(rocc_cmd_v_o, rocc_cmd_v);
  `OUTPUT_PAD(rocc_resp_ready_o, rocc_resp_ready);
  `OUTPUT_PAD(rocc_mem_req_ready_o, rocc_mem_req_ready);
  `OUTPUT_PAD(rocc_mem_resp_v_o, rocc_mem_resp_v);
  `OUTPUT_PAD(fsb_node_ready_o, fsb_node_ready);
  `OUTPUT_PAD(fsb_node_v_o, fsb_node_vo);
  `OUTPUT_PAD(rocc_ctrl_o_s_, rocc_ctrl_s);
  `OUTPUT_PAD(rocc_ctrl_o_exception_, rocc_ctrl_exception);
  `OUTPUT_PAD(rocc_ctrl_o_host_id_, rocc_ctrl_host_id);

  `INPUT_PAD(TCK, tck);
  `INPUT_PAD(TDI, tdi);
  `INPUT_PAD(TMS, tms);
  `INPUT_PAD(TRST, trst);
  `OUTPUT_PAD(TDO, tdo);
endmodule

