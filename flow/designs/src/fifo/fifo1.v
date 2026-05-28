// (* keep_hierarchy *) preserves the fifo1 instance boundary (fifo_in,
// fifo_out in mock_cpu) through Yosys flattening so the SDC can
// reference fifo_in/<pin> and fifo_out/<pin> directly. SYNTH_KEEP_MODULES
// doesn't work here because hierarchy elaboration specializes fifo1 into
// $paramod$<hash>\fifo1 variants before the flow's SYNTH_KEEP_MODULES
// loop runs. An RTL attribute rides through elaboration onto each
// specialized clone.
(* keep_hierarchy *)
module fifo1 #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    output [DSIZE-1:0] rdata,
    output wfull,
    output rempty,
    input [DSIZE-1:0] wdata,
    input winc,
    wclk,
    wrst_n,
    input rinc,
    rclk,
    rrst_n
);
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;
  sync_r2w #(ASIZE) sync_r2w (
      .wq2_rptr(wq2_rptr),
      .rptr(rptr),
      .wclk(wclk),
      .wrst_n(wrst_n)
  );
  sync_w2r #(ASIZE) sync_w2r (
      .rq2_wptr(rq2_wptr),
      .wptr(wptr),
      .rclk(rclk),
      .rrst_n(rrst_n)
  );
  fifomem #(DSIZE, ASIZE) fifomem (
      .rdata (rdata),
      .wdata (wdata),
      .waddr (waddr),
      .raddr (raddr),
      .wclken(winc),
      .wfull (wfull),
      .wclk  (wclk)
  );
  rptr_empty #(ASIZE) rptr_empty (
      .rempty(rempty),
      .raddr(raddr),
      .rptr(rptr),
      .rq2_wptr(rq2_wptr),
      .rinc(rinc),
      .rclk(rclk),
      .rrst_n(rrst_n)
  );
  wptr_full #(ASIZE) wptr_full (
      .wfull(wfull),
      .waddr(waddr),
      .wptr(wptr),
      .wq2_rptr(wq2_rptr),
      .winc(winc),
      .wclk(wclk),
      .wrst_n(wrst_n)
  );
endmodule
