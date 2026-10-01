// MSHRCtl's allocation: the lowest idle MSHR takes the request MainPipe
// decided needs one, with the state the hit decided
// (coupledL2/MSHRCtl.scala:97-137, MainPipe.scala:309, 1021-1059, XSCache
// at 300515bc). An MSHR's own state machine is left out: it frees when
// told, and its state is read back through one status port.
module l2_mshr_ctl #(
    parameter int MSHRS = 16,  // mshrsAll
    parameter int TAGBITS = 32
) (
    input  logic                     clock,
    input  logic                     reset,
    input  logic                     alloc_valid,  // mshr_alloc_s3.valid
    input  logic [              5:0] alloc_state,
    input  logic [      TAGBITS-1:0] alloc_tag,
    input  logic [        MSHRS-1:0] free,
    input  logic [$clog2(MSHRS)-1:0] query,
    output logic [      TAGBITS-1:0] status_tag,
    output logic [              5:0] status_state
);
  logic [MSHRS-1:0] valid, idle, sel;
  assign idle = ~valid;
  assign sel  = idle & -idle;  // MSHRSelector: ParallelPriorityMux

  logic [TAGBITS-1:0] tags  [MSHRS];
  logic [        5:0] states[MSHRS];
  always_ff @(posedge clock)
    for (int i = 0; i < MSHRS; i++) begin
      if (reset) valid[i] <= 1'b0;
      else if (sel[i] && alloc_valid) valid[i] <= 1'b1;
      else if (free[i]) valid[i] <= 1'b0;
      if (sel[i] && alloc_valid) begin  // m.io.alloc.valid (:137)
        states[i] <= alloc_state;
        tags[i]   <= alloc_tag;
      end
    end
  always_ff @(posedge clock) begin
    status_tag   <= tags[query];
    status_state <= states[query];
  end
endmodule
