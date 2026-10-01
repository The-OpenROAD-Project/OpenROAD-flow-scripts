// The L2 directory of one slice: read the tag and meta arrays in s1,
// register what they return at s3, and in s3 decide hit, way and the
// chosen way's meta, combinationally, for MainPipe to use the same cycle.
// coupledL2/Directory.scala, of XSCache at 300515bc.
//
// What is left out, because it is not on the path: the replacer's own
// SRAM (its choice arrives as repl_way_oh_s3, as io.replResp does), the
// refill-retry free-way mask (:274-300), CMO by-way requests and the
// tag ECC check, which feeds only error_s3 (:259-268, :321), never the hit.
module l2_directory #(
    parameter int SETS = 1024,
    parameter int WAYS = 8,
    parameter int TAGBITS = 32,
    parameter int METABITS = 16
) (
    input  logic                        clock,
    input  logic                        reset,
    // s1: a read, at most every other cycle (RequestArb's MCP2 stall)
    input  logic                        read_fire,
    input  logic [$clog2(SETS)-1:0]     read_set,
    input  logic [TAGBITS-1:0]          read_tag,
    // tag and meta writes from MainPipe and the MSHRs, one way at a time
    input  logic                        tag_wen,
    input  logic [$clog2(SETS)-1:0]     tag_wset,
    input  logic [WAYS-1:0]             tag_wway_oh,
    input  logic [TAGBITS-1:0]          tag_wtag,
    input  logic                        meta_wen,
    input  logic [$clog2(SETS)-1:0]     meta_wset,
    input  logic [WAYS-1:0]             meta_wway_oh,
    input  logic [METABITS-1:0]         meta_wmeta,
    // s3
    input  logic [WAYS-1:0]             repl_way_oh_s3,
    output logic                        resp_valid_s3,
    output logic                        hit_s3,
    output logic [$clog2(WAYS)-1:0]     way_s3,
    output logic [METABITS-1:0]         meta_s3,
    output logic [METABITS-1:0]         meta_on_hit_s3
);
  localparam int ENCTAG = TAGBITS + 7;  // SECDED(32): 39 bits
  localparam int HALF = WAYS / 2;  // waySplit = 2 (:173)
  localparam logic [1:0] INVALID = 0;  // coupledL2/MetaData.scala

  // SECDED(39,32) as XiangShan's dataCode encodes a tag for writing
  // (:221-226): a Hamming code over positions 1..38 and an overall
  // parity bit. Not on the read path: the compare uses the tag bits
  // as stored (:254-258, :270).
  function automatic logic [ENCTAG-1:0] secded(input logic [TAGBITS-1:0] d);
    logic [37:0] h;
    logic [ 5:0] c;
    int          k;
    h = '0;
    k = 0;
    for (int p = 1; p <= 38; p++)
      if ((p & (p - 1)) != 0) begin
        h[p-1] = d[k];
        k++;
      end
    c = '0;
    for (int p = 1; p <= 38; p++) for (int b = 0; b < 6; b++) if (p[b]) c[b] ^= h[p-1];
    return {^{c, d}, c, d};
  endfunction

  // s1: one read of both arrays, writes when there is no read (single port)
  logic [ENCTAG*HALF-1:0] tag_rdata[2];
  logic [ENCTAG*HALF-1:0] tag_wdata;
  for (genvar w = 0; w < HALF; w++) begin : g_enc
    assign tag_wdata[w*ENCTAG+:ENCTAG] = secded(tag_wtag);
  end
  for (genvar s = 0; s < 2; s++) begin : g_tag
    l2_tag_sram u_sram (
        .RW0_clk  (clock),
        .RW0_en   (read_fire || tag_wen),
        .RW0_wmode(!read_fire),
        .RW0_addr (read_fire ? read_set : tag_wset),
        .RW0_wmask(tag_wway_oh[s*HALF+:HALF]),
        .RW0_wdata(tag_wdata),
        .RW0_rdata(tag_rdata[s])
    );
  end

  logic [METABITS*WAYS-1:0] meta_rdata;
  l2_meta_sram u_meta (
      .RW0_clk  (clock),
      .RW0_en   (read_fire || meta_wen),
      .RW0_wmode(!read_fire),
      .RW0_addr (read_fire ? read_set : meta_wset),
      .RW0_wmask(meta_wway_oh),
      .RW0_wdata({WAYS{meta_wmeta}}),
      .RW0_rdata(meta_rdata)
  );

  // s2: the arrays answer; s3 latches them (:215-218, :252-253)
  logic                     valid_s2;
  logic [TAGBITS-1:0]       tag_s2;
  logic                     valid_s3;
  logic [TAGBITS-1:0]       tag_s3;
  logic [ENCTAG*WAYS-1:0]   tag_read_s3;
  logic [METABITS*WAYS-1:0] meta_all_s3;
  always_ff @(posedge clock) begin
    valid_s2 <= !reset && read_fire;
    valid_s3 <= !reset && valid_s2;
    if (read_fire) tag_s2 <= read_tag;
    if (valid_s2) begin
      tag_s3      <= tag_s2;
      tag_read_s3 <= {tag_rdata[1], tag_rdata[0]};
      meta_all_s3 <= meta_rdata;
    end
  end

  // s3: hit and way, "in stage 3, Cuz SRAM latency is high under high
  // frequency" (:209-213, :270-272, :295-312)
  logic [WAYS-1:0] hit_vec, inv_vec, inv_oh, chosen_oh, way_oh;
  for (genvar w = 0; w < WAYS; w++) begin : g_way
    logic [METABITS-1:0] m;
    assign m          = meta_all_s3[w*METABITS+:METABITS];
    assign inv_vec[w] = m[1:0] == INVALID;
    assign hit_vec[w] = tag_read_s3[w*ENCTAG+:TAGBITS] == tag_s3 && !inv_vec[w];
  end
  assign inv_oh    = inv_vec & -inv_vec;  // invalid_way_sel: the first invalid way
  assign chosen_oh = |inv_vec ? inv_oh : repl_way_oh_s3;
  assign hit_s3    = |hit_vec;
  assign way_oh    = hit_s3 ? hit_vec : chosen_oh;

  always_comb begin
    way_s3         = '0;
    meta_s3        = '0;
    meta_on_hit_s3 = '0;
    for (int w = 0; w < WAYS; w++) begin  // OHToUInt and Mux1H
      if (way_oh[w]) way_s3 |= w[$clog2(WAYS)-1:0];
      if (way_oh[w]) meta_s3 |= meta_all_s3[w*METABITS+:METABITS];
      if (hit_vec[w]) meta_on_hit_s3 |= meta_all_s3[w*METABITS+:METABITS];
    end
  end
  assign resp_valid_s3 = valid_s3;
endmodule
