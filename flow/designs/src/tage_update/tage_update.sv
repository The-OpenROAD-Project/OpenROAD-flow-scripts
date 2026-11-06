// tage_update: a branch predictor's stage-2 decision, between the TAGE's
// tables and the main BTB, and back to the tables in the same cycle.
// README.md (beside config.mk) tells the story; this file is the logic.
//
// XiangShan's TAGE (xiangshan/frontend/bpu/tage/Tage.scala at aa6b520):
//
//   gather   every table's stage-2 read response is registered beside its
//            SRAMs (s2_readResp, Tage.scala:117);
//   decide   the provider is the longest-history table that hits, the
//            alternate the next one (Tage.scala:147-173); whether training
//            must re-read the tables follows from it (t0_needRead,
//            Tage.scala:228-236);
//   scatter  the re-read is a read request to one bank of every table
//            (Tage.scala:252), and a bank being read cannot drain its
//            write buffer this cycle (TageTable.scala:192, 199).
//
// The same response also decides the next read (bpu_ctrl.sv): when the
// TAGE's direction overrides the stage-1 prediction, stage 0 fetches
// from the stage-2 target, and the bank that pc hashes to is read, so
// it cannot drain. The block's direction is not the TAGE's alone: it is
// the first taken slot of the main BTB's result (mbtb.sv), its own SRAMs
// read from the same pc. The logic that decides sits between the two
// sets of SRAMs, and the loop goes out to it and back, as in XiangShan.
//
// In XiangShan the training decision also reaches the tables through
// the Ftq, which hands a just-predicted branch's metadata straight back;
// here that round trip is one wire.
module tage_update #(
    parameter int TABLES = 4,
    parameter int BANKS  = 2,
    parameter int WAYS   = 2,
    parameter int MBTB_BANKS = 4,  // main BTB internal banks per half
    parameter int MBTB_WAYS  = 4,
    localparam int SLOTS = 2 * MBTB_WAYS,
    localparam int MBW = MBTB_BANKS > 1 ? $clog2(MBTB_BANKS) : 1,
    localparam int MWW = MBTB_WAYS > 1 ? $clog2(MBTB_WAYS) : 1,
    localparam int BW = BANKS > 1 ? $clog2(BANKS) : 1,
    localparam int WW = WAYS > 1 ? $clog2(WAYS) : 1,
    localparam int TW = TABLES > 1 ? $clog2(TABLES) : 1
) (
    input  logic        clock,
    input  logic        fetch_enable,    // stage 1 ready, SRAMs out of reset
    input  logic        redirect_valid,  // a redirect from the back end
    input  logic [31:0] redirect_pc,
    input  logic        ubtb_taken,      // the fast stage-1 prediction
    input  logic [ 3:0] ubtb_position,   // its branch's slot position
    input  logic [31:0] ubtb_target,     // and its target
    // a main BTB training write
    input  logic        mbtb_wr_valid,
    input  logic        mbtb_wr_align,
    input  logic [MBW-1:0] mbtb_wr_bank,
    input  logic [MWW-1:0] mbtb_wr_way,
    input  logic [ 7:0] mbtb_wr_set,
    input  logic [45:0] mbtb_wr_entry,
    input  logic        train_taken,     // the resolved direction
    output logic        pred_taken,
    output logic [TW-1:0] pred_provider
);
  // ---- the boundary, registered ----------------------------------------
  logic en_q, redirect_valid_q, ubtb_taken_q, train_taken_q;
  logic [ 3:0] ubtb_position_q;
  logic [31:0] redirect_pc_q, ubtb_target_q;
  logic mbtb_wr_valid_q, mbtb_wr_align_q;
  logic [MBW-1:0] mbtb_wr_bank_q;
  logic [MWW-1:0] mbtb_wr_way_q;
  logic [ 7:0] mbtb_wr_set_q;
  logic [45:0] mbtb_wr_entry_q;
  always_ff @(posedge clock) begin
    en_q             <= fetch_enable;
    ubtb_target_q    <= ubtb_target;
    ubtb_position_q  <= ubtb_position;
    mbtb_wr_valid_q  <= mbtb_wr_valid;
    mbtb_wr_align_q  <= mbtb_wr_align;
    mbtb_wr_bank_q   <= mbtb_wr_bank;
    mbtb_wr_way_q    <= mbtb_wr_way;
    mbtb_wr_set_q    <= mbtb_wr_set;
    mbtb_wr_entry_q  <= mbtb_wr_entry;
    redirect_valid_q <= redirect_valid;
    redirect_pc_q    <= redirect_pc;
    ubtb_taken_q     <= ubtb_taken;
    train_taken_q    <= train_taken;
  end

  // each table hashes the pc its own way (XiangShan folds in a history of
  // a different length per table; a pc rotation keeps the tables apart)
  function automatic logic [8:0] set_of(logic [31:0] pc, int t);
    logic [31:0] r = (pc >> (2 + t)) | (pc << (30 - t));
    return r[8:0] ^ r[20:12];
  endfunction
  function automatic logic [12:0] tag_of(logic [31:0] pc, int t);
    logic [31:0] r = (pc >> (5 + 2 * t)) | (pc << (27 - 2 * t));
    return r[12:0] ^ r[31:19];
  endfunction

  // ---- stage 0, from the stage control -----------------------------------
  logic s0_fire, s1_flush, s2_pred_taken;
  logic [31:0] s0_pc;
  logic s1_valid, s2_valid, s1_taken, s2_taken, s2_s1_taken;
  logic [ 3:0] s2_s1_position;
  logic [31:0] s1_pc, s2_pc;

  // ---- the main BTB --------------------------------------------------------
  logic        slot_hit[SLOTS], slot_cond[SLOTS], slot_jump[SLOTS];
  logic [ 3:0] slot_position[SLOTS];
  logic [31:0] slot_target[SLOTS];
  logic        slot_before[SLOTS][SLOTS];
  mbtb #(
      .BANKS(MBTB_BANKS),
      .WAYS (MBTB_WAYS)
  ) btb (
      .clock      (clock),
      .rd_valid   (s0_fire),
      .rd_pc      (s0_pc),
      .s2_pc      (s2_pc),
      .wr_valid   (mbtb_wr_valid_q),
      .wr_align   (mbtb_wr_align_q),
      .wr_bank    (mbtb_wr_bank_q),
      .wr_way     (mbtb_wr_way_q),
      .wr_set     (mbtb_wr_set_q),
      .wr_entry   (mbtb_wr_entry_q),
      .s2_hit     (slot_hit),
      .s2_cond    (slot_cond),
      .s2_jump    (slot_jump),
      .s2_position(slot_position),
      .s2_target  (slot_target),
      .s2_before  (slot_before)
  );

  logic s2_block_taken;
  bpu_ctrl #(
      .SLOTS(SLOTS)
  ) ctrl (
      .clock         (clock),
      .enable        (en_q),
      .redirect_valid(redirect_valid_q),
      .redirect_pc   (redirect_pc_q),
      .s1_valid      (s1_valid),
      .s1_target     (ubtb_target_q),
      .s2_valid      (s2_valid),
      .s2_s1_taken   (s2_s1_taken),
      .s2_s1_position(s2_s1_position),
      .s2_pc         (s2_pc),
      .tage_taken    (s2_pred_taken),
      .slot_hit      (slot_hit),
      .slot_cond     (slot_cond),
      .slot_jump     (slot_jump),
      .slot_position (slot_position),
      .slot_target   (slot_target),
      .slot_before   (slot_before),
      .s2_taken      (s2_block_taken),
      .s0_fire       (s0_fire),
      .s0_pc         (s0_pc),
      .s1_flush      (s1_flush)
  );

  logic [BW-1:0] s0_bank;
  assign s0_bank = s0_pc[2+:BW];

  // stages 1 and 2 carry the request alongside the tables' read; an
  // override or a redirect flushes stage 1 (Bpu.scala:248-270)
  always_ff @(posedge clock) begin
    s1_valid <= s0_fire;
    if (s0_fire) s1_pc <= s0_pc;
    s1_taken    <= train_taken_q;
    s2_valid    <= s1_valid && !s1_flush;
    s2_pc       <= s1_pc;
    s2_s1_taken <= ubtb_taken_q;
    s2_s1_position <= ubtb_position_q;
    s2_taken    <= s1_taken;
  end

  // ---- the tables ------------------------------------------------------
  logic [16:0] s2_entry[TABLES][WAYS];
  logic [ 1:0] s2_useful[TABLES][WAYS];
  logic [ 1:0] t1_useful;
  logic rerd_valid;
  logic [BW-1:0] rerd_bank;
  logic t1_valid;
  logic [TW-1:0] t1_table;
  logic [WW-1:0] t1_way;
  logic [31:0] t1_pc;
  logic [16:0] t1_entry;
  logic [BW-1:0] t1_bank;

  for (genvar t = 0; t < TABLES; t++) begin : g_table
    tage_table #(
        .BANKS(BANKS),
        .WAYS (WAYS)
    ) table_i (
        .clock     (clock),
        .rd_valid  (s0_fire),
        .rd_bank   (s0_bank),
        .rd_set    (set_of(s0_pc, t)),
        .rerd_valid(rerd_valid),
        .rerd_bank (rerd_bank),
        .rerd_set  (set_of(s2_pc, t)),
        .wr_valid  (t1_valid && t1_table == TW'(t)),
        .wr_bank   (t1_bank),
        .wr_way    (t1_way),
        .wr_set    (set_of(t1_pc, t)),
        .wr_entry  (t1_entry),
        .wr_useful (t1_useful),
        .s2_entry  (s2_entry[t]),
        .s2_useful (s2_useful[t])
    );
  end

  // ---- gather: which table and way hit ---------------------------------
  // an entry is {valid, tag[12:0], taken counter[2:0]}
  logic [TABLES-1:0] hit;
  logic [WW-1:0] hit_way[TABLES];
  always_comb begin
    for (int t = 0; t < TABLES; t++) begin
      hit[t]     = 1'b0;
      hit_way[t] = '0;
      for (int w = WAYS - 1; w >= 0; w--) begin
        if (s2_entry[t][w][16] && s2_entry[t][w][15:3] == tag_of(s2_pc, t)) begin
          hit[t]     = 1'b1;
          hit_way[t] = WW'(w);
        end
      end
    end
  end

  // ---- decide: provider and alternate ----------------------------------
  logic has_provider, has_alt;
  logic [TW-1:0] provider, alt;
  always_comb begin
    has_provider = 1'b0;
    has_alt      = 1'b0;
    provider     = '0;
    alt          = '0;
    for (int t = 0; t < TABLES; t++) begin  // the last hit wins: longest history
      if (hit[t]) begin
        has_alt      = has_provider;
        alt          = provider;
        has_provider = 1'b1;
        provider     = TW'(t);
      end
    end
  end

  logic [2:0] provider_ctr, alt_ctr;
  logic [1:0] provider_useful;
  assign provider_ctr    = s2_entry[provider][hit_way[provider]][2:0];
  assign alt_ctr         = s2_entry[alt][hit_way[alt]][2:0];
  assign provider_useful = s2_useful[provider][hit_way[provider]];

  // a weak provider defers to the alternate, and a provider that is not
  // useful may be replaced: either way training must re-read the tables
  logic provider_weak;
  assign provider_weak = provider_ctr == 3'd3 || provider_ctr == 3'd4;

  // ---- scatter: the update re-read, to one bank of every table ---------
  assign rerd_valid = s2_valid && has_provider &&
                      ((has_alt && provider_weak) || provider_useful == 2'd0);
  assign rerd_bank  = s2_pc[2+:BW];

  // ---- the prediction, and the training write it leads to --------------
  logic use_provider;
  assign use_provider  = has_provider && !(provider_weak && has_alt);
  // no table hits: not taken, the base prediction's job in XiangShan
  assign s2_pred_taken = use_provider ? provider_ctr[2] : has_alt && alt_ctr[2];
  always_ff @(posedge clock) begin
    pred_taken    <= s2_block_taken;  // the block's prediction
    pred_provider <= provider;
    t1_valid      <= s2_valid && has_provider;
    t1_table      <= provider;
    t1_way        <= hit_way[provider];
    t1_bank       <= s2_pc[2+:BW];
    t1_pc         <= s2_pc;
    t1_useful     <= (provider_ctr[2] == s2_taken) ?
                     (provider_useful == 2'd3 ? 2'd3 : provider_useful + 2'd1) : provider_useful;
    t1_entry      <= {1'b1, tag_of(s2_pc, int'(provider)),
                      s2_taken ? (provider_ctr == 3'd7 ? 3'd7 : provider_ctr + 3'd1)
                               : (provider_ctr == 3'd0 ? 3'd0 : provider_ctr - 3'd1)};
  end
endmodule
