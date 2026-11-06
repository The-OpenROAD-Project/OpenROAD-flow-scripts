// The main BTB: which slots of a fetch block hold branches, of what
// kind, at which position, with which target. Read at stage 0 from the
// same pc as the TAGE; its stage-2 result is what the TAGE's directions
// are combined with to decide the block's prediction (bpu_ctrl.sv).
//
// XiangShan: xiangshan/frontend/bpu/mbtb/MainBtb.scala,
// MainBtbAlignBank.scala and MainBtbInternalBank.scala. A 64-byte fetch
// block is two 32-byte halves, each read from its own align bank; an
// align bank has internal banks, each a set of one-way SRAMs, and one
// internal bank is read per access. Every way of a read set is a slot of
// the result, so a fetch block has ALIGN * WAYS slots.
//
// A slot's tag is checked and its target assembled at stage 2; the
// order of the slots' positions is compared at stage 1 and registered
// (s2_compareMatrix, Bpu.scala:347), as in XiangShan. The entry's target
// carry, which corrects the upper target bits, is left out: it is
// arithmetic on the target and not on the decision.
module mbtb #(
    parameter int BANKS = 4,  // internal banks per align bank
    parameter int WAYS  = 4,
    localparam int ALIGN = 2,
    localparam int SLOTS = ALIGN * WAYS,
    localparam int BW = BANKS > 1 ? $clog2(BANKS) : 1,
    localparam int WW = WAYS > 1 ? $clog2(WAYS) : 1
) (
    input  logic        clock,
    // stage 0
    input  logic        rd_valid,
    input  logic [31:0] rd_pc,
    // the stage-2 pc, for the tag check and the target's upper bits
    input  logic [31:0] s2_pc,
    // a training write, registered upstream
    input  logic        wr_valid,
    input  logic        wr_align,
    input  logic [BW-1:0] wr_bank,
    input  logic [WW-1:0] wr_way,
    input  logic [ 7:0] wr_set,
    input  logic [45:0] wr_entry,
    // stage 2: one result per slot
    output logic        s2_hit     [SLOTS],
    output logic        s2_cond    [SLOTS],
    output logic        s2_jump    [SLOTS],
    output logic [ 3:0] s2_position[SLOTS],
    output logic [31:0] s2_target  [SLOTS],
    output logic        s2_before  [SLOTS][SLOTS]  // slot i before slot j
);
  // ---- stage 0: the set of each half, and the internal bank ------------
  // The block starts in half rd_pc[5]; the other half is the next one.
  logic [7:0] set_of[ALIGN];
  logic [BW-1:0] bank;
  always_comb begin
    for (int a = 0; a < ALIGN; a++)
      set_of[a] = rd_pc[13:6] + 8'(a < 32'(rd_pc[5]));
    bank = rd_pc[2+:BW];
  end

  // ---- the SRAMs ---------------------------------------------------------
  logic [45:0] rdata[ALIGN][BANKS][WAYS];
  for (genvar a = 0; a < ALIGN; a++) begin : g_align
    for (genvar b = 0; b < BANKS; b++) begin : g_bank
      for (genvar w = 0; w < WAYS; w++) begin : g_way
        logic read, write;
        assign read  = rd_valid && bank == BW'(b);
        assign write = wr_valid && wr_align == 1'(a) && wr_bank == BW'(b) && wr_way == WW'(w);
        mbtb_entry_sram sram (
            .RW0_clk  (clock),
            .RW0_en   (read || write),
            .RW0_wmode(!read),
            .RW0_addr (read ? set_of[a] : wr_set),
            .RW0_wdata(wr_entry),
            .RW0_rdata(rdata[a][b][w])
        );
      end
    end
  end

  // ---- stage 1: the read bank's entries, and the order of the slots ------
  logic [BW-1:0] s1_bank;
  always_ff @(posedge clock) s1_bank <= bank;

  logic [45:0] s1_entry[SLOTS];
  always_comb
    for (int a = 0; a < ALIGN; a++)
      for (int w = 0; w < WAYS; w++)
        s1_entry[a*WAYS+w] = rdata[a][s1_bank][w];

  // an entry is {tag[45:30], branch type[29:28], ras action[27:26],
  // position[25:22], target carry[21:20], target[19:0]}; a slot in the
  // second half comes after every slot in the first
  function automatic logic [4:0] order(logic [45:0] e, int slot);
    return {1'(slot >= WAYS), e[25:22]};
  endfunction

  logic [45:0] s2_entry[SLOTS];
  always_ff @(posedge clock) begin
    for (int i = 0; i < SLOTS; i++) begin
      s2_entry[i] <= s1_entry[i];
      for (int j = 0; j < SLOTS; j++)
        s2_before[i][j] <= order(s1_entry[i], i) < order(s1_entry[j], j);
    end
  end

  // ---- stage 2: the slots ------------------------------------------------
  always_comb begin
    for (int i = 0; i < SLOTS; i++) begin
      s2_hit[i]      = s2_entry[i][29:28] != 2'd0 && s2_entry[i][45:30] == s2_pc[29:14];
      s2_cond[i]     = s2_entry[i][29:28] == 2'd1;
      s2_jump[i]     = s2_entry[i][29:28] >= 2'd2;
      s2_position[i] = s2_entry[i][25:22];
      s2_target[i]   = {s2_pc[31:21], s2_entry[i][19:0], 1'b0};
    end
  end
endmodule
