// CustomL1Hint: a hit answered by MainPipe tells the L1 at s3, through an
// arbiter with the s1 hints and a 16-entry queue of flops
// (coupledL2/CustomL1Hint.scala:91-126, XSCache at 300515bc). The queue is
// chisel3.util.Queue as Chisel builds it: enqueue and dequeue pointers and
// maybe_full.
module l2_custom_l1_hint #(
    parameter int SOURCEBITS = 7,
    parameter int ENTRIES = 16  // mshrsAll
) (
    input  logic                  clock,
    input  logic                  reset,
    input  logic                  enq_s3,
    input  logic                  enq_s3_has_data,
    input  logic [SOURCEBITS-1:0] enq_s3_source,
    input  logic                  s1_valid,
    input  logic [SOURCEBITS-1:0] s1_source,
    input  logic                  hint_ready,
    output logic                  hint_valid,
    output logic [SOURCEBITS-1:0] hint_source,
    output logic                  hint_has_data
);
  // the arbiter, s3 first (:124)
  logic enq_valid, enq_data, enq_fire, deq_fire;
  logic [SOURCEBITS-1:0] enq_source;
  assign enq_valid  = enq_s3 || s1_valid;
  assign enq_source = enq_s3 ? enq_s3_source : s1_source;
  assign enq_data   = enq_s3 ? enq_s3_has_data : 1'b0;

  logic [SOURCEBITS:0] q[ENTRIES];
  logic [$clog2(ENTRIES)-1:0] enq_ptr, deq_ptr;
  logic maybe_full, ptr_match, empty, full;
  assign ptr_match = enq_ptr == deq_ptr;
  assign empty     = ptr_match && !maybe_full;
  assign full      = ptr_match && maybe_full;
  assign enq_fire  = enq_valid && !full;
  assign deq_fire  = !empty && hint_ready;
  always_ff @(posedge clock) begin
    if (enq_fire) q[enq_ptr] <= {enq_data, enq_source};
    if (reset) begin
      enq_ptr    <= '0;
      deq_ptr    <= '0;
      maybe_full <= 1'b0;
    end else begin
      if (enq_fire) enq_ptr <= enq_ptr + 1'b1;
      if (deq_fire) deq_ptr <= deq_ptr + 1'b1;
      if (enq_fire != deq_fire) maybe_full <= enq_fire;
    end
  end
  always_ff @(posedge clock) begin
    hint_valid    <= !reset && !empty;
    hint_source   <= q[deq_ptr][SOURCEBITS-1:0];
    hint_has_data <= q[deq_ptr][SOURCEBITS];
  end
endmodule
