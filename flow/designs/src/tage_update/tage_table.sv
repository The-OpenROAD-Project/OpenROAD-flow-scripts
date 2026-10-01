// One TAGE table: BANKS x WAYS entry SRAMs and as many useful-counter
// SRAMs, the stage-2 read-response registers beside them, and one write
// buffer per bank.
//
// XiangShan: xiangshan/frontend/bpu/tage/TageTable.scala. A table is read
// by prediction (readReq(0)) and re-read by training (readReq(1),
// Tage.scala:252). Training writes go into a per-bank write buffer
// (TageTable.scala:142-150), which drains into its bank only in a cycle
// when that bank is not being read (TageTable.scala:192, 199): the
// SRAMs are single-ported.
//
// That drain is the end of the path this design is about. Whether a
// bank is read this cycle depends on `rerd_*`, the update re-read the
// central decision in tage_update.sv computes from every table's
// stage-2 response.
module tage_table #(
    parameter int BANKS   = 4,
    parameter int WAYS    = 2,
    parameter int WB_SIZE = 4,
    localparam int BW = BANKS > 1 ? $clog2(BANKS) : 1,
    localparam int WW = WAYS > 1 ? $clog2(WAYS) : 1
) (
    input  logic          clock,
    // prediction read, stage 0
    input  logic          rd_valid,
    input  logic [  BW-1:0] rd_bank,
    input  logic [   8:0] rd_set,
    // the update re-read: the scatter, from the central decision
    input  logic          rerd_valid,
    input  logic [  BW-1:0] rerd_bank,
    input  logic [   8:0] rerd_set,
    // a training write, registered upstream
    input  logic          wr_valid,
    input  logic [  BW-1:0] wr_bank,
    input  logic [  WW-1:0] wr_way,
    input  logic [   8:0] wr_set,
    input  logic [  16:0] wr_entry,
    input  logic [   1:0] wr_useful,
    // the gather: this table's stage-2 read response, one entry and one
    // useful counter per way
    output logic [16:0]   s2_entry [WAYS],
    output logic [ 1:0]   s2_useful[WAYS]
);
  // ---- which bank is read this cycle, and from where ----------------
  logic [BANKS-1:0] read_b;
  logic [8:0] read_set[BANKS];
  always_comb begin
    for (int b = 0; b < BANKS; b++) begin
      read_b[b]   = (rd_valid && rd_bank == BW'(b)) || (rerd_valid && rerd_bank == BW'(b));
      read_set[b] = (rerd_valid && rerd_bank == BW'(b)) ? rerd_set : rd_set;
    end
  end

  // ---- per-bank write buffer -----------------------------------------
  // `valid` is the buffer's dirty bit: the entry is still to be written.
  logic         wb_valid[BANKS][WB_SIZE];
  logic [  8:0] wb_set  [BANKS][WB_SIZE];
  logic [WW-1:0] wb_way [BANKS][WB_SIZE];
  logic [ 16:0] wb_entry[BANKS][WB_SIZE];
  logic [  1:0] wb_useful[BANKS][WB_SIZE];

  // the oldest dirty entry of each bank, and whether it drains now
  logic [$clog2(WB_SIZE)-1:0] head[BANKS];
  logic [BANKS-1:0] drain;
  always_comb begin
    for (int b = 0; b < BANKS; b++) begin
      head[b]  = '0;
      drain[b] = 1'b0;
      for (int i = WB_SIZE - 1; i >= 0; i--) begin
        if (wb_valid[b][i]) begin
          head[b]  = i[$clog2(WB_SIZE)-1:0];
          drain[b] = !read_b[b];
        end
      end
    end
  end

  // enqueue into the first free slot; a full buffer overwrites slot 0
  always_ff @(posedge clock) begin
    for (int b = 0; b < BANKS; b++) begin
      if (drain[b]) wb_valid[b][head[b]] <= 1'b0;
      if (wr_valid && wr_bank == BW'(b)) begin
        automatic int slot = 0;
        for (int i = WB_SIZE - 1; i >= 0; i--) if (!wb_valid[b][i]) slot = i;
        wb_valid[b][slot] <= 1'b1;
        wb_set[b][slot]   <= wr_set;
        wb_way[b][slot]   <= wr_way;
        wb_entry[b][slot] <= wr_entry;
        wb_useful[b][slot] <= wr_useful;
      end
    end
  end

  // ---- the SRAMs -------------------------------------------------------
  logic [16:0] rdata[BANKS][WAYS];
  logic [15:0] urdata[BANKS][WAYS];
  for (genvar b = 0; b < BANKS; b++) begin : g_bank
    for (genvar w = 0; w < WAYS; w++) begin : g_way
      logic write;
      assign write = drain[b] && wb_way[b][head[b]] == WW'(w);
      tage_entry_sram sram (
          .RW0_clk  (clock),
          .RW0_en   (read_b[b] || write),
          .RW0_wmode(!read_b[b]),
          .RW0_addr (read_b[b] ? read_set[b] : wb_set[b][head[b]]),
          .RW0_wdata(wb_entry[b][head[b]]),
          .RW0_rdata(rdata[b][w])
      );
      // the useful counters of eight sets share a row; a write here
      // writes its counter into every lane of the row, which keeps the
      // timing structure and not the bit-exact folding
      tage_useful_sram useful (
          .RW0_clk  (clock),
          .RW0_en   (read_b[b] || write),
          .RW0_wmode(!read_b[b]),
          .RW0_addr (read_b[b] ? read_set[b][8:3] : wb_set[b][head[b]][8:3]),
          .RW0_wdata({8{wb_useful[b][head[b]]}}),
          .RW0_rdata(urdata[b][w])
      );
    end
  end

  // ---- stage 1 to stage 2: the response registers ----------------------
  logic [BW-1:0] s1_bank;
  logic [2:0] s1_lane;
  always_ff @(posedge clock) begin
    s1_bank <= rerd_valid ? rerd_bank : rd_bank;
    s1_lane <= rerd_valid ? rerd_set[2:0] : rd_set[2:0];
    for (int w = 0; w < WAYS; w++) begin
      s2_entry[w]  <= rdata[s1_bank][w];
      s2_useful[w] <= urdata[s1_bank][w][2*s1_lane+:2];
    end
  end
endmodule
