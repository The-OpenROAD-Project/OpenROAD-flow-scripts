// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Description: Load Store Unit (can handle `NumOutstandingLoads` outstanding loads) and
//              optionally NaNBox if used in a floating-point setting.
//              It supports out-of-order memory responses via metadata linking with IDs.

module snitch_lsu
  import cf_math_pkg::idx_width;
#(
  parameter type tag_t                       = logic [4:0],
  parameter int unsigned NumOutstandingLoads = 1,
  parameter bit NaNBox                       = 0,
  // Dependent parameters. DO NOT CHANGE.
  localparam int unsigned IdWidth = idx_width(NumOutstandingLoads)
) (
  input  logic               clk_i,
  input  logic               rst_i,
  // request channel
  input  tag_t               lsu_qtag_i,
  input  logic               lsu_qwrite,
  input  logic               lsu_qsigned,
  input  logic [31:0]        lsu_qaddr_i,
  input  logic [31:0]        lsu_qdata_i,
  input  logic [1:0]         lsu_qsize_i,
  input  logic [3:0]         lsu_qamo_i,
  input  logic               lsu_qvalid_i,
  output logic               lsu_qready_o,
  // response channel
  output logic [31:0]        lsu_pdata_o,
  output tag_t               lsu_ptag_o,
  output logic               lsu_perror_o,
  output logic               lsu_pvalid_o,
  input  logic               lsu_pready_i,
  // Memory Interface Channel
  output logic [31:0]        data_qaddr_o,
  output logic               data_qwrite_o,
  output logic [3:0]         data_qamo_o,
  output logic [31:0]        data_qdata_o,
  output logic [3:0]         data_qstrb_o,
  output logic [IdWidth-1:0] data_qid_o,
  output logic               data_qvalid_o,
  input  logic               data_qready_i,
  input  logic [31:0]        data_pdata_i,
  input  logic               data_perror_i,
  input  logic [IdWidth-1:0] data_pid_i,
  input  logic               data_pvalid_i,
  output logic               data_pready_o
);

  // ----------------
  // TYPEDEFS
  // ----------------

  typedef logic [IdWidth-1:0] meta_id_t;

  typedef struct packed {
    tag_t       tag;
    logic       sign_ext;
    logic [1:0] offset;
    logic [1:0] size;
  } metadata_t;

  // ----------------
  // SIGNALS
  // ----------------

  // ID Table
  logic      [NumOutstandingLoads-1:0] id_available_d, id_available_q;
  metadata_t [NumOutstandingLoads-1:0] metadata_d, metadata_q;
  metadata_t                           req_metadata;
  metadata_t                           resp_metadata;
  meta_id_t                            req_id;
  meta_id_t                            resp_id;
  logic                                id_table_push;
  logic                                id_table_pop;
  logic                                id_table_full;

  // Response
  logic [31:0] ld_result;

  // ----------------
  // ID TABLE
  // ----------------
  // Track ID availability and store metadata
  always_comb begin
    // Default
    id_available_d = id_available_q;
    metadata_d     = metadata_q;

    // Take ID and store metadata
    if (id_table_push) begin
      id_available_d[req_id] = 1'b0;
      metadata_d[req_id]     = req_metadata;
    end

    // Free ID
    if (id_table_pop) begin
      id_available_d[resp_id] = 1'b1;
    end
  end

  assign req_metadata = '{
    tag:      lsu_qtag_i,
    sign_ext: lsu_qsigned,
    offset:   lsu_qaddr_i[1:0],
    size:     lsu_qsize_i
  };

  assign resp_metadata = metadata_q[resp_id];

  // Search available ID for request
  lzc #(
    .WIDTH ( NumOutstandingLoads )
  ) i_req_id (
    .in_i   ( id_available_q ),
    .cnt_o  ( req_id         ),
    .empty_o( id_table_full  )
  );

  // Pop if response accepted
  assign id_table_pop = data_pvalid_i & data_pready_o;

  // Push if load request accepted
  assign id_table_push = ~lsu_qwrite & data_qready_i & data_qvalid_o;

  // ----------------
  // REQUEST
  // ----------------
  // only make a request when we got a valid request and if it is a load
  // also check that we can actually store the necessary information to process
  // it in the upcoming cycle(s).
  assign data_qvalid_o = (lsu_qvalid_i) & (lsu_qwrite | ~id_table_full);
  assign data_qwrite_o = lsu_qwrite;
  assign data_qaddr_o  = {lsu_qaddr_i[31:2], 2'b0};
  assign data_qamo_o   = lsu_qamo_i;
  assign data_qid_o    = req_id;
  // generate byte enable mask
  always_comb begin
    unique case (lsu_qsize_i)
      2'b00: data_qstrb_o = (4'b1 << lsu_qaddr_i[1:0]);
      2'b01: data_qstrb_o = (4'b11 << lsu_qaddr_i[1:0]);
      2'b10: data_qstrb_o = '1;
      default: data_qstrb_o = '0;
    endcase
  end

  // re-align write data
  /* verilator lint_off WIDTH */
  always_comb begin
    unique case (lsu_qaddr_i[1:0])
      2'b00: data_qdata_o = lsu_qdata_i;
      2'b01: data_qdata_o = {lsu_qdata_i[23:0], lsu_qdata_i[31:24]};
      2'b10: data_qdata_o = {lsu_qdata_i[15:0], lsu_qdata_i[31:16]};
      2'b11: data_qdata_o = {lsu_qdata_i[ 7:0], lsu_qdata_i[31: 8]};
      default: data_qdata_o = lsu_qdata_i;
    endcase
  end
  /* verilator lint_on WIDTH */

  // the interface didn't accept our request yet
  assign lsu_qready_o = ~(data_qvalid_o & ~data_qready_i) & ~id_table_full;

  // ----------------
  // RESPONSE
  // ----------------
  // Return Path
  // shift the load data back by offset bytes
  logic [31:0] shifted_data;
  assign shifted_data = data_pdata_i >> {resp_metadata.offset, 3'b000};
  always_comb begin
    unique case (resp_metadata.size)
      2'b00: ld_result = {{24{shifted_data[ 7] & resp_metadata.sign_ext}}, shifted_data[7:0]};
      2'b01: ld_result = {{16{shifted_data[15] & resp_metadata.sign_ext}}, shifted_data[15:0]};
      2'b10: ld_result = shifted_data;
      default: ld_result = shifted_data;
    endcase
  end

  assign resp_id       = data_pid_i;
  assign lsu_perror_o  = data_perror_i;
  assign lsu_pdata_o   = ld_result;
  assign lsu_ptag_o    = resp_metadata.tag;
  assign lsu_pvalid_o  = data_pvalid_i;
  assign data_pready_o = lsu_pready_i;

  // ----------------
  // SEQUENTIAL
  // ----------------
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      id_available_q <= '1;
      metadata_q     <= 'b0;
    end else begin
      id_available_q <= id_available_d;
      metadata_q     <= metadata_d;
    end
  end

  // ----------------
  // ASSERTIONS
  // ----------------
  // Check for unsupported parameters
  if (NumOutstandingLoads == 0)
    $error(1, "[snitch_lsu] NumOutstandingLoads cannot be 0.");

  // pragma translate_off
  `ifndef VERILATOR
    invalid_req_id : assert property(
      @(posedge clk_i) disable iff (rst_i) (!(id_table_push & ~id_available_q[req_id])))
      else $fatal (1, "Request ID is not available.");
  `endif

  `ifndef VERILATOR
    invalid_resp_id : assert property(
      @(posedge clk_i) disable iff (rst_i) (!(id_table_pop & id_available_q[resp_id])))
      else $fatal (1, "Response ID does not match with valid metadata.");
  `endif
  // pragma translate_on

endmodule
