// tage_update: gather, decide, scatter across TAGE's tables in one cycle.
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
// it cannot drain. That loop leaves the TAGE for the predictor's stage
// control and comes back, as it does in XiangShan.
//
// In XiangShan the training decision also reaches the tables through
// the Ftq, which hands a just-predicted branch's metadata straight back;
// here that round trip is one wire.
module tage_update #(
    parameter int TABLES = 4,
    parameter int BANKS  = 2,
    parameter int WAYS   = 2,
    localparam int BW = BANKS > 1 ? $clog2(BANKS) : 1,
    localparam int WW = WAYS > 1 ? $clog2(WAYS) : 1,
    localparam int TW = TABLES > 1 ? $clog2(TABLES) : 1
) (
    input  logic        clock,
    input  logic        fetch_enable,    // stage 1 ready, SRAMs out of reset
    input  logic        redirect_valid,  // a redirect from the back end
    input  logic [31:0] redirect_pc,
    input  logic        ubtb_taken,      // the fast stage-1 prediction
    input  logic [31:0] ubtb_target,     // and its target
    input  logic [31:0] mbtb_target,     // the main BTB's target, at stage 2
    input  logic        train_taken,     // the resolved direction
    output logic        pred_taken,
    output logic [TW-1:0] pred_provider
);
  // ---- the boundary, registered ----------------------------------------
  logic en_q, redirect_valid_q, ubtb_taken_q, train_taken_q;
  logic [31:0] redirect_pc_q, ubtb_target_q, mbtb_target_q;
  always_ff @(posedge clock) begin
    en_q             <= fetch_enable;
    ubtb_target_q    <= ubtb_target;
    mbtb_target_q    <= mbtb_target;
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
  logic [31:0] s1_pc, s2_pc;

  bpu_ctrl ctrl (
      .clock         (clock),
      .enable        (en_q),
      .redirect_valid(redirect_valid_q),
      .redirect_pc   (redirect_pc_q),
      .s1_valid      (s1_valid),
      .s1_target     (ubtb_target_q),
      .s2_valid      (s2_valid),
      .s2_s1_taken   (s2_s1_taken),
      .s2_taken      (s2_pred_taken),
      .s2_target     (mbtb_target_q),
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
    pred_taken    <= s2_pred_taken;
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
