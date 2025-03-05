// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Demux based on address


module snitch_addr_demux
  import mempool_pkg::address_map_t;
  import cf_math_pkg::idx_width;
#(
  parameter int unsigned NrOutput     = 2    ,
  parameter int unsigned AddressWidth = 32   ,
  parameter int unsigned NumRules     = 1    , // Routing rules
  parameter type req_t                = logic,
  parameter type resp_t               = logic,
  /// Dependent parameters, DO NOT OVERRIDE!
  localparam integer LogNrOutput      = idx_width(NrOutput)
) (
  input  logic                            clk_i,
  input  logic                            rst_ni,
  // request port
  input  logic         [AddressWidth-1:0] req_addr_i,
  input  req_t                            req_payload_i,
  input  logic                            req_valid_i,
  output logic                            req_ready_o,
  output resp_t                           resp_payload_o,
  output logic                            resp_valid_o,
  input  logic                            resp_ready_i,
  // response port
  output req_t         [NrOutput-1:0]     req_payload_o,
  output logic         [NrOutput-1:0]     req_valid_o,
  input  logic         [NrOutput-1:0]     req_ready_i,
  input  resp_t        [NrOutput-1:0]     resp_payload_i,
  input  logic         [NrOutput-1:0]     resp_valid_i,
  output logic         [NrOutput-1:0]     resp_ready_o,
  input  address_map_t [NumRules-1:0]     address_map_i
);

  logic [LogNrOutput-1:0]      slave_select;
  logic [NumRules-1:0]         addr_match;
  logic [idx_width(NumRules)-1:0] rule_select;

  assign slave_select = address_map_i[rule_select].slave_idx;

  // Address Decoder
  always_comb begin : addr_decoder
    for (int i = 0; i < NumRules; i++) begin
      addr_match[i] = (req_addr_i & address_map_i[i].mask) == address_map_i[i].value;
    end
  end

  find_first_one #(
    .WIDTH(NumRules)
  ) find_slave_select (
    .in_i       ( addr_match   ),
    .first_one_o( rule_select  ),
    .no_ones_o  ( /* Unused */ )
  );

  // Demux request to correct interconnect
  stream_demux #(
    .N_OUP ( NrOutput )
  ) i_req_demux (
    .inp_valid_i ( req_valid_i  ),
    .inp_ready_o ( req_ready_o  ),
    .oup_sel_i   ( slave_select ),
    .oup_valid_o ( req_valid_o  ),
    .oup_ready_i ( req_ready_i  )
  );

  for (genvar i = 0; i < NrOutput; i++) begin : gen_req_outputs
    assign req_payload_o[i] = req_payload_i;
  end

  // Merge the response streams
  logic [idx_width(NrOutput)-1:0] rr_prio;
  assign rr_prio = 0;

  rr_arb_tree #(
    .DataType (resp_t  ),
    .NumIn    (NrOutput),
    .AxiVldRdy(1'b1    ),
    .ExtPrio  (1'b1    )
  ) i_resp_stream_arbiter (
    .clk_i  (clk_i         ),
    .rst_ni (rst_ni        ),
    .flush_i(1'b0          ),
    .rr_i   (rr_prio       ),
    .req_i  (resp_valid_i  ),
    .data_i (resp_payload_i),
    .gnt_o  (resp_ready_o  ),
    .req_o  (resp_valid_o  ),
    .data_o (resp_payload_o),
    .gnt_i  (resp_ready_i  ),
    .idx_o  (/* Unused */  )
  );

  /* pragma translate_off */
  `ifdef FORMAL
  logic f_past_valid;
  initial f_past_valid = 1'b0;
  always @(posedge clk_i)
    f_past_valid <= 1'b1;
  // assert reset in time step zero and deassert
  assume property (@(posedge clk_i) !f_past_valid |-> !rst_ni);
  // make sure that we get a response for each read we issued
  for (genvar i = 0; i < NrOutput; i++) begin
    assume property (@(posedge clk_i) disable iff (!rst_ni) (resp_valid_i[i] & resp_ready_o[i]) |-> $past(req_valid_o[i] & req_ready_i[i] & !req_write_i));
  end
  `endif
  // check that we propagate a downstream request directly (e.g. combinatorial)
  assert property (@(posedge clk_i) disable iff (!rst_ni) (req_valid_i & req_ready_o) |-> |(req_valid_o & req_ready_i));
  /* pragma translate_on */

endmodule
