// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// TCDM Shim

// Description: Converts propper handshaking (ready/valid) to TCDM signaling
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

module tcdm_shim
  import mempool_pkg::address_map_t;
  import cf_math_pkg::idx_width;
#(
  parameter int unsigned AddrWidth           = 32            ,
  parameter int unsigned DataWidth           = 32            ,
  parameter int unsigned MaxOutStandingReads = 8             ,
  parameter int unsigned NrTCDM              = 2             ,
  parameter int unsigned NrSoC               = 1             ,
  parameter int unsigned NumRules            = 1             , // Routing rules
  localparam int unsigned StrbWidth          = DataWidth/8   ,
  localparam int unsigned NumOutput          = NrTCDM + NrSoC,
  localparam int unsigned MetaIdWidth        = idx_width(MaxOutStandingReads)
) (
  input  logic                                          clk_i,
  input  logic                                          rst_ni,
  // to TCDM
  output logic         [NrTCDM-1:0]                     tcdm_req_valid_o,
  output logic         [NrTCDM-1:0][AddrWidth-1:0]      tcdm_req_tgt_addr_o,
  output logic         [NrTCDM-1:0]                     tcdm_req_wen_o,
  output logic         [NrTCDM-1:0][DataWidth-1:0]      tcdm_req_wdata_o,
  output logic         [NrTCDM-1:0][3:0]                tcdm_req_amo_o,
  output logic         [NrTCDM-1:0][MetaIdWidth-1:0]    tcdm_req_id_o,
  output logic         [NrTCDM-1:0][StrbWidth-1:0]      tcdm_req_be_o,
  input  logic         [NrTCDM-1:0]                     tcdm_req_ready_i,
  input  logic         [NrTCDM-1:0]                     tcdm_resp_valid_i,
  output logic         [NrTCDM-1:0]                     tcdm_resp_ready_o,
  input  logic         [NrTCDM-1:0][DataWidth-1:0]      tcdm_resp_rdata_i,
  input  logic         [NrTCDM-1:0][MetaIdWidth-1:0]    tcdm_resp_id_i,
  // to SoC
  output logic         [NrSoC-1:0] [AddrWidth-1:0]      soc_qaddr_o,
  output logic         [NrSoC-1:0]                      soc_qwrite_o,
  output logic         [NrSoC-1:0] [3:0]                soc_qamo_o,
  output logic         [NrSoC-1:0] [DataWidth-1:0]      soc_qdata_o,
  output logic         [NrSoC-1:0] [StrbWidth-1:0]      soc_qstrb_o,
  output logic         [NrSoC-1:0]                      soc_qvalid_o,
  input  logic         [NrSoC-1:0]                      soc_qready_i,
  input  logic         [NrSoC-1:0] [DataWidth-1:0]      soc_pdata_i,
  input  logic         [NrSoC-1:0]                      soc_perror_i,
  input  logic         [NrSoC-1:0]                      soc_pvalid_i,
  output logic         [NrSoC-1:0]                      soc_pready_o,
  // from core
  input  logic         [AddrWidth-1:0]                  data_qaddr_i,
  input  logic                                          data_qwrite_i,
  input  logic         [3:0]                            data_qamo_i,
  input  logic         [DataWidth-1:0]                  data_qdata_i,
  input  logic         [StrbWidth-1:0]                  data_qstrb_i,
  input  logic         [MetaIdWidth-1:0]                data_qid_i,
  input  logic                                          data_qvalid_i,
  output logic                                          data_qready_o,
  output logic         [DataWidth-1:0]                  data_pdata_o,
  output logic                                          data_perror_o,
  output logic         [MetaIdWidth-1:0]                data_pid_o,
  output logic                                          data_pvalid_o,
  input  logic                                          data_pready_i,
  // Address map
  input  address_map_t [NumRules-1:0]                   address_map_i
);

  // Imports
  import snitch_pkg::dreq_t ;
  import snitch_pkg::dresp_t;

  // Includes
  `include "common_cells/registers.svh"

  dreq_t              data_qpayload ;
  dreq_t [NrSoC-1:0]  soc_qpayload ;
  dreq_t [NrTCDM-1:0] tcdm_qpayload;
  dresp_t              data_ppayload ;
  dresp_t [NrSoC-1:0]  soc_ppayload ;
  dresp_t [NrTCDM-1:0] tcdm_ppayload;

  for (genvar i = 0; i < NrTCDM; i++) begin : gen_tcdm_ppayload
    assign tcdm_ppayload[i].id    = tcdm_resp_id_i[i]   ;
    assign tcdm_ppayload[i].data  = tcdm_resp_rdata_i[i];
    assign tcdm_ppayload[i].error = 1'b0                ;
  end

  // ROB IDs of the SoC requests (come back in order)
  logic [NrSoC-1:0][MetaIdWidth-1:0] soc_meta_id;

  for (genvar i = 0; i < NrSoC; i++) begin: gen_soc_meta_id_fifo
    fifo_v3 #(
      .DEPTH     (MaxOutStandingReads),
      .DATA_WIDTH(MetaIdWidth        )
    ) i_soc_meta_id_fifo (
      .clk_i     (clk_i                                              ),
      .rst_ni    (rst_ni                                             ),
      .flush_i   (1'b0                                               ),
      .testmode_i(1'b0                                               ),
      .data_i    (data_qid_i                                         ),
      .push_i    (soc_qvalid_o[i] & soc_qready_i[i] &!soc_qwrite_o[i]),
      .full_o    (/* Unused */                                       ),
      .data_o    (soc_meta_id[i]                                     ),
      .pop_i     (soc_pvalid_i[i] & soc_pready_o[i]                  ),
      .empty_o   (/* Unused */                                       ),
      .usage_o   (/* Unused */                                       )
    );
  end: gen_soc_meta_id_fifo

  // Demux according to address
  snitch_addr_demux #(
    .NrOutput     (NumOutput),
    .AddressWidth (AddrWidth),
    .NumRules     (NumRules ), // TODO
    .req_t        (dreq_t   ),
    .resp_t       (dresp_t  )
  ) i_snitch_addr_demux (
    .clk_i         (clk_i                            ),
    .rst_ni        (rst_ni                           ),
    .req_addr_i    (data_qaddr_i                     ),
    .req_payload_i (data_qpayload                    ),
    .req_valid_i   (data_qvalid_i                    ),
    .req_ready_o   (data_qready_o                    ),
    .resp_payload_o(data_ppayload                    ),
    .resp_valid_o  (data_pvalid_o                    ),
    .resp_ready_i  (data_pready_i                    ),
    .req_payload_o ({soc_qpayload, tcdm_qpayload}    ),
    .req_valid_o   ({soc_qvalid_o, tcdm_req_valid_o} ),
    .req_ready_i   ({soc_qready_i, tcdm_req_ready_i} ),
    .resp_payload_i({soc_ppayload, tcdm_ppayload}    ),
    .resp_valid_i  ({soc_pvalid_i, tcdm_resp_valid_i}),
    .resp_ready_o  ({soc_pready_o, tcdm_resp_ready_o}),
    .address_map_i (address_map_i                    )
  );

  // Connect TCDM output ports
  for (genvar i = 0; i < NrTCDM; i++) begin : gen_tcdm_con
    assign tcdm_req_tgt_addr_o[i] = tcdm_qpayload[i].addr ;
    assign tcdm_req_wdata_o[i]    = tcdm_qpayload[i].data ;
    assign tcdm_req_amo_o[i]      = tcdm_qpayload[i].amo  ;
    assign tcdm_req_id_o[i]       = tcdm_qpayload[i].id   ;
    assign tcdm_req_wen_o[i]      = tcdm_qpayload[i].write;
    assign tcdm_req_be_o[i]       = tcdm_qpayload[i].strb ;
  end

  // Connect SOCs
  for (genvar i = 0; i < NrSoC; i++) begin : gen_soc_con
    assign soc_qaddr_o[i]        = soc_qpayload[i].addr ;
    assign soc_qwrite_o[i]       = soc_qpayload[i].write;
    assign soc_qamo_o[i]         = soc_qpayload[i].amo  ;
    assign soc_qdata_o[i]        = soc_qpayload[i].data ;
    assign soc_qstrb_o[i]        = soc_qpayload[i].strb ;
    assign soc_ppayload[i].data  = soc_pdata_i[i]       ;
    assign soc_ppayload[i].id    = soc_meta_id[i]       ;
    assign soc_ppayload[i].error = soc_perror_i[i]      ;
  end

  // Request interface
  assign data_qpayload.addr  = data_qaddr_i ;
  assign data_qpayload.write = data_qwrite_i;
  assign data_qpayload.amo   = data_qamo_i  ;
  assign data_qpayload.data  = data_qdata_i ;
  assign data_qpayload.id    = data_qid_i   ;
  assign data_qpayload.strb  = data_qstrb_i ;

  // Response interface
  assign data_pdata_o  = data_ppayload.data ;
  assign data_perror_o = data_ppayload.error;
  assign data_pid_o    = data_ppayload.id   ;

  // Elaboration-time assertions

  if (AddrWidth != 32)
    $fatal(1, "[tcdm_shim] Only support 32-bit wide addresses.");

  if (DataWidth != 32)
    $fatal(1, "[tcdm_shim] Only support a data width of 32 bits.");

endmodule
