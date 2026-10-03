// The tile's half of the bridge, on the core clock: XSCache's
// CHIAsyncBridgeSource (xscache/chi/AsyncBridge.scala:157-225 at
// 300515b), which XSTileWrap instantiates beside XSTile
// (XSTileWrap.scala:190-196).
//
//   tx  req, rsp, dat: flits from the tile's L2 enter a shadow buffer and
//       an async queue source; the NoC half returns a link credit for
//       each through a pulse queue.
//   rx  rsp, dat, snp: flits from the NoC leave an async queue sink; the
//       tile's link credits go back through pulse queues.
//   link handshakes from the NoC half cross through SYNC-deep
//       synchronisers; those going out pass straight through.
module chi_async_bridge_source #(
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

    // The tile's CHI port (CoupledL2's link layer, registered outside).
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
    input  logic [      2:0] tx_flitpend,         // req, rsp, dat
    output logic [      2:0] rx_flitpend,         // rsp, dat, snp
    input  logic             tx_linkactivereq,
    output logic             tx_linkactiveack,
    output logic             rx_linkactivereq,
    input  logic             rx_linkactiveack,
    input  logic             txsactive,
    output logic             rxsactive,
    input  logic             syscoreq,
    output logic             syscoack,
    output logic             reset_finish,

    // The asynchronous side, to the NoC half.
    output logic [DEPTH*REQ_W-1:0] a_tx_req_mem,
    output logic [            B:0] a_tx_req_widx,
    input  logic [            B:0] a_tx_req_ridx,
    output logic [DEPTH*RSP_W-1:0] a_tx_rsp_mem,
    output logic [            B:0] a_tx_rsp_widx,
    input  logic [            B:0] a_tx_rsp_ridx,
    output logic [DEPTH*DAT_W-1:0] a_tx_dat_mem,
    output logic [            B:0] a_tx_dat_widx,
    input  logic [            B:0] a_tx_dat_ridx,
    input  logic [DEPTH*RSP_W-1:0] a_rx_rsp_mem,
    input  logic [            B:0] a_rx_rsp_widx,
    output logic [            B:0] a_rx_rsp_ridx,
    input  logic [DEPTH*DAT_W-1:0] a_rx_dat_mem,
    input  logic [            B:0] a_rx_dat_widx,
    output logic [            B:0] a_rx_dat_ridx,
    input  logic [DEPTH*SNP_W-1:0] a_rx_snp_mem,
    input  logic [            B:0] a_rx_snp_widx,
    output logic [            B:0] a_rx_snp_ridx,
    // Link credits: tx credits arrive, rx credits leave.
    input  logic [          2:0][B:0] a_tx_lcrdv_widx,
    output logic [          2:0][B:0] a_tx_lcrdv_ridx,
    output logic [          2:0][B:0] a_rx_lcrdv_widx,
    input  logic [          2:0][B:0] a_rx_lcrdv_ridx,
    output logic [          2:0] a_tx_flitpend,
    input  logic [          2:0] a_rx_flitpend,
    output logic             a_tx_linkactivereq,
    input  logic             a_tx_linkactiveack,
    input  logic             a_rx_linkactivereq,
    output logic             a_rx_linkactiveack,
    output logic             a_txsactive,
    input  logic             a_rxsactive,
    output logic             a_syscoreq,
    input  logic             a_syscoack
);
  // ---- tx: shadow buffer, then async queue source ---------------------
  `define CHI_TX(ch, W)                                                    \
    logic ch``_sb_valid, ch``_sb_ready;                                    \
    logic [W-1:0] ch``_sb_bits;                                            \
    shadow_buffer #(.WIDTH(W)) shadowBuffer_``ch``_flit (                   \
        .clock(clock), .reset(reset),                                      \
        .enq_valid(tx_``ch``_flitv), .enq_ready(), .enq_bits(tx_``ch``_flit), \
        .deq_valid(ch``_sb_valid), .deq_ready(ch``_sb_ready),               \
        .deq_bits(ch``_sb_bits));                                          \
    async_queue_source #(.WIDTH(W), .DEPTH(DEPTH), .SYNC(SYNC))             \
        asyncQSource_``ch``_flit (                                         \
        .clock(clock), .reset(reset),                                      \
        .enq_valid(ch``_sb_valid), .enq_ready(ch``_sb_ready),               \
        .enq_bits(ch``_sb_bits), .async_mem(a_tx_``ch``_mem),               \
        .async_ridx(a_tx_``ch``_ridx), .async_widx(a_tx_``ch``_widx));
  `CHI_TX(req, REQ_W)
  `CHI_TX(rsp, RSP_W)
  `CHI_TX(dat, DAT_W)
  `undef CHI_TX

  // ---- rx: async queue sink, always ready -----------------------------
  `define CHI_RX(ch, W)                                                    \
    logic ch``_valid;                                                      \
    async_queue_sink #(.WIDTH(W), .DEPTH(DEPTH), .SYNC(SYNC))               \
        asyncQSink_``ch``_flit (                                           \
        .clock(clock), .reset(reset),                                      \
        .deq_valid(ch``_valid), .deq_ready(1'b1), .deq_bits(rx_``ch``_flit), \
        .async_mem(a_rx_``ch``_mem), .async_ridx(a_rx_``ch``_ridx),           \
        .async_widx(a_rx_``ch``_widx));                                    \
    assign rx_``ch``_flitv = ch``_valid;
  `CHI_RX(rsp, RSP_W)
  `CHI_RX(dat, DAT_W)
  `CHI_RX(snp, SNP_W)
  `undef CHI_RX

  // ---- link credits, as pulse queues ----------------------------------
  logic [2:0] tx_lcrdv, rx_lcrdv;
  assign rx_lcrdv = {rx_snp_lcrdv, rx_dat_lcrdv, rx_rsp_lcrdv};
  for (genvar c = 0; c < 3; c++) begin : lcrdv
    async_queue_sink #(.WIDTH(1), .DEPTH(DEPTH), .SYNC(SYNC), .PULSE(1'b1))
        asyncQBitSink_tx_lcrdv (
        .clock(clock), .reset(reset),
        .deq_valid(tx_lcrdv[c]), .deq_ready(1'b1), .deq_bits(),
        .async_mem('0), .async_ridx(a_tx_lcrdv_ridx[c]),
        .async_widx(a_tx_lcrdv_widx[c]));
    async_queue_source #(.WIDTH(1), .DEPTH(DEPTH), .SYNC(SYNC), .PULSE(1'b1))
        asyncQBitSource_rx_lcrdv (
        .clock(clock), .reset(reset),
        .enq_valid(rx_lcrdv[c]), .enq_ready(), .enq_bits(1'b0),
        .async_mem(), .async_ridx(a_rx_lcrdv_ridx[c]),
        .async_widx(a_rx_lcrdv_widx[c]));
  end
  assign {tx_dat_lcrdv, tx_rsp_lcrdv, tx_req_lcrdv} = tx_lcrdv;

  // ---- link handshakes ------------------------------------------------
  // Out: straight through (AsyncBridge.scala:187-193).
  assign a_txsactive        = txsactive;
  assign a_rx_linkactiveack = rx_linkactiveack;
  assign a_tx_linkactivereq = tx_linkactivereq;
  assign a_syscoreq         = syscoreq;
  assign a_tx_flitpend      = tx_flitpend;

  // In: synchronised (AsyncBridge.scala:206-213). The NoC may only bring
  // the receive link up once this half has been out of reset a while.
  logic [6:0] in_sync;
  sync_shift_reg #(.WIDTH(7), .SYNC(SYNC)) sync_link (
      .clock(clock), .reset(reset),
      .d({a_rx_flitpend, a_syscoack, a_rx_linkactivereq, a_tx_linkactiveack,
          a_rxsactive}),
      .q(in_sync));
  assign rxsactive        = in_sync[0];
  assign tx_linkactiveack = in_sync[1];
  assign rx_linkactivereq = in_sync[2] && reset_finish;
  assign syscoack         = in_sync[3];
  assign rx_flitpend      = in_sync[6:4];

  // resetFinish: 100 cycles after reset (AsyncBridge.scala:215-221).
  localparam int RESET_FINISH_MAX = 100;
  logic [7:0] reset_finish_counter;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) reset_finish_counter <= '0;
    else if (reset_finish_counter < 8'(RESET_FINISH_MAX))
      reset_finish_counter <= reset_finish_counter + 1'b1;
  end
  assign reset_finish = reset_finish_counter >= 8'(RESET_FINISH_MAX);
endmodule
