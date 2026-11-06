// The branch predictor's top: the stage-2 prediction of a fetch block,
// and from it which pc stage 0 reads next.
//
// XiangShan: xiangshan/frontend/bpu/Bpu.scala. A slot of the main BTB's
// result is taken if it is a jump, or a conditional branch the TAGE says
// is taken (s2_takenMask, Bpu.scala:356-360); the block's branch is the
// first taken slot (s2_firstTakenBranchOH, :362), its target the block's
// target, and with no taken slot the block falls through (:367). Stage 2
// overrides stage 1 when the direction or the position differs from the
// fast stage-1 prediction (s2_override, :374-380); an override flushes
// stage 1, and stage 0 reads from the stage-2 target (s0_startPc,
// :533-541). Stage 0 is the next read of the TAGE and of the main BTB,
// at banks and sets hashed from that pc, so the stage-2 response of both
// decides, within the same cycle, which of their banks are read next.
module bpu_ctrl #(
    parameter int SLOTS = 8
) (
    input  logic        clock,
    input  logic        enable,  // s1_ready && sramResetDone, registered
    // a redirect from the back end, registered at the boundary
    input  logic        redirect_valid,
    input  logic [31:0] redirect_pc,
    // the stage-1 prediction, from the fast predictor (uBTB)
    input  logic        s1_valid,
    input  logic [31:0] s1_target,
    // what stage 1 predicted for the block now in stage 2
    input  logic        s2_valid,
    input  logic        s2_s1_taken,
    input  logic [ 3:0] s2_s1_position,
    input  logic [31:0] s2_pc,
    // the stage-2 results: the TAGE's direction, the main BTB's slots
    input  logic        tage_taken,
    input  logic        slot_hit     [SLOTS],
    input  logic        slot_cond    [SLOTS],
    input  logic        slot_jump    [SLOTS],
    input  logic [ 3:0] slot_position[SLOTS],
    input  logic [31:0] slot_target  [SLOTS],
    input  logic        slot_before  [SLOTS][SLOTS],
    // the prediction, and stage 0
    output logic        s2_taken,
    output logic        s0_fire,
    output logic [31:0] s0_pc,
    output logic        s1_flush
);
  // ---- the stage-2 prediction ---------------------------------------------
  // The TAGE here predicts one direction per block; XiangShan's predicts
  // one per slot (fastTakenVec), which is wider and no deeper.
  logic taken[SLOTS], first[SLOTS];
  always_comb begin
    for (int i = 0; i < SLOTS; i++)
      taken[i] = slot_hit[i] && (slot_jump[i] || (slot_cond[i] && tage_taken));
    // CompareMatrix.getLeastElementOH
    for (int i = 0; i < SLOTS; i++) begin
      first[i] = taken[i];
      for (int j = 0; j < SLOTS; j++)
        if (j != i) first[i] = first[i] && (!taken[j] || slot_before[i][j]);
    end
  end

  logic [ 3:0] s2_position;
  logic [31:0] s2_target;
  always_comb begin
    s2_taken    = 1'b0;
    s2_position = '0;
    s2_target   = s2_pc + 32'd64;  // fall through: the next fetch block
    for (int i = 0; i < SLOTS; i++) begin
      s2_taken = s2_taken || taken[i];
      if (first[i]) begin  // one-hot: Mux1H
        s2_position = slot_position[i];
        s2_target   = slot_target[i];
      end
    end
  end

  // ---- stage 0 -----------------------------------------------------------------
  logic s2_override;
  assign s2_override = s2_valid && (s2_taken != s2_s1_taken ||
                                    (s2_taken && s2_position != s2_s1_position));
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
  // always ready, stage 1 is always ready
  assign s0_fire = enable;
endmodule
