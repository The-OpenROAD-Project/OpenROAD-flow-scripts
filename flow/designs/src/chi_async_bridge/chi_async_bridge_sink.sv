// SPDX-License-Identifier: MulanPSL-2.0
// Copyright (c) 2020-2021 Institute of Computing Technology, Chinese Academy of Sciences
// Copyright (c) 2020-2021 Peng Cheng Laboratory
// Changed from the original: rewritten as readable SystemVerilog from
// XiangShan's Chisel. SOURCE.md names the source and its license.
//
// The NoC's half of the bridge, on the NoC clock: XSCache's
// CHIAsyncBridgeSink (xscache/chi/AsyncBridge.scala:227-341 at 300515b),
// which XSNoCTop instantiates (XSNoCTop.scala:275-276). The mirror image
// of chi_async_bridge_source.sv: tx flits arrive through async queue
// sinks, rx rsp and dat leave through shadow buffers and async queue
// sources, rx snp through an async queue source alone.
//
// Not modelled: the NoC link layer at AsyncBridge.scala:297-339 (the
// link-state machines and the L-credit managers that return rx credits
// early and hold tx flits back). It is logic of the NoC's own clock
// domain on the far side of the crossing; here its ready and credits are
// ports, and rx credits cross back the way snp's always do.
module chi_async_bridge_sink #(
    parameter int REQ_W = 125,
    parameter int RSP_W = 51,
    parameter int DAT_W = 385,
    parameter int SNP_W = 88,
    parameter int DEPTH = 16,
    parameter int SYNC  = 3,
    localparam int B = $clog2(DEPTH)
) (
    input logic clock,
    input logic reset,

    // The NoC's CHI port.
    output logic             tx_req_flitv,
    output logic [REQ_W-1:0] tx_req_flit,
    input  logic             tx_req_ready,
    input  logic             tx_req_lcrdv,
    output logic             tx_rsp_flitv,
    output logic [RSP_W-1:0] tx_rsp_flit,
    input  logic             tx_rsp_ready,
    input  logic             tx_rsp_lcrdv,
    output logic             tx_dat_flitv,
    output logic [DAT_W-1:0] tx_dat_flit,
    input  logic             tx_dat_ready,
    input  logic             tx_dat_lcrdv,
    input  logic             rx_rsp_flitv,
    input  logic [RSP_W-1:0] rx_rsp_flit,
    output logic             rx_rsp_lcrdv,
    input  logic             rx_dat_flitv,
    input  logic [DAT_W-1:0] rx_dat_flit,
    output logic             rx_dat_lcrdv,
    input  logic             rx_snp_flitv,
    input  logic [SNP_W-1:0] rx_snp_flit,
    output logic             rx_snp_lcrdv,
    output logic [      2:0] tx_flitpend,         // req, rsp, dat
    input  logic [      2:0] rx_flitpend,         // rsp, dat, snp
    output logic             tx_linkactivereq,
    input  logic             tx_linkactiveack,
    input  logic             rx_linkactivereq,
    output logic             rx_linkactiveack,
    output logic             txsactive,
    input  logic             rxsactive,
    output logic             syscoreq,
    input  logic             syscoack,
    output logic             reset_finish,

    // The asynchronous side, to the tile half.
    input  logic [DEPTH*REQ_W-1:0] a_tx_req_mem,
    input  logic [            B:0] a_tx_req_widx,
    output logic [            B:0] a_tx_req_ridx,
    input  logic [DEPTH*RSP_W-1:0] a_tx_rsp_mem,
    input  logic [            B:0] a_tx_rsp_widx,
    output logic [            B:0] a_tx_rsp_ridx,
    input  logic [DEPTH*DAT_W-1:0] a_tx_dat_mem,
    input  logic [            B:0] a_tx_dat_widx,
    output logic [            B:0] a_tx_dat_ridx,
    output logic [DEPTH*RSP_W-1:0] a_rx_rsp_mem,
    output logic [            B:0] a_rx_rsp_widx,
    input  logic [            B:0] a_rx_rsp_ridx,
    output logic [DEPTH*DAT_W-1:0] a_rx_dat_mem,
    output logic [            B:0] a_rx_dat_widx,
    input  logic [            B:0] a_rx_dat_ridx,
    output logic [DEPTH*SNP_W-1:0] a_rx_snp_mem,
    output logic [            B:0] a_rx_snp_widx,
    input  logic [            B:0] a_rx_snp_ridx,
    output logic [          2:0][B:0] a_tx_lcrdv_widx,
    input  logic [          2:0][B:0] a_tx_lcrdv_ridx,
    input  logic [          2:0][B:0] a_rx_lcrdv_widx,
    output logic [          2:0][B:0] a_rx_lcrdv_ridx,
    input  logic [          2:0] a_tx_flitpend,
    output logic [          2:0] a_rx_flitpend,
    input  logic             a_tx_linkactivereq,
    output logic             a_tx_linkactiveack,
    output logic             a_rx_linkactivereq,
    input  logic             a_rx_linkactiveack,
    input  logic             a_txsactive,
    output logic             a_rxsactive,
    input  logic             a_syscoreq,
    output logic             a_syscoack
);
  // ---- tx: async queue sink, held back by the NoC's ready -------------
  `define CHI_TX(ch, W)                                                    \
    logic ch``_valid;                                                      \
    async_queue_sink #(.WIDTH(W), .DEPTH(DEPTH), .SYNC(SYNC))               \
        asyncQSink_``ch``_flit (                                           \
        .clock(clock), .reset(reset),                                      \
        .deq_valid(ch``_valid), .deq_ready(tx_``ch``_ready),                \
        .deq_bits(tx_``ch``_flit), .async_mem(a_tx_``ch``_mem),             \
        .async_ridx(a_tx_``ch``_ridx), .async_widx(a_tx_``ch``_widx));       \
    assign tx_``ch``_flitv = ch``_valid && tx_``ch``_ready;
  `CHI_TX(req, REQ_W)
  `CHI_TX(rsp, RSP_W)
  `CHI_TX(dat, DAT_W)
  `undef CHI_TX

  // ---- rx: shadow buffer and async queue source (snp: no buffer) ------
  `define CHI_RX_BUF(ch, W)                                                \
    logic ch``_sb_valid, ch``_sb_ready;                                    \
    logic [W-1:0] ch``_sb_bits;                                            \
    shadow_buffer #(.WIDTH(W)) shadowBuffer_``ch``_flit (                   \
        .clock(clock), .reset(reset),                                      \
        .enq_valid(rx_``ch``_flitv), .enq_ready(), .enq_bits(rx_``ch``_flit), \
        .deq_valid(ch``_sb_valid), .deq_ready(ch``_sb_ready),               \
        .deq_bits(ch``_sb_bits));                                          \
    async_queue_source #(.WIDTH(W), .DEPTH(DEPTH), .SYNC(SYNC))             \
        asyncQSource_``ch``_flit (                                         \
        .clock(clock), .reset(reset),                                      \
        .enq_valid(ch``_sb_valid), .enq_ready(ch``_sb_ready),               \
        .enq_bits(ch``_sb_bits), .async_mem(a_rx_``ch``_mem),               \
        .async_ridx(a_rx_``ch``_ridx), .async_widx(a_rx_``ch``_widx));
  `CHI_RX_BUF(rsp, RSP_W)
  `CHI_RX_BUF(dat, DAT_W)
  `undef CHI_RX_BUF
  async_queue_source #(.WIDTH(SNP_W), .DEPTH(DEPTH), .SYNC(SYNC))
      asyncQSource_snp_flit (
      .clock(clock), .reset(reset),
      .enq_valid(rx_snp_flitv), .enq_ready(), .enq_bits(rx_snp_flit),
      .async_mem(a_rx_snp_mem), .async_ridx(a_rx_snp_ridx),
      .async_widx(a_rx_snp_widx));

  // ---- link credits, as pulse queues ----------------------------------
  logic [2:0] tx_lcrdv, rx_lcrdv;
  assign tx_lcrdv = {tx_dat_lcrdv, tx_rsp_lcrdv, tx_req_lcrdv};
  for (genvar c = 0; c < 3; c++) begin : lcrdv
    async_queue_source #(.WIDTH(1), .DEPTH(DEPTH), .SYNC(SYNC), .PULSE(1'b1))
        asyncQBitSource_tx_lcrdv (
        .clock(clock), .reset(reset),
        .enq_valid(tx_lcrdv[c]), .enq_ready(), .enq_bits(1'b0),
        .async_mem(), .async_ridx(a_tx_lcrdv_ridx[c]),
        .async_widx(a_tx_lcrdv_widx[c]));
    async_queue_sink #(.WIDTH(1), .DEPTH(DEPTH), .SYNC(SYNC), .PULSE(1'b1))
        asyncQBitSink_rx_lcrdv (
        .clock(clock), .reset(reset),
        .deq_valid(rx_lcrdv[c]), .deq_ready(1'b1), .deq_bits(),
        .async_mem('0), .async_ridx(a_rx_lcrdv_ridx[c]),
        .async_widx(a_rx_lcrdv_widx[c]));
  end
  assign {rx_snp_lcrdv, rx_dat_lcrdv, rx_rsp_lcrdv} = rx_lcrdv;

  // ---- link handshakes ------------------------------------------------
  // Out: straight through (AsyncBridge.scala:258-264).
  assign a_rxsactive        = rxsactive;
  assign a_tx_linkactiveack = tx_linkactiveack;
  assign a_rx_linkactivereq = rx_linkactivereq;
  assign a_syscoack         = syscoack;
  assign a_rx_flitpend      = rx_flitpend;

  // In: synchronised (AsyncBridge.scala:277-284).
  logic [6:0] in_sync;
  sync_shift_reg #(.WIDTH(7), .SYNC(SYNC)) sync_link (
      .clock(clock), .reset(reset),
      .d({a_tx_flitpend, a_syscoreq, a_tx_linkactivereq, a_rx_linkactiveack,
          a_txsactive}),
      .q(in_sync));
  assign txsactive        = in_sync[0];
  assign rx_linkactiveack = in_sync[1] && reset_finish;
  assign tx_linkactivereq = in_sync[2] && reset_finish;
  assign syscoreq         = in_sync[3];
  assign tx_flitpend      = in_sync[6:4];

  // resetFinish: 100 cycles after reset (AsyncBridge.scala:286-292).
  localparam int RESET_FINISH_MAX = 100;
  logic [7:0] reset_finish_counter;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) reset_finish_counter <= '0;
    else if (reset_finish_counter < 8'(RESET_FINISH_MAX))
      reset_finish_counter <= reset_finish_counter + 1'b1;
  end
  assign reset_finish = reset_finish_counter >= 8'(RESET_FINISH_MAX);
endmodule
