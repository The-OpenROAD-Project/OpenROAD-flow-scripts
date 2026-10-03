// A reset synchroniser: asserts asynchronously, releases SYNC clocks
// later on this domain's clock. XiangShan's ResetGen
// (utility/ResetGen.scala at eb8e12b), without its DFT muxes.
//
// XSTileWrap gives the bridge's tile half a ResetGen of noc_reset on the
// core clock (XSTileWrap.scala:112) and XSNoCTop gives the NoC half one
// on the NoC clock (XSNoCTop.scala:84), so each half leaves reset on its
// own clock.
module reset_gen #(
    parameter int SYNC = 3
) (
    input  logic clock,
    input  logic reset,
    output logic o_reset
);
  // A reset synchroniser has at least two flops.
  if (SYNC < 2) begin : sync_check
    $error("reset_gen: SYNC must be at least 2");
  end

  logic [SYNC-1:0] pipe_reset;
  always_ff @(posedge clock or posedge reset) begin
    if (reset) pipe_reset <= {SYNC{1'b1}};
    else pipe_reset <= {pipe_reset[SYNC-2:0], 1'b0};
  end
  assign o_reset = pipe_reset[SYNC-1];
endmodule
