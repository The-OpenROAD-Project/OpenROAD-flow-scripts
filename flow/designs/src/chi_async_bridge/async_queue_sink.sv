// The reading half of an asynchronous queue: rocket-chip's AsyncQueueSink
// (util/AsyncQueue.scala:148-179 at a2df1a4), safe = false, narrow = false.
//
// The source's write pointer arrives through a SYNC-deep synchroniser
// (widx_gray). Once it says an entry is there, the entry is read with a
// mux over all DEPTH entries of the source's memory, straight into
// deq_bits_reg. That mux is the data crossing: it starts at flops on the
// source's clock and ends at a flop on this one. Rocket-chip's comment
// states the contract: "the mux is safe because timing analysis ensures
// ridx has reached the register". constraint.sdc is that timing analysis.
module async_queue_sink #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16,
    parameter int SYNC  = 3,
    parameter bit PULSE = 1'b0,
    localparam int BITS = $clog2(DEPTH)
) (
    input  logic                   clock,
    input  logic                   reset,
    output logic                   deq_valid,
    input  logic                   deq_ready,
    output logic [      WIDTH-1:0] deq_bits,
    input  logic [DEPTH*WIDTH-1:0] async_mem,
    output logic [         BITS:0] async_ridx,
    input  logic [         BITS:0] async_widx
);
  // AsyncQueueParams requires a power-of-two depth (util/AsyncQueue.scala:19);
  // the Gray pointers and the read index assume it.
  if (DEPTH < 2 || (DEPTH & (DEPTH - 1)) != 0) begin : depth_check
    $error("async_queue_sink: DEPTH must be a power of 2 and at least 2");
  end

  logic fire;
  assign fire = deq_valid && deq_ready;

  logic [BITS:0] ridx_bin, ridx_inc, ridx;
  assign ridx_inc = ridx_bin + (BITS + 1)'(fire);
  assign ridx = ridx_inc ^ (ridx_inc >> 1);
  always_ff @(posedge clock or posedge reset) begin
    if (reset) ridx_bin <= '0;
    else ridx_bin <= ridx_inc;
  end

  logic [BITS:0] widx;
  sync_shift_reg #(
      .WIDTH(BITS + 1),
      .SYNC (SYNC)
  ) widx_gray (
      .clock(clock),
      .reset(reset),
      .d    (async_widx),
      .q    (widx)
  );

  logic valid;
  assign valid = ridx != widx;

  logic valid_reg;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) valid_reg <= 1'b0;
    else valid_reg <= valid;
  end
  assign deq_valid = valid_reg;

  logic [BITS:0] ridx_gray;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) ridx_gray <= '0;
    else ridx_gray <= ridx;
  end
  assign async_ridx = ridx_gray;

  if (PULSE) begin : no_mem
    assign deq_bits = '0;
  end else begin : mem_
    logic [BITS-1:0] index;
    if (BITS == 1) begin : one
      assign index = ridx[0] ^ ridx[1];
    end else begin : many
      assign index = ridx[BITS-1:0] ^ {ridx[BITS], {(BITS - 1) {1'b0}}};
    end
    // ClockCrossingReg (util/SynchronizerReg.scala): not reset, loads
    // only when the entry it selects is valid.
    logic [WIDTH-1:0] deq_bits_reg;
    always_ff @(posedge clock) begin
      if (valid) deq_bits_reg <= async_mem[index*WIDTH+:WIDTH];
    end
    assign deq_bits = deq_bits_reg;
  end
endmodule
