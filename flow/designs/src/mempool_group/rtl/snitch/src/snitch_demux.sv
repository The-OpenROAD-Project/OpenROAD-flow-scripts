// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Arbitrates request/response interface
/// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

/// Demux based on arbitration
module snitch_demux #(
    parameter int unsigned NrPorts            = 4,
    parameter type req_t                      = snitch_pkg::dreq_t,
    parameter type resp_t                     = snitch_pkg::dresp_t,
    parameter int unsigned RespDepth          = 8,
    parameter bit [NrPorts-1:0] RegisterReq   = '0,
    parameter              Arbiter            = "rr"    // "rr" or "prio"
) (
    input  logic   clk_i,
    input  logic   rst_ni,
    // request port
    input  req_t  [NrPorts-1:0] req_payload_i,
    input  logic  [NrPorts-1:0] req_valid_i,
    output logic  [NrPorts-1:0] req_ready_o,

    output resp_t [NrPorts-1:0] resp_payload_o,
    output logic  [NrPorts-1:0] resp_last_o,
    output logic  [NrPorts-1:0] resp_valid_o,
    input  logic  [NrPorts-1:0] resp_ready_i,
    // response port
    output req_t  req_payload_o,
    output logic  req_valid_o,
    input  logic  req_ready_i,

    input  resp_t resp_payload_i,
    input  logic  resp_last_i,
    input  logic  resp_valid_i,
    output logic  resp_ready_o
);

  localparam LogNrPorts = (NrPorts > 1) ? $clog2(NrPorts) : 1;

  logic [NrPorts-1:0] req_valid_masked;
  logic [NrPorts-1:0] req_ready_masked;
  logic [LogNrPorts-1:0] idx, idx_rsp;
  logic full;

  req_t  [NrPorts-1:0] req_payload_q;
  logic  [NrPorts-1:0] req_valid_q;
  logic  [NrPorts-1:0] req_ready_q;

  // Cut the incoming path
  for (genvar i = 0; i < NrPorts; i++) begin : gen_spill_regs
      spill_register  #(
        .T      ( req_t          ),
        .Bypass ( !RegisterReq[i] )
      ) i_spill_register_tcdm_req (
        .clk_i,
        .rst_ni,
        .valid_i ( req_valid_i      [i] ),
        .ready_o ( req_ready_o      [i] ),
        .data_i  ( req_payload_i    [i] ),
        .valid_o ( req_valid_q      [i] ),
        .ready_i ( req_ready_masked [i] ),
        .data_o  ( req_payload_q    [i] )
      );
  end

  for (genvar i = 0; i < NrPorts; i++) begin : gen_req_valid_masked
    assign req_valid_masked[i] = req_valid_q[i] & ~full;
    assign req_ready_masked[i] = req_ready_q[i] & ~full;
  end

  /// Arbitrate on instruction request port
  stream_arbiter #(
    .DATA_T  ( req_t   ),
    .N_INP   ( NrPorts ),
    .ARBITER ( Arbiter )
  ) i_stream_arbiter_req (
    .clk_i,
    .rst_ni,
    .inp_data_i   ( req_payload_q    ),
    .inp_valid_i  ( req_valid_masked ),
    .inp_ready_o  ( req_ready_q      ),
    .oup_data_o   ( req_payload_o    ),
    .oup_valid_o  ( req_valid_o      ),
    .oup_ready_i  ( req_ready_i      )
  );

  if (NrPorts == 1) begin
    assign idx_rsp = 0;
    assign full = 1'b0;
  end else begin
    onehot_to_bin #(
      .ONEHOT_WIDTH ( NrPorts )
    ) i_onehot_to_bin (
      .onehot ( req_valid_q & req_ready_q ),
      .bin    ( idx                       )
    );

    fifo_v3 #(
       .DATA_WIDTH ( LogNrPorts                                       ),
       .DEPTH      ( RespDepth                                        )
     ) i_resp_fifo (
       .clk_i,
       .rst_ni,
       .flush_i    ( 1'b0                                             ),
       .testmode_i ( 1'b0                                             ),
       .full_o     ( full                                             ),
       .empty_o    (                                                  ),
       .usage_o    (                                                  ),
       .data_i     ( idx                                              ),
       // only reads will generate a response message
       .push_i     ( req_valid_o & req_ready_i & ~req_payload_o.write ),
       .data_o     ( idx_rsp                                          ),
       .pop_i      ( resp_ready_o & resp_valid_i & resp_last_i        )
     );
   end

  stream_demux #(
    .N_OUP       ( NrPorts    )
  ) i_stream_demux_resp (
    .inp_valid_i ( resp_valid_i ),
    .inp_ready_o ( resp_ready_o ),
    .oup_sel_i   ( idx_rsp      ),
    .oup_valid_o ( resp_valid_o ),
    .oup_ready_i ( resp_ready_i )
  );

  for (genvar i = 0; i < NrPorts; i++) begin
    assign resp_payload_o[i] = resp_payload_i;
    assign resp_last_o[i] = resp_last_i;
  end

endmodule
