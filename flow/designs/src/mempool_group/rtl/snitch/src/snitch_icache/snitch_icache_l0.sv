// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

/// A simple single-line cache private to each port.
module snitch_icache_l0 import snitch_icache_pkg::*; #(
    parameter config_t CFG = '0,
    parameter int unsigned L0_ID = 0
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic flush_valid_i,

    input  logic                      enable_prefetching_i,
    output icache_events_t            icache_events_o,

    input  logic [CFG.FETCH_AW-1:0]   in_addr_i,
    input  logic                      in_valid_i,
    output logic [CFG.FETCH_DW-1:0]   in_data_o,
    output logic                      in_ready_o,
    output logic                      in_error_o,

    output logic [CFG.FETCH_AW-1:0]      out_req_addr_o,
    output logic [CFG.ID_WIDTH_REQ-1:0]  out_req_id_o,
    output logic                         out_req_valid_o,
    input  logic                         out_req_ready_i,

    input  logic [CFG.LINE_WIDTH-1:0]    out_rsp_data_i,
    input  logic                         out_rsp_error_i,
    input  logic [CFG.ID_WIDTH_RESP-1:0] out_rsp_id_i,
    input  logic                         out_rsp_valid_i,
    output logic                         out_rsp_ready_o
);

  typedef logic [CFG.FETCH_AW-1:0] addr_t;
  typedef struct packed {
    logic [CFG.L0_TAG_WIDTH-1:0] tag;
    logic                        vld;
  } tag_t;

  logic [CFG.L0_TAG_WIDTH-1:0] addr_tag, addr_tag_prefetch;

  tag_t [CFG.L0_LINE_COUNT-1:0] tag;
  logic [CFG.L0_LINE_COUNT-1:0][CFG.LINE_WIDTH-1:0] data;

  logic [CFG.L0_LINE_COUNT-1:0] hit, hit_early, hit_prefetch;
  logic hit_early_is_onehot;
  logic hit_any;
  logic hit_prefetch_any;
  logic miss;

  logic [CFG.L0_LINE_COUNT-1:0] evict_strb;
  logic [CFG.L0_LINE_COUNT-1:0] flush_strb;
  logic [CFG.L0_LINE_COUNT-1:0] validate_strb;

  typedef struct packed {
    logic vld;
    logic [CFG.FETCH_AW-1:0] addr;
  } prefetch_req_t;

  logic latch_prefetch, last_cycle_was_prefetch_q;
  prefetch_req_t prefetch_req_q, prefetch_req_d, prefetcher_out;

  // Holds the onehot signal for the line being refilled at the moment
  logic [CFG.L0_LINE_COUNT-1:0] pending_line_refill_q;
  logic pending_refill_q, pending_refill_d;

  logic evict_req;
  logic last_cycle_was_miss_q;

  `FF(last_cycle_was_miss_q, miss, '0)
  `FF(last_cycle_was_prefetch_q, latch_prefetch, '0)

  logic evict_because_miss, evict_because_prefetch;

  typedef struct packed {
    logic                    is_prefetch;
    logic [CFG.FETCH_AW-1:0] addr;
  } req_t;

  req_t refill, prefetch;
  logic refill_valid, prefetch_valid;
  logic refill_ready, prefetch_ready;
  req_t out_req;

  assign evict_because_miss = miss & ~last_cycle_was_miss_q;
  assign evict_because_prefetch = latch_prefetch & ~last_cycle_was_prefetch_q;

  assign evict_req = evict_because_miss | evict_because_prefetch;

  assign addr_tag = in_addr_i >> CFG.LINE_ALIGN;

  // ------------
  // Tag Compare
  // ------------
  for (genvar i = 0; i < CFG.L0_LINE_COUNT; i++) begin : gen_cmp_fetch
    assign hit_early[i] = tag[i].vld & (tag[i].tag[CFG.L0_EARLY_TAG_WIDTH-1:0] == addr_tag[CFG.L0_EARLY_TAG_WIDTH-1:0]);
    // The two signals calculate the same.
    if (CFG.L0_TAG_WIDTH == CFG.L0_EARLY_TAG_WIDTH) begin : gen_hit_assign
      assign hit[i] = hit_early[i];
    // Compare the rest of the tag.
    end else begin : gen_hit
      assign hit[i] = hit_early[i] & (tag[i].tag[CFG.L0_TAG_WIDTH-1:CFG.L0_EARLY_TAG_WIDTH] == addr_tag[CFG.L0_TAG_WIDTH-1:CFG.L0_EARLY_TAG_WIDTH]);
    end
    assign hit_prefetch[i] = tag[i].vld & (tag[i].tag == addr_tag_prefetch);
  end

  assign hit_any = |hit;
  assign hit_prefetch_any = |hit_prefetch;
  assign miss = ~hit_any & in_valid_i & ~pending_refill_q;

  logic clk_inv;
  tc_clk_inverter i_clk_inv (
    .clk_i (clk_i),
    .clk_o (clk_inv)
  );

  for (genvar i = 0; i < CFG.L0_LINE_COUNT; i++) begin : gen_array
    // Tag Array
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        tag[i].vld <= 0;
        tag[i].tag <= 0;
      end else begin
        if (evict_strb[i]) begin
          tag[i].vld <= 1'b0;
          tag[i].tag <= evict_because_prefetch ? addr_tag_prefetch : addr_tag;
        end else if (validate_strb[i]) begin
          tag[i].vld <= 1'b1;
        end
        if (flush_strb[i]) begin
          tag[i].vld <= 1'b0;
        end
      end
    end
    if (CFG.EARLY_LATCH) begin : gen_latch
      logic clk_vld;
      tc_clk_gating i_clk_gate (
        .clk_i     (clk_inv         ),
        .en_i      (validate_strb[i]),
        .test_en_i (1'b0            ),
        .clk_o     (clk_vld         )
      );
      // Data Array
      /* verilator lint_off NOLATCH */
      always_latch begin
        if (clk_vld) begin
          data[i] <= out_rsp_data_i;
        end
      end
      /* verilator lint_on NOLATCH */
    end else begin : gen_ff
      `FFLNR(data[i], out_rsp_data_i, validate_strb[i], clk_i)
    end
  end

  // ----
  // HIT
  // ----
  // we hit in the cache and there was a unique hit.
  assign in_ready_o = hit_any & hit_early_is_onehot;

  logic [CFG.LINE_WIDTH-1:0] ins_data;
  always_comb begin : data_muxer
    ins_data = '0;
    for (int unsigned i = 0; i < CFG.L0_LINE_COUNT; i++) begin
      ins_data |= {CFG.LINE_WIDTH{hit_early[i]}} & data[i];
    end
    in_data_o = ins_data >> (in_addr_i[CFG.LINE_ALIGN-1:CFG.FETCH_ALIGN] * CFG.FETCH_DW);
  end

  // Check whether we had an early multi-hit (e.g., the portion of the tag matched
  // multiple entries in the tag array)
  if (CFG.L0_TAG_WIDTH != CFG.L0_EARLY_TAG_WIDTH) begin : gen_multihit_detection
    onehot #(
      .Width (CFG.L0_LINE_COUNT)
    ) i_onehot_hit_early (
      .d_i (hit_early),
      .is_onehot_o (hit_early_is_onehot)
    );
  end else begin : gen_no_multihit_detection
    assign hit_early_is_onehot = 1'b1;
  end

  // -------
  // Evictor
  // -------
  logic [$clog2(CFG.L0_LINE_COUNT)-1:0] cnt_d, cnt_q;

  always_comb begin : evictor
    evict_strb = '0;
    cnt_d = cnt_q;

    // Round-Robin
    if (evict_req) begin
      evict_strb = 1 << cnt_q;
      cnt_d = cnt_q + 1;
      if (evict_strb == hit_early) begin
        evict_strb = 1 << cnt_d;
        cnt_d = cnt_q + 2;
      end
    end
  end

  always_comb begin : flush
    flush_strb = '0;
    // Check whether we encountered a multi-hit condition and
    // evict the offending entry.
    if (hit_any && !hit_early_is_onehot) begin
      // We want to evict all entries which hit with the early tag
      // but didn't hit in the final comparison.
      flush_strb = ~hit & hit_early;
    end
    if (flush_valid_i) flush_strb = '1;
  end

  `FF(cnt_q, cnt_d, '0)

  // -------------
  // Miss Handling
  // -------------
  assign refill.addr = addr_tag << CFG.LINE_ALIGN;
  assign refill.is_prefetch = 1'b0;
  assign refill_valid = miss;

  `FFLNR(pending_line_refill_q, evict_strb, evict_req, clk_i)
  `FF(pending_refill_q, pending_refill_d, '0)

  always_comb begin
    pending_refill_d = pending_refill_q;
    // re-set condition
    if (pending_refill_q) begin
      if (out_rsp_valid_i & out_rsp_ready_o) begin
        pending_refill_d = 1'b0;
      end
    // set condition
    end else begin
      if (refill_valid && refill_ready) begin
        pending_refill_d = 1'b1;
      end
      if (latch_prefetch) begin
        pending_refill_d = 1'b1;
      end
    end
  end

  assign validate_strb = out_rsp_valid_i ? pending_line_refill_q : '0;
  assign out_rsp_ready_o = 1'b1;

  assign in_error_o = '0;

  assign out_req_addr_o = out_req.addr;
  assign out_req_id_o = {L0_ID, out_req.is_prefetch};

  // Priority arbitrate requests.
  always_comb begin
    out_req = prefetch;
    out_req_valid_o = prefetch_valid;
    prefetch_ready = out_req_ready_i;
    refill_ready = 1'b0;

    if (refill_valid) begin
      out_req_valid_o = refill_valid;
      out_req = refill;
      refill_ready = out_req_ready_i;
      prefetch_ready = 1'b0;
    end
  end

  // -------------
  // Pre-fetching
  // -------------
  // Generate a prefetch request if the cache hits and we haven't
  // pre-fetched the line yet and there is no other refill in progress.
  assign prefetcher_out.vld = enable_prefetching_i & hit_any & ~hit_prefetch_any & ~pending_refill_q;

  localparam FETCH_PKTS = CFG.LINE_WIDTH/32;
  logic [FETCH_PKTS-1:0] is_branch_taken;
  logic [FETCH_PKTS-1:0] is_jal;
  logic [FETCH_PKTS-1:0] mask;
  // make sure that we only look at the packets which are of interest to
  assign mask = '1 << in_addr_i[CFG.LINE_ALIGN-1:2];

  // Instruction aware pre-fetching
  for (genvar i = 0; i < FETCH_PKTS; i++) begin : gen_pre_decode
    // iterate over the fetch packets (32 bits per instruction)
    always_comb begin
      is_branch_taken[i] = 1'b0;
      is_jal[i] = 1'b0;
      if (hit_early_is_onehot) begin
        unique casez (ins_data[i*32+:32])
          // static prediction
          riscv_instr::BEQ,
          riscv_instr::BNE,
          riscv_instr::BLT,
          riscv_instr::BGE,
          riscv_instr::BLTU,
          riscv_instr::BGEU: begin
            // look at the sign bit of the immediate field
            // backward branches (immediate negative) taken
            // forward branches not taken
            is_branch_taken[i] = ins_data[i*32+31];
          end
          riscv_instr::JAL: begin
            is_jal[i] = 1'b1;
          end
          // we can't do anything about the JALR case as we don't
          // know the destination.
          default:;
        endcase
      end
    end
  end

  logic [$clog2(FETCH_PKTS)-1:0] taken_idx;
  logic no_prefetch;
  logic [$clog2(CFG.LINE_WIDTH)-1:0] ins_idx;
  assign ins_idx = 32*taken_idx;
  // Find first taken branch
  lzc #(
    .WIDTH(FETCH_PKTS),
    .MODE(0)
  ) i_lzc_branch (
    // look at branches and jals
    .in_i (mask & (is_branch_taken | is_jal)),
    .cnt_o (taken_idx),
    .empty_o (no_prefetch)
  );

  addr_t base_addr, offset, uj_imm, sb_imm;
  logic [CFG.LINE_ALIGN-1:0] base_offset;
  assign base_offset = taken_idx << 2;
  assign uj_imm = $signed({ins_data[ins_idx+31], ins_data[ins_idx+12+:8], ins_data[ins_idx+20], ins_data[ins_idx+21+:10], 1'b0});
  assign sb_imm = $signed({ins_data[ins_idx+31], ins_data[ins_idx+7], ins_data[ins_idx+25+:6], ins_data[ins_idx+8+:4], 1'b0});

  // next address calculation
  always_comb begin
    // default is next line predictor
    base_addr = no_prefetch ? in_addr_i : {in_addr_i >> CFG.LINE_ALIGN, base_offset};
    offset = (1 << CFG.LINE_ALIGN);
    // If the cache-line contains a taken branch, compute the pre-fetch address with the jump's offset.
    unique case ({is_branch_taken[taken_idx] & ~no_prefetch, is_jal[taken_idx] & ~no_prefetch})
      // JAL: UJ Immediate
      2'b01: offset = uj_imm;
      // Branch: // SB Immediate
      2'b10: offset = sb_imm;
      default:;
    endcase
  end

  assign prefetcher_out.addr = ($signed(base_addr) + offset) >> CFG.LINE_ALIGN << CFG.LINE_ALIGN;

  // check whether cache-line we want to pre-fetch is already present
  assign addr_tag_prefetch = prefetcher_out.addr >> CFG.LINE_ALIGN;

  assign latch_prefetch = prefetcher_out.vld & ~prefetch_req_q.vld;

  always_comb begin
      prefetch_req_d = prefetch_req_q;

      if (prefetch_ready) prefetch_req_d.vld = 1'b0;

      if (latch_prefetch) begin
          prefetch_req_d.vld = 1'b1;
          prefetch_req_d.addr = prefetcher_out.addr;
      end
  end

  assign prefetch.is_prefetch = 1'b1;
  assign prefetch.addr = prefetch_req_q.addr;
  assign prefetch_valid = prefetch_req_q.vld;

  `FF(prefetch_req_q.vld, prefetch_req_d.vld, '0)
  `FF(prefetch_req_q.addr, prefetch_req_d.addr, '0)

  // ------------------
  // Performance Events
  // ------------------
  always_comb begin
    icache_events_o = '0;
    icache_events_o.l0_miss = miss;
    icache_events_o.l0_hit = hit_any & in_valid_i;
    icache_events_o.l0_prefetch = prefetcher_out.vld;
    icache_events_o.l0_double_hit = hit_any & ~hit_early_is_onehot & in_valid_i;
  end

  // ----------
  // Assertions
  // ----------
  `ASSERT(HitOnehot, $onehot0(hit))
  // make sure only one signal is high and the conditions are mutual exclusive
  `ASSERT(ExclusiveEvict, $onehot0({evict_because_miss, evict_because_prefetch}))
  // request must be stable
  `ASSERT(InstReqStable, in_valid_i && !in_ready_o |=> in_valid_i)
  `ASSERT(InstReqDataStable, in_valid_i && !in_ready_o |=> $stable(in_addr_i))

  `ASSERT(RefillReqStable, out_req_valid_o && !out_req_ready_i |=> out_req_valid_o)
  `ASSERT(RefillReqDataStable, out_req_valid_o && !out_req_ready_i |=> $stable(out_req_addr_o) && $stable(out_req_id_o))

  `ASSERT(RefillRspStable, out_rsp_valid_i && !out_rsp_ready_o |=> out_rsp_valid_i)
  `ASSERT(RefillRspDataStable, out_rsp_valid_i && !out_rsp_ready_o |=> $stable(out_rsp_data_i) && $stable(out_rsp_error_i) && $stable(out_rsp_id_i))
  // make sure we observe a double hit condition
  `COVER(HitEarlyNotOnehot, hit |-> $onehot(hit_early))

endmodule
