// SPDX-License-Identifier: Apache-2.0
// Copyright 2016-2017 SiFive, Inc.
// Changed from the original: rewritten as readable SystemVerilog from
// rocket-chip's Chisel. SOURCE.md names the source and its license.
//
// The writing half of an asynchronous queue: rocket-chip's
// AsyncQueueSource (util/AsyncQueue.scala:70-104 at a2df1a4) with
// safe = false and narrow = false, which is how XiangShan's CHI bridge
// configures it (AsyncQueueParams(depth = 16, sync = 3, safe = false),
// system/SoC.scala:127).
//
// What crosses to the reading domain, all of it straight from a flop:
//   mem   DEPTH entries of WIDTH bits, written in this domain, never reset;
//   widx  the write pointer in Gray code (widx_gray).
// What comes back: ridx, the reader's Gray pointer, through a SYNC-deep
// synchroniser (ridx_gray).
//
// PULSE = 1 is rocket-chip's AsyncQueueSource(UInt(0.W)): no data, the
// queue only counts events. The CHI bridge returns link credits this way.
module async_queue_source #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16,
    parameter int SYNC  = 3,
    parameter bit PULSE = 1'b0,
    localparam int BITS = $clog2(DEPTH)
) (
    input  logic                   clock,
    input  logic                   reset,
    input  logic                   enq_valid,
    output logic                   enq_ready,
    input  logic [      WIDTH-1:0] enq_bits,
    output logic [DEPTH*WIDTH-1:0] async_mem,
    input  logic [         BITS:0] async_ridx,
    output logic [         BITS:0] async_widx
);
  // AsyncQueueParams requires a power-of-two depth (util/AsyncQueue.scala:19);
  // the Gray pointers and the full test assume it.
  if (DEPTH < 2 || (DEPTH & (DEPTH - 1)) != 0) begin : depth_check
    $error("async_queue_source: DEPTH must be a power of 2 and at least 2");
  end

  logic fire;
  assign fire = enq_valid && enq_ready;

  // GrayCounter (AsyncQueue.scala:49-56): a binary register, and the Gray
  // code of the value it is about to take.
  logic [BITS:0] widx_bin, widx_inc, widx;
  assign widx_inc = widx_bin + (BITS + 1)'(fire);
  assign widx = widx_inc ^ (widx_inc >> 1);
  always_ff @(posedge clock or posedge reset) begin
    if (reset) widx_bin <= '0;
    else widx_bin <= widx_inc;
  end

  logic [BITS:0] ridx;
  sync_shift_reg #(
      .WIDTH(BITS + 1),
      .SYNC (SYNC)
  ) ridx_gray (
      .clock(clock),
      .reset(reset),
      .d    (async_ridx),
      .q    (ridx)
  );

  // Full when the write pointer is one lap ahead of the read pointer: in
  // Gray code, the top two bits inverted.
  logic ready;
  assign ready = widx != (ridx ^ (BITS + 1)'(DEPTH | (DEPTH >> 1)));

  logic ready_reg;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) ready_reg <= 1'b0;
    else ready_reg <= ready;
  end
  assign enq_ready = ready_reg;

  logic [BITS:0] widx_gray;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) widx_gray <= '0;
    else widx_gray <= widx;
  end
  assign async_widx = widx_gray;

  if (PULSE) begin : no_mem
    assign async_mem = '0;
  end else begin : mem_
    // The entry being written, from the registered Gray pointer.
    logic [BITS-1:0] index;
    if (BITS == 1) begin : one
      assign index = widx_gray[0] ^ widx_gray[1];
    end else begin : many
      assign index = widx_gray[BITS-1:0] ^ {widx_gray[BITS], {(BITS - 1) {1'b0}}};
    end
    // Reg(Vec(depth, gen)): one register per entry, as firtool emits it.
    for (genvar i = 0; i < DEPTH; i++) begin : mem
      logic [WIDTH-1:0] entry;
      always_ff @(posedge clock) begin
        if (fire && index == BITS'(i)) entry <= enq_bits;
      end
      assign async_mem[i*WIDTH+:WIDTH] = entry;
    end
  end
endmodule
