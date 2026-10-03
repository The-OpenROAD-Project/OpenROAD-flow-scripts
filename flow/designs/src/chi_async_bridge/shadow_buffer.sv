// The bridge's shadow buffer: a Chisel Queue(entries = 16, flow = true,
// pipe = false) in front of each outgoing CHI flit channel's async queue
// (ToAsyncBundleWithBuf, xscache/chi/AsyncBridge.scala:67-94 at XSCache
// 300515b). It accepts every flit the link layer sends -- CHI's link
// credits guarantee room -- and, being a flow queue, passes a flit
// through in the same cycle when it is empty.
module shadow_buffer #(
    parameter int WIDTH   = 8,
    parameter int ENTRIES = 16,
    localparam int PW = $clog2(ENTRIES)
) (
    input  logic             clock,
    input  logic             reset,
    input  logic             enq_valid,
    output logic             enq_ready,
    input  logic [WIDTH-1:0] enq_bits,
    output logic             deq_valid,
    input  logic             deq_ready,
    output logic [WIDTH-1:0] deq_bits
);
  // The pointers wrap by overflowing PW bits, which is only right for a
  // power-of-two depth; Chisel's Queue wraps explicitly instead.
  if (ENTRIES < 2 || (ENTRIES & (ENTRIES - 1)) != 0) begin : entries_check
    $error("shadow_buffer: ENTRIES must be a power of 2 and at least 2");
  end

  // Chisel's Queue keeps its entries in a Mem with a combinational read,
  // which firtool emits as one register per entry.
  logic [ENTRIES-1:0][WIDTH-1:0] ram;
  logic [PW-1:0] enq_ptr, deq_ptr;
  logic maybe_full;

  logic ptr_match, empty, full;
  assign ptr_match = enq_ptr == deq_ptr;
  assign empty = ptr_match && !maybe_full;
  assign full = ptr_match && maybe_full;

  assign enq_ready = !full;
  assign deq_valid = !empty || enq_valid;
  assign deq_bits = empty ? enq_bits : ram[deq_ptr];

  // In flow, a flit taken while the queue is empty never enters it.
  logic do_enq, do_deq;
  assign do_enq = enq_valid && enq_ready && !(empty && deq_ready);
  assign do_deq = deq_valid && deq_ready && !empty;

  for (genvar i = 0; i < ENTRIES; i++) begin : entry
    always_ff @(posedge clock) begin
      if (do_enq && enq_ptr == PW'(i)) ram[i] <= enq_bits;
    end
  end
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      enq_ptr <= '0;
      deq_ptr <= '0;
      maybe_full <= 1'b0;
    end else begin
      if (do_enq) enq_ptr <= enq_ptr + 1'b1;
      if (do_deq) deq_ptr <= deq_ptr + 1'b1;
      if (do_enq != do_deq) maybe_full <= do_enq;
    end
  end
endmodule
