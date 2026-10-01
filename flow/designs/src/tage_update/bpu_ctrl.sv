// The branch predictor's stage control: which pc stage 0 reads next, and
// whether it reads at all.
//
// XiangShan: xiangshan/frontend/bpu/Bpu.scala. Stage 2 overrides stage 1
// when the TAGE's direction disagrees with the fast stage-1 prediction
// (s2_override, Bpu.scala:374-380); an override flushes stage 1, and
// stage 0 then fetches from the stage-2 target (s0_startPc,
// Bpu.scala:533-541). Stage 0 is the TAGE's next read (Tage.scala:79),
// at a bank and set hashed from that pc, so the TAGE's stage-2 response
// decides, within the same cycle, which of its own banks are read next.
module bpu_ctrl (
    input  logic        clock,
    input  logic        enable,  // s1_ready && sramResetDone, registered
    // a redirect from the back end, registered at the boundary
    input  logic        redirect_valid,
    input  logic [31:0] redirect_pc,
    // the stage-1 prediction, from the fast predictor
    input  logic        s1_valid,
    input  logic [31:0] s1_target,  // the fast predictor's (uBTB) target
    // the stage-2 prediction, from the TAGE
    input  logic        s2_valid,
    input  logic        s2_s1_taken,  // what stage 1 predicted for this block
    input  logic        s2_taken,
    input  logic [31:0] s2_target,  // the main BTB's target for this block
    // stage 0
    output logic        s0_fire,
    output logic [31:0] s0_pc,
    output logic        s1_flush
);
  // The targets come from the BTBs, read alongside; computing them is
  // not this design's concern, choosing between them is.
  logic s2_override;
  assign s2_override = s2_valid && (s2_taken != s2_s1_taken);
  assign s1_flush    = redirect_valid || s2_override;

  logic [31:0] s0_pc_q;
  always_ff @(posedge clock) if (s0_fire) s0_pc_q <= s0_pc;

  always_comb begin
    if (redirect_valid) s0_pc = redirect_pc;
    else if (s2_override) s0_pc = s2_target;
    else if (s1_valid) s0_pc = s1_target;
    else s0_pc = s0_pc_q;
  end

  // s0_fire = s1_ready && sramResetDone (Bpu.scala:260); with the Ftq
  // always ready, s1 is always ready
  assign s0_fire = enable;
endmodule
