// SPDX-License-Identifier: MulanPSL-2.0
// Copyright (c) 2024-2025 Beijing Institute of Open Source Chip (BOSC)
// Copyright (c) 2024-2025 Institute of Computing Technology, Chinese Academy of Sciences
// Changed from the original: rewritten as readable SystemVerilog from
// XiangShan's Chisel. SOURCE.md names the source and its license.
//
// chi_async_bridge: the asynchronous CHI bridge between XiangShan's tile
// and its network-on-chip, both halves in one block. README.md (beside
// config.mk) tells the story; this file only wires the halves together.
//
//   clock      the core clock: the tile half, chi_async_bridge_source.sv,
//              which XiangShan puts in XSTileWrap beside XSTile.
//   noc_clock  the NoC clock: the NoC half, chi_async_bridge_sink.sv,
//              which XiangShan puts in XSNoCTop.
//
// Every wire between the halves, the a_* signals below, crosses from one
// clock domain to the other. In XiangShan they are the pins between two
// separately built blocks; here they are nets inside one, so timing
// analysis sees both ends of every crossing.
//
// The tile side's ports keep the halves' own names; the NoC side's are
// prefixed noc_. Both halves are reset by noc_reset, each through its own
// reset synchroniser (XSTileWrap.scala:112, XSNoCTop.scala:84).
module chi_async_bridge #(
    parameter int REQ_W = 125,
    parameter int RSP_W = 51,
    parameter int DAT_W = 385,
    parameter int SNP_W = 88,
    parameter int DEPTH = 16,
    parameter int SYNC  = 3,
    localparam int B = $clog2(DEPTH)
) (
    input  logic             clock,
    input  logic             noc_clock,
    input  logic             noc_reset,
    input  logic             tx_req_flitv,
    input  logic [REQ_W-1:0] tx_req_flit,
    output logic             tx_req_lcrdv,
    input  logic             tx_rsp_flitv,
    input  logic [RSP_W-1:0] tx_rsp_flit,
    output logic             tx_rsp_lcrdv,
    input  logic             tx_dat_flitv,
    input  logic [DAT_W-1:0] tx_dat_flit,
    output logic             tx_dat_lcrdv,
    output logic             rx_rsp_flitv,
    output logic [RSP_W-1:0] rx_rsp_flit,
    input  logic             rx_rsp_lcrdv,
    output logic             rx_dat_flitv,
    output logic [DAT_W-1:0] rx_dat_flit,
    input  logic             rx_dat_lcrdv,
    output logic             rx_snp_flitv,
    output logic [SNP_W-1:0] rx_snp_flit,
    input  logic             rx_snp_lcrdv,
    input  logic [2:0]       tx_flitpend,
    output logic [2:0]       rx_flitpend,
    input  logic             tx_linkactivereq,
    output logic             tx_linkactiveack,
    output logic             rx_linkactivereq,
    input  logic             rx_linkactiveack,
    input  logic             txsactive,
    output logic             rxsactive,
    input  logic             syscoreq,
    output logic             syscoack,
    output logic             noc_tx_req_flitv,
    output logic [REQ_W-1:0] noc_tx_req_flit,
    input  logic             noc_tx_req_ready,
    input  logic             noc_tx_req_lcrdv,
    output logic             noc_tx_rsp_flitv,
    output logic [RSP_W-1:0] noc_tx_rsp_flit,
    input  logic             noc_tx_rsp_ready,
    input  logic             noc_tx_rsp_lcrdv,
    output logic             noc_tx_dat_flitv,
    output logic [DAT_W-1:0] noc_tx_dat_flit,
    input  logic             noc_tx_dat_ready,
    input  logic             noc_tx_dat_lcrdv,
    input  logic             noc_rx_rsp_flitv,
    input  logic [RSP_W-1:0] noc_rx_rsp_flit,
    output logic             noc_rx_rsp_lcrdv,
    input  logic             noc_rx_dat_flitv,
    input  logic [DAT_W-1:0] noc_rx_dat_flit,
    output logic             noc_rx_dat_lcrdv,
    input  logic             noc_rx_snp_flitv,
    input  logic [SNP_W-1:0] noc_rx_snp_flit,
    output logic             noc_rx_snp_lcrdv,
    output logic [2:0]       noc_tx_flitpend,
    input  logic [2:0]       noc_rx_flitpend,
    output logic             noc_tx_linkactivereq,
    input  logic             noc_tx_linkactiveack,
    input  logic             noc_rx_linkactivereq,
    output logic             noc_rx_linkactiveack,
    output logic             noc_txsactive,
    input  logic             noc_rxsactive,
    output logic             noc_syscoreq,
    input  logic             noc_syscoack
);
  logic tile_reset, noc_side_reset;
  reset_gen tile_reset_sync (
      .clock(clock), .reset(noc_reset), .o_reset(tile_reset));
  reset_gen noc_reset_sync (
      .clock(noc_clock), .reset(noc_reset), .o_reset(noc_side_reset));

  // The crossing.
  logic [DEPTH*REQ_W-1:0] a_tx_req_mem;
  logic [B:0]           a_tx_req_widx;
  logic [B:0]           a_tx_req_ridx;
  logic [DEPTH*RSP_W-1:0] a_tx_rsp_mem;
  logic [B:0]           a_tx_rsp_widx;
  logic [B:0]           a_tx_rsp_ridx;
  logic [DEPTH*DAT_W-1:0] a_tx_dat_mem;
  logic [B:0]           a_tx_dat_widx;
  logic [B:0]           a_tx_dat_ridx;
  logic [DEPTH*RSP_W-1:0] a_rx_rsp_mem;
  logic [B:0]           a_rx_rsp_widx;
  logic [B:0]           a_rx_rsp_ridx;
  logic [DEPTH*DAT_W-1:0] a_rx_dat_mem;
  logic [B:0]           a_rx_dat_widx;
  logic [B:0]           a_rx_dat_ridx;
  logic [DEPTH*SNP_W-1:0] a_rx_snp_mem;
  logic [B:0]           a_rx_snp_widx;
  logic [B:0]           a_rx_snp_ridx;
  logic [2:0][B:0]      a_tx_lcrdv_widx;
  logic [2:0][B:0]      a_tx_lcrdv_ridx;
  logic [2:0][B:0]      a_rx_lcrdv_widx;
  logic [2:0][B:0]      a_rx_lcrdv_ridx;
  logic [2:0]           a_tx_flitpend;
  logic [2:0]           a_rx_flitpend;
  logic                 a_tx_linkactivereq;
  logic                 a_tx_linkactiveack;
  logic                 a_rx_linkactivereq;
  logic                 a_rx_linkactiveack;
  logic                 a_txsactive;
  logic                 a_rxsactive;
  logic                 a_syscoreq;
  logic                 a_syscoack;

  chi_async_bridge_source #(
      .REQ_W(REQ_W), .RSP_W(RSP_W), .DAT_W(DAT_W), .SNP_W(SNP_W),
      .DEPTH(DEPTH), .SYNC(SYNC)
  ) source (
      .clock(clock),
      .reset(tile_reset),
      .reset_finish(),
      .*
  );

  chi_async_bridge_sink #(
      .REQ_W(REQ_W), .RSP_W(RSP_W), .DAT_W(DAT_W), .SNP_W(SNP_W),
      .DEPTH(DEPTH), .SYNC(SYNC)
  ) sink (
      .clock(noc_clock),
      .reset(noc_side_reset),
      .tx_req_flitv(noc_tx_req_flitv),
      .tx_req_flit(noc_tx_req_flit),
      .tx_req_ready(noc_tx_req_ready),
      .tx_req_lcrdv(noc_tx_req_lcrdv),
      .tx_rsp_flitv(noc_tx_rsp_flitv),
      .tx_rsp_flit(noc_tx_rsp_flit),
      .tx_rsp_ready(noc_tx_rsp_ready),
      .tx_rsp_lcrdv(noc_tx_rsp_lcrdv),
      .tx_dat_flitv(noc_tx_dat_flitv),
      .tx_dat_flit(noc_tx_dat_flit),
      .tx_dat_ready(noc_tx_dat_ready),
      .tx_dat_lcrdv(noc_tx_dat_lcrdv),
      .rx_rsp_flitv(noc_rx_rsp_flitv),
      .rx_rsp_flit(noc_rx_rsp_flit),
      .rx_rsp_lcrdv(noc_rx_rsp_lcrdv),
      .rx_dat_flitv(noc_rx_dat_flitv),
      .rx_dat_flit(noc_rx_dat_flit),
      .rx_dat_lcrdv(noc_rx_dat_lcrdv),
      .rx_snp_flitv(noc_rx_snp_flitv),
      .rx_snp_flit(noc_rx_snp_flit),
      .rx_snp_lcrdv(noc_rx_snp_lcrdv),
      .tx_flitpend(noc_tx_flitpend),
      .rx_flitpend(noc_rx_flitpend),
      .tx_linkactivereq(noc_tx_linkactivereq),
      .tx_linkactiveack(noc_tx_linkactiveack),
      .rx_linkactivereq(noc_rx_linkactivereq),
      .rx_linkactiveack(noc_rx_linkactiveack),
      .txsactive(noc_txsactive),
      .rxsactive(noc_rxsactive),
      .syscoreq(noc_syscoreq),
      .syscoack(noc_syscoack),
      .reset_finish(),
      .*
  );
endmodule
