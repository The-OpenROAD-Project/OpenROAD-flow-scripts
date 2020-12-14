module coyote_tc (
  clk_i,
  reset_i,
  en_i,
  rocc_cmd_v_o,
  rocc_cmd_data_o,
  rocc_cmd_ready_i,
  rocc_resp_v_i,
  rocc_resp_data_i,
  rocc_resp_ready_o,
  rocc_mem_req_v_i,
  rocc_mem_req_data_i,
  rocc_mem_req_ready_o,
  rocc_mem_resp_v_o,
  rocc_mem_resp_data_o,
  fsb_node_v_i,
  fsb_node_data_i,
  fsb_node_ready_o,
  fsb_node_v_o,
  fsb_node_data_o,
  fsb_node_yumi_i,
  rocc_ctrl_i_busy_,
  rocc_ctrl_i_interrupt_,
  rocc_ctrl_o_s_,
  rocc_ctrl_o_exception_,
  rocc_ctrl_o_host_id_,
  TDI,
  TDO,
  TCK,
  TRST,
  TMS
);

  output [15:0] rocc_cmd_data_o;
  input [7:0] rocc_resp_data_i;
  input [31:0] rocc_mem_req_data_i;
  output [63:0] rocc_mem_resp_data_o;
  input [7:0] fsb_node_data_i;
  output [7:0] fsb_node_data_o;
  input clk_i;
  input reset_i;
  input en_i;
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
  input TDI;
  output TDO;
  input TCK;
  input TMS;
  input TRST;

  wire [7:0] fsb_node_datai;
  wire [31:0] rocc_mem_req_data;

  tap_controller u_tap (
    .TDI(tdi),
    .TDO(tdo),
    .TMS(tms),
    .TRST(trst),
    .TCK(tck)
  );

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

  input_pad u_clk (.PAD(clk_i), .y(clk));
  input_pad u_reset (.PAD(reset_i), .y(reset));
  input_pad u_en (.PAD(en_i), .y(en));
  input_pad u_rocc_cmd_ready (.PAD(rocc_cmd_ready_i), .y(rocc_cmd_ready));
  input_pad u_rocc_resp_v (.PAD(rocc_resp_v_i), .y(rocc_resp_v));
  input_pad u_rocc_mem_req_v (.PAD(rocc_mem_req_v_i), .y(rocc_mem_req_v));
  input_pad u_fsb_node_v_i (.PAD(fsb_node_v_i), .y(fsb_node_vi));
  input_pad u_fsb_node_yumi (.PAD(fsb_node_yumi_i), .y(fsb_node_yumi));
  input_pad u_rocc_ctrl_i_busy (.PAD(rocc_ctrl_i_busy_), .y(rocc_ctrl_busy));
  input_pad u_rocc_ctrl_i_interrupt (.PAD(rocc_ctrl_i_interrupt_), .y(rocc_ctrl_interrupt));

  input_bus #(.WIDTH(8)) u_rocc_resp_data_i (.PAD(rocc_resp_data_i), .y(rocc_resp_data));
  input_bus #(.WIDTH(32)) u_rocc_mem_req_data_i (.PAD(rocc_mem_req_data_i), .y(rocc_mem_req_data));
  input_bus #(.WIDTH(8)) u_fsb_node_data_i (.PAD(fsb_node_data_i), .y(fsb_node_datai));

  output_pad u_rocc_cmd_data_o_0_ (.PAD(rocc_cmd_data_o[0]), .a(rocc_cmd_data_int[0]));
  output_pad u_rocc_cmd_data_o_1_ (.PAD(rocc_cmd_data_o[1]), .a(rocc_cmd_data_int[1]));
  output_pad u_rocc_cmd_data_o_2_ (.PAD(rocc_cmd_data_o[2]), .a(rocc_cmd_data_int[2]));
  output_pad u_rocc_cmd_data_o_3_ (.PAD(rocc_cmd_data_o[3]), .a(rocc_cmd_data_int[3]));
  output_pad u_rocc_cmd_data_o_4_ (.PAD(rocc_cmd_data_o[4]), .a(rocc_cmd_data_int[4]));
  output_pad u_rocc_cmd_data_o_5_ (.PAD(rocc_cmd_data_o[5]), .a(rocc_cmd_data_int[5]));
  output_pad u_rocc_cmd_data_o_6_ (.PAD(rocc_cmd_data_o[6]), .a(rocc_cmd_data_int[6]));
  output_pad u_rocc_cmd_data_o_7_ (.PAD(rocc_cmd_data_o[7]), .a(rocc_cmd_data_int[7]));
  output_pad u_rocc_cmd_data_o_8_ (.PAD(rocc_cmd_data_o[8]), .a(rocc_cmd_data_int[8]));
  output_pad u_rocc_cmd_data_o_9_ (.PAD(rocc_cmd_data_o[9]), .a(rocc_cmd_data_int[9]));
  output_pad u_rocc_cmd_data_o_10_ (.PAD(rocc_cmd_data_o[10]), .a(rocc_cmd_data_int[10]));
  output_pad u_rocc_cmd_data_o_11_ (.PAD(rocc_cmd_data_o[11]), .a(rocc_cmd_data_int[11]));
  output_pad u_rocc_cmd_data_o_12_ (.PAD(rocc_cmd_data_o[12]), .a(rocc_cmd_data_int[12]));
  output_pad u_rocc_cmd_data_o_13_ (.PAD(rocc_cmd_data_o[13]), .a(rocc_cmd_data_int[13]));
  output_pad u_rocc_cmd_data_o_14_ (.PAD(rocc_cmd_data_o[14]), .a(rocc_cmd_data_int[14]));
  output_pad u_rocc_cmd_data_o_15_ (.PAD(rocc_cmd_data_o[15]), .a(rocc_cmd_data_int[15]));
  output_pad u_rocc_mem_resp_data_o_0_ (.PAD(rocc_mem_resp_data_o[0]), .a(rocc_mem_resp_data_int[0]));
  output_pad u_rocc_mem_resp_data_o_1_ (.PAD(rocc_mem_resp_data_o[1]), .a(rocc_mem_resp_data_int[1]));
  output_pad u_rocc_mem_resp_data_o_2_ (.PAD(rocc_mem_resp_data_o[2]), .a(rocc_mem_resp_data_int[2]));
  output_pad u_rocc_mem_resp_data_o_3_ (.PAD(rocc_mem_resp_data_o[3]), .a(rocc_mem_resp_data_int[3]));
  output_pad u_rocc_mem_resp_data_o_4_ (.PAD(rocc_mem_resp_data_o[4]), .a(rocc_mem_resp_data_int[4]));
  output_pad u_rocc_mem_resp_data_o_5_ (.PAD(rocc_mem_resp_data_o[5]), .a(rocc_mem_resp_data_int[5]));
  output_pad u_rocc_mem_resp_data_o_6_ (.PAD(rocc_mem_resp_data_o[6]), .a(rocc_mem_resp_data_int[6]));
  output_pad u_rocc_mem_resp_data_o_7_ (.PAD(rocc_mem_resp_data_o[7]), .a(rocc_mem_resp_data_int[7]));
  output_pad u_rocc_mem_resp_data_o_8_ (.PAD(rocc_mem_resp_data_o[8]), .a(rocc_mem_resp_data_int[8]));
  output_pad u_rocc_mem_resp_data_o_9_ (.PAD(rocc_mem_resp_data_o[9]), .a(rocc_mem_resp_data_int[9]));
  output_pad u_rocc_mem_resp_data_o_10_ (.PAD(rocc_mem_resp_data_o[10]), .a(rocc_mem_resp_data_int[10]));
  output_pad u_rocc_mem_resp_data_o_11_ (.PAD(rocc_mem_resp_data_o[11]), .a(rocc_mem_resp_data_int[11]));
  output_pad u_rocc_mem_resp_data_o_12_ (.PAD(rocc_mem_resp_data_o[12]), .a(rocc_mem_resp_data_int[12]));
  output_pad u_rocc_mem_resp_data_o_13_ (.PAD(rocc_mem_resp_data_o[13]), .a(rocc_mem_resp_data_int[13]));
  output_pad u_rocc_mem_resp_data_o_14_ (.PAD(rocc_mem_resp_data_o[14]), .a(rocc_mem_resp_data_int[14]));
  output_pad u_rocc_mem_resp_data_o_15_ (.PAD(rocc_mem_resp_data_o[15]), .a(rocc_mem_resp_data_int[15]));
  output_pad u_rocc_mem_resp_data_o_16_ (.PAD(rocc_mem_resp_data_o[16]), .a(rocc_mem_resp_data_int[16]));
  output_pad u_rocc_mem_resp_data_o_17_ (.PAD(rocc_mem_resp_data_o[17]), .a(rocc_mem_resp_data_int[17]));
  output_pad u_rocc_mem_resp_data_o_18_ (.PAD(rocc_mem_resp_data_o[18]), .a(rocc_mem_resp_data_int[18]));
  output_pad u_rocc_mem_resp_data_o_19_ (.PAD(rocc_mem_resp_data_o[19]), .a(rocc_mem_resp_data_int[19]));
  output_pad u_rocc_mem_resp_data_o_20_ (.PAD(rocc_mem_resp_data_o[20]), .a(rocc_mem_resp_data_int[20]));
  output_pad u_rocc_mem_resp_data_o_21_ (.PAD(rocc_mem_resp_data_o[21]), .a(rocc_mem_resp_data_int[21]));
  output_pad u_rocc_mem_resp_data_o_22_ (.PAD(rocc_mem_resp_data_o[22]), .a(rocc_mem_resp_data_int[22]));
  output_pad u_rocc_mem_resp_data_o_23_ (.PAD(rocc_mem_resp_data_o[23]), .a(rocc_mem_resp_data_int[23]));
  output_pad u_rocc_mem_resp_data_o_24_ (.PAD(rocc_mem_resp_data_o[24]), .a(rocc_mem_resp_data_int[24]));
  output_pad u_rocc_mem_resp_data_o_25_ (.PAD(rocc_mem_resp_data_o[25]), .a(rocc_mem_resp_data_int[25]));
  output_pad u_rocc_mem_resp_data_o_26_ (.PAD(rocc_mem_resp_data_o[26]), .a(rocc_mem_resp_data_int[26]));
  output_pad u_rocc_mem_resp_data_o_27_ (.PAD(rocc_mem_resp_data_o[27]), .a(rocc_mem_resp_data_int[27]));
  output_pad u_rocc_mem_resp_data_o_28_ (.PAD(rocc_mem_resp_data_o[28]), .a(rocc_mem_resp_data_int[28]));
  output_pad u_rocc_mem_resp_data_o_29_ (.PAD(rocc_mem_resp_data_o[29]), .a(rocc_mem_resp_data_int[29]));
  output_pad u_rocc_mem_resp_data_o_30_ (.PAD(rocc_mem_resp_data_o[30]), .a(rocc_mem_resp_data_int[30]));
  output_pad u_rocc_mem_resp_data_o_31_ (.PAD(rocc_mem_resp_data_o[31]), .a(rocc_mem_resp_data_int[31]));
  output_pad u_rocc_mem_resp_data_o_32_ (.PAD(rocc_mem_resp_data_o[32]), .a(rocc_mem_resp_data_int[32]));
  output_pad u_rocc_mem_resp_data_o_33_ (.PAD(rocc_mem_resp_data_o[33]), .a(rocc_mem_resp_data_int[33]));
  output_pad u_rocc_mem_resp_data_o_34_ (.PAD(rocc_mem_resp_data_o[34]), .a(rocc_mem_resp_data_int[34]));
  output_pad u_rocc_mem_resp_data_o_35_ (.PAD(rocc_mem_resp_data_o[35]), .a(rocc_mem_resp_data_int[35]));
  output_pad u_rocc_mem_resp_data_o_36_ (.PAD(rocc_mem_resp_data_o[36]), .a(rocc_mem_resp_data_int[36]));
  output_pad u_rocc_mem_resp_data_o_37_ (.PAD(rocc_mem_resp_data_o[37]), .a(rocc_mem_resp_data_int[37]));
  output_pad u_rocc_mem_resp_data_o_38_ (.PAD(rocc_mem_resp_data_o[38]), .a(rocc_mem_resp_data_int[38]));
  output_pad u_rocc_mem_resp_data_o_39_ (.PAD(rocc_mem_resp_data_o[39]), .a(rocc_mem_resp_data_int[39]));
  output_pad u_rocc_mem_resp_data_o_40_ (.PAD(rocc_mem_resp_data_o[40]), .a(rocc_mem_resp_data_int[40]));
  output_pad u_rocc_mem_resp_data_o_41_ (.PAD(rocc_mem_resp_data_o[41]), .a(rocc_mem_resp_data_int[41]));
  output_pad u_rocc_mem_resp_data_o_42_ (.PAD(rocc_mem_resp_data_o[42]), .a(rocc_mem_resp_data_int[42]));
  output_pad u_rocc_mem_resp_data_o_43_ (.PAD(rocc_mem_resp_data_o[43]), .a(rocc_mem_resp_data_int[43]));
  output_pad u_rocc_mem_resp_data_o_44_ (.PAD(rocc_mem_resp_data_o[44]), .a(rocc_mem_resp_data_int[44]));
  output_pad u_rocc_mem_resp_data_o_45_ (.PAD(rocc_mem_resp_data_o[45]), .a(rocc_mem_resp_data_int[45]));
  output_pad u_rocc_mem_resp_data_o_46_ (.PAD(rocc_mem_resp_data_o[46]), .a(rocc_mem_resp_data_int[46]));
  output_pad u_rocc_mem_resp_data_o_47_ (.PAD(rocc_mem_resp_data_o[47]), .a(rocc_mem_resp_data_int[47]));
  output_pad u_rocc_mem_resp_data_o_48_ (.PAD(rocc_mem_resp_data_o[48]), .a(rocc_mem_resp_data_int[48]));
  output_pad u_rocc_mem_resp_data_o_49_ (.PAD(rocc_mem_resp_data_o[49]), .a(rocc_mem_resp_data_int[49]));
  output_pad u_rocc_mem_resp_data_o_50_ (.PAD(rocc_mem_resp_data_o[50]), .a(rocc_mem_resp_data_int[50]));
  output_pad u_rocc_mem_resp_data_o_51_ (.PAD(rocc_mem_resp_data_o[51]), .a(rocc_mem_resp_data_int[51]));
  output_pad u_rocc_mem_resp_data_o_52_ (.PAD(rocc_mem_resp_data_o[52]), .a(rocc_mem_resp_data_int[52]));
  output_pad u_rocc_mem_resp_data_o_53_ (.PAD(rocc_mem_resp_data_o[53]), .a(rocc_mem_resp_data_int[53]));
  output_pad u_rocc_mem_resp_data_o_54_ (.PAD(rocc_mem_resp_data_o[54]), .a(rocc_mem_resp_data_int[54]));
  output_pad u_rocc_mem_resp_data_o_55_ (.PAD(rocc_mem_resp_data_o[55]), .a(rocc_mem_resp_data_int[55]));
  output_pad u_rocc_mem_resp_data_o_56_ (.PAD(rocc_mem_resp_data_o[56]), .a(rocc_mem_resp_data_int[56]));
  output_pad u_rocc_mem_resp_data_o_57_ (.PAD(rocc_mem_resp_data_o[57]), .a(rocc_mem_resp_data_int[57]));
  output_pad u_rocc_mem_resp_data_o_58_ (.PAD(rocc_mem_resp_data_o[58]), .a(rocc_mem_resp_data_int[58]));
  output_pad u_rocc_mem_resp_data_o_59_ (.PAD(rocc_mem_resp_data_o[59]), .a(rocc_mem_resp_data_int[59]));
  output_pad u_rocc_mem_resp_data_o_60_ (.PAD(rocc_mem_resp_data_o[60]), .a(rocc_mem_resp_data_int[60]));
  output_pad u_rocc_mem_resp_data_o_61_ (.PAD(rocc_mem_resp_data_o[61]), .a(rocc_mem_resp_data_int[61]));
  output_pad u_rocc_mem_resp_data_o_62_ (.PAD(rocc_mem_resp_data_o[62]), .a(rocc_mem_resp_data_int[62]));
  output_pad u_rocc_mem_resp_data_o_63_ (.PAD(rocc_mem_resp_data_o[63]), .a(rocc_mem_resp_data_int[63]));
  output_pad u_fsb_node_data_o_0_ (.PAD(fsb_node_data_o[0]), .a(fsb_node_data_o_int[0]));
  output_pad u_fsb_node_data_o_1_ (.PAD(fsb_node_data_o[1]), .a(fsb_node_data_o_int[1]));
  output_pad u_fsb_node_data_o_2_ (.PAD(fsb_node_data_o[2]), .a(fsb_node_data_o_int[2]));
  output_pad u_fsb_node_data_o_3_ (.PAD(fsb_node_data_o[3]), .a(fsb_node_data_o_int[3]));
  output_pad u_fsb_node_data_o_4_ (.PAD(fsb_node_data_o[4]), .a(fsb_node_data_o_int[4]));
  output_pad u_fsb_node_data_o_5_ (.PAD(fsb_node_data_o[5]), .a(fsb_node_data_o_int[5]));
  output_pad u_fsb_node_data_o_6_ (.PAD(fsb_node_data_o[6]), .a(fsb_node_data_o_int[6]));
  output_pad u_fsb_node_data_o_7_ (.PAD(fsb_node_data_o[7]), .a(fsb_node_data_o_int[7]));

  output_pad u_rocc_cmd_v (.PAD(rocc_cmd_v_o), .a(rocc_cmd_v));
  output_pad u_rocc_resp_ready (.PAD(rocc_resp_ready_o), .a(rocc_resp_ready));
  output_pad u_rocc_mem_req_ready (.PAD(rocc_mem_req_ready_o), .a(rocc_mem_req_ready));
  output_pad u_rocc_mem_resp_v (.PAD(rocc_mem_resp_v_o), .a(rocc_mem_resp_v));
  output_pad u_fsb_node_ready (.PAD(fsb_node_ready_o), .a(fsb_node_ready));
  output_pad u_fsb_node_v_o (.PAD(fsb_node_v_o), .a(fsb_node_vo));
  output_pad u_rocc_ctrl_o_s (.PAD(rocc_ctrl_o_s_), .a(rocc_ctrl_s));
  output_pad u_rocc_ctrl_o_exception (.PAD(rocc_ctrl_o_exception_), .a(rocc_ctrl_exception));
  output_pad u_rocc_ctrl_o_host_id (.PAD(rocc_ctrl_o_host_id_), .a(rocc_ctrl_host_id));

  input_pad u_tck(.PAD(TCK), .y(tck));
  input_pad u_tdi(.PAD(TDI), .y(tdi));
  input_pad u_tms(.PAD(TMS), .y(tms));
  input_pad u_trst(.PAD(TRST), .y(trst));
  output_pad u_tdo(.PAD(TDO), .a(tdo));
endmodule

module tap_controller (
  input TCK,
  input TMS,
  input TRST,
  input TDI,
  output TDO
);

endmodule

