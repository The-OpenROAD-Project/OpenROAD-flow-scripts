// One cycle of an L2 cache slice: the directory's hit, decided in s3 from
// tag and meta registers fed by SRAM macros, steers the slice in the same
// cycle: MainPipe's meta write into the directory, the directory's single
// port and through it RequestArb's ready to SinkC, which enables SinkC's
// data-buffer read; the MSHR allocation; the L1 hint queue; and the data
// array's request. XiangShan's CoupledL2 (XSCache at 300515bc):
// coupledL2/Directory.scala, MainPipe.scala, RequestArb.scala, SinkC.scala,
// MSHRCtl.scala, CustomL1Hint.scala and DataStorage.scala; each piece
// cites its lines. README.md says what the design is for.
//
// Every input is registered at its port and every output leaves a
// register, so the only paths that can fail are register to register
// (constraint.sdc).
module l2_dir_hit #(
    parameter int SETS = 1024,
    parameter int WAYS = 8,
    parameter int TAGBITS = 32,
    parameter int METABITS = 16,
    parameter int SOURCEBITS = 7,
    parameter int MSHRS = 16,  // mshrsAll
    parameter int BUFBLOCKS = 4,  // SinkC's bufBlocks (CoupledL2.scala:75)
    parameter int BEATBITS = 256,  // beatBytes = 32
    parameter int BANKS = 4,  // dataSplit (DataStorage.scala:68)
    parameter int BANKBITS = 137  // SECDED(128)
) (
    input  logic                      clock,
    input  logic                      reset,
    // channel A: an acquire, a get, a prefetch or a CMO from the L1
    input  logic                      a_valid,
    input  logic [               3:0] a_opcode,
    input  logic                      a_need_t,
    input  logic [               1:0] a_alias,
    input  logic [  $clog2(SETS)-1:0] a_set,
    input  logic [       TAGBITS-1:0] a_tag,
    input  logic [    SOURCEBITS-1:0] a_source,
    output logic                      a_ready,
    // channel B: a snoop from the interconnect, by class (MainPipe.scala:266-302)
    input  logic                      b_valid,
    input  logic [  $clog2(SETS)-1:0] b_set,
    input  logic [       TAGBITS-1:0] b_tag,
    input  logic [               4:0] b_snoop,            // {resp data, fwd, to N, to B, stable}
    output logic                      b_ready,
    // channel C: a release with data from the L1, two beats
    input  logic                      c_valid,
    input  logic                      c_last,
    input  logic [  $clog2(SETS)-1:0] c_set,
    input  logic [       TAGBITS-1:0] c_tag,
    input  logic [      BEATBITS-1:0] c_data,
    input  logic                      c_from_t,           // isParamFromT(param)
    output logic                      c_ready,
    // an MSHR task: a refill, its way, its tag write
    input  logic                      m_valid,
    input  logic [  $clog2(SETS)-1:0] m_set,
    input  logic [       TAGBITS-1:0] m_tag,
    input  logic [  $clog2(WAYS)-1:0] m_way,
    input  logic [BANKS*BANKBITS-1:0] m_refill_data,
    input  logic                      m_meta_wen,
    input  logic                      m_ds_wen,
    input  logic                      m_refill,           // mshr_refill_s3
    input  logic [          WAYS-1:0] repl_way_oh,        // the replacer's choice
    input  logic                      repl_valid_hold,    // io.replResp, at s3
    input  logic                      repl_retry,
    input  logic [               1:0] repl_state,
    // an MSHR finishing, and a status read
    input  logic [         MSHRS-1:0] mshr_free,
    input  logic [ $clog2(MSHRS)-1:0] mshr_query,
    output logic [       TAGBITS-1:0] mshr_status_tag,
    output logic [               5:0] mshr_status_state,
    // the hint queue's other source, at s1 (CustomL1Hint.scala:107-122)
    input  logic                      hint_s1_valid,
    input  logic [    SOURCEBITS-1:0] hint_s1_source,
    input  logic                      hint_ready,
    output logic                      hint_valid,
    output logic [    SOURCEBITS-1:0] hint_source,
    output logic                      hint_has_data,
    // the data array
    output logic                      ds_clock_en,        // the array's clock gate
    output logic [BANKS*BANKBITS-1:0] ds_rdata
);
  localparam int SETBITS = $clog2(SETS);
  localparam int WAYBITS = $clog2(WAYS);
  localparam int BUFBITS = $clog2(BUFBLOCKS);
  // TileLink A opcodes, and XiangShan's CMO extension; the CMO encodings
  // are this design's, XiangShan takes them from its rocket-chip fork
  localparam logic [3:0] GET = 4, HINT = 5, ACQUIRE_BLOCK = 6, ACQUIRE_PERM = 7;
  localparam logic [3:0] CBO_CLEAN = 8, CBO_FLUSH = 9, CBO_INVAL = 10;
  localparam logic [2:0] ACCESS_ACK_DATA = 1, HINT_ACK = 2, GRANT = 4, GRANT_DATA = 5;
  // coupledL2/MetaData.scala
  localparam logic [1:0] INVALID = 0, BRANCH = 1, TRUNK = 2, TIP = 3;
  // the meta entry's fields, as this design packs MetaEntry
  // (Directory.scala:31-48): state, dirty, clients, alias, tagErr
  localparam int M_DIRTY = 2, M_CLIENTS = 3, M_ALIAS = 4, M_TAGERR = 8;

  // SECDED over a 128-bit word, as DataStorage encodes a bank
  // (DataStorage.scala:91-104): a Hamming code over positions 1..136 and
  // an overall parity bit. On a two-cycle path (constraint.sdc).
  function automatic logic [BANKBITS-1:0] secded128(input logic [127:0] d);
    logic [135:0] h;
    logic [  7:0] c;
    int           k;
    h = '0;
    k = 0;
    for (int p = 1; p <= 136; p++)
      if ((p & (p - 1)) != 0) begin
        h[p-1] = d[k];
        k++;
      end
    c = '0;
    for (int p = 1; p <= 136; p++) for (int b = 0; b < 8; b++) if (p[b]) c[b] ^= h[p-1];
    return {^{c, d}, c, d};
  endfunction

  // ---- port registers ----
  logic in_a_valid, in_a_need_t, in_c_valid, in_c_last, in_m_valid, in_b_valid, in_c_from_t;
  logic in_m_meta_wen, in_m_ds_wen, in_m_refill, in_repl_valid_hold, in_repl_retry;
  logic [               3:0] in_a_opcode;
  logic [               1:0] in_a_alias, in_repl_state;
  logic [               4:0] in_b_snoop;
  logic [SETBITS-1:0] in_a_set, in_c_set, in_m_set, in_b_set;
  logic [TAGBITS-1:0] in_a_tag, in_c_tag, in_m_tag, in_b_tag;
  logic [SOURCEBITS-1:0] in_a_source, in_hint_s1_source;
  logic [      BEATBITS-1:0] in_c_data;
  logic [       WAYBITS-1:0] in_m_way;
  logic [BANKS*BANKBITS-1:0] in_m_refill_data;
  logic [          WAYS-1:0] in_repl_way_oh;
  logic [         MSHRS-1:0] in_mshr_free;
  logic [ $clog2(MSHRS)-1:0] in_mshr_query;
  logic in_hint_s1_valid, in_hint_ready;
  always_ff @(posedge clock) begin
    in_a_valid        <= !reset && a_valid;
    in_b_valid        <= !reset && b_valid;
    in_a_alias        <= a_alias;
    in_b_set          <= b_set;
    in_b_tag          <= b_tag;
    in_b_snoop        <= b_snoop;
    in_c_from_t       <= c_from_t;
    in_m_meta_wen     <= m_meta_wen;
    in_m_ds_wen       <= m_ds_wen;
    in_m_refill       <= m_refill;
    in_repl_valid_hold <= repl_valid_hold;
    in_repl_retry     <= repl_retry;
    in_repl_state     <= repl_state;
    in_c_valid        <= !reset && c_valid;
    in_m_valid        <= !reset && m_valid;
    in_hint_s1_valid  <= !reset && hint_s1_valid;
    in_hint_ready     <= !reset && hint_ready;
    in_mshr_free      <= reset ? '0 : mshr_free;
    in_a_opcode       <= a_opcode;
    in_a_need_t       <= a_need_t;
    in_a_set          <= a_set;
    in_a_tag          <= a_tag;
    in_a_source       <= a_source;
    in_c_last         <= c_last;
    in_c_set          <= c_set;
    in_c_tag          <= c_tag;
    in_c_data         <= c_data;
    in_m_set          <= m_set;
    in_m_tag          <= m_tag;
    in_m_way          <= m_way;
    in_m_refill_data  <= m_refill_data;
    in_repl_way_oh    <= repl_way_oh;
    in_mshr_query     <= mshr_query;
    in_hint_s1_source <= hint_s1_source;
  end

  // ---- SinkC (SinkC.scala) ----
  logic                  c_task_valid, sink_c_ready, c_task_fire;
  logic [   SETBITS-1:0] c_task_set;
  logic [   TAGBITS-1:0] c_task_tag;
  logic [   BUFBITS-1:0] c_task_idx;
  logic [2*BEATBITS-1:0] buf_resp_s3;
  l2_sink_c #(
      .SETBITS(SETBITS),
      .TAGBITS(TAGBITS),
      .BUFBLOCKS(BUFBLOCKS),
      .BEATBITS(BEATBITS)
  ) u_sink_c (
      .clock       (clock),
      .reset       (reset),
      .c_valid     (in_c_valid),
      .c_last      (in_c_last),
      .c_set       (in_c_set),
      .c_tag       (in_c_tag),
      .c_data      (in_c_data),
      .c_ready     (c_ready),
      .task_valid  (c_task_valid),
      .task_set    (c_task_set),
      .task_tag    (c_task_tag),
      .task_buf_idx(c_task_idx),
      .task_ready  (sink_c_ready),
      .buf_resp    (buf_resp_s3)
  );
  assign c_task_fire = c_task_valid && sink_c_ready;

  // ---- RequestArb s1: an MSHR task first, then C, B and A, into s2 when
  // the directory can be read (RequestArb.scala:134-208) ----
  logic dir_read_ready, stall_q, s2_ready, sink_ready_basic, block_b, block_c;
  logic c_req, b_req;
  assign s2_ready         = !stall_q;  // ds_mcp2_stall (:201-204)
  assign sink_ready_basic = dir_read_ready && !in_m_valid && s2_ready;  // :151
  assign c_req            = c_task_valid && !block_c;  // sinkValids (:141-145)
  assign b_req            = in_b_valid && !block_b;
  assign sink_c_ready     = sink_ready_basic && !block_c;  // :153-155
  assign b_ready          = sink_ready_basic && !block_b && !c_req;
  assign a_ready          = sink_ready_basic && !b_req && !c_req;

  logic fire_m, fire_c, fire_b, fire_a, fire_s1;
  assign fire_m  = in_m_valid && s2_ready;
  assign fire_c  = c_task_fire;
  assign fire_b  = in_b_valid && b_ready;
  assign fire_a  = in_a_valid && a_ready;
  assign fire_s1 = fire_m || fire_c || fire_b || fire_a;
  always_ff @(posedge clock) stall_q <= !reset && fire_s1;

  // the task, s1 to s3
  typedef struct packed {
    logic                  mshr;
    logic                  from_a;
    logic                  from_c;
    logic                  from_b;
    logic [3:0]            opcode;
    logic [1:0]            alias_bits;
    logic [4:0]            snoop;
    logic                  c_from_t;
    logic                  meta_wen;
    logic                  ds_wen;
    logic                  refill;
    logic                  need_t;
    logic [SETBITS-1:0]    setidx;
    logic [TAGBITS-1:0]    tag;
    logic [WAYBITS-1:0]    way;
    logic [SOURCEBITS-1:0] source;
    logic [BUFBITS-1:0]    buf_idx;
  } task_t;
  task_t task_s1, task_s2, task_s3;
  always_comb begin
    task_s1         = '0;
    task_s1.mshr    = fire_m;
    task_s1.from_c  = !fire_m && fire_c;
    task_s1.from_b  = !fire_m && !fire_c && fire_b;
    task_s1.from_a  = !fire_m && !fire_c && !fire_b;
    task_s1.alias_bits   = in_a_alias;
    task_s1.snoop   = in_b_snoop;
    task_s1.c_from_t = in_c_from_t;
    task_s1.meta_wen = in_m_meta_wen;
    task_s1.ds_wen  = in_m_ds_wen;
    task_s1.refill  = in_m_refill;
    task_s1.opcode  = in_a_opcode;
    task_s1.need_t  = in_a_need_t;
    task_s1.setidx  = fire_m ? in_m_set : fire_c ? c_task_set : fire_b ? in_b_set : in_a_set;
    task_s1.tag     = fire_m ? in_m_tag : fire_c ? c_task_tag : fire_b ? in_b_tag : in_a_tag;
    task_s1.way     = in_m_way;
    task_s1.source  = in_a_source;
    task_s1.buf_idx = c_task_idx;
  end

  logic v_s2, v_s3, v_s3_hold2;
  always_ff @(posedge clock) begin
    v_s2 <= !reset && fire_s1;
    v_s3 <= !reset && v_s2;
    // task_s3_valid_hold2 (MainPipe.scala:500)
    if (reset) v_s3_hold2 <= 1'b0;
    else if (!v_s3) v_s3_hold2 <= v_s2;
    if (fire_s1) task_s2 <= task_s1;
    if (v_s2) task_s3 <= task_s2;
  end

  // MainPipe's set blocks (MainPipe.scala:954-979): a C task waits for an
  // s2 task of its set that may write the directory, a snoop for one at s2
  // or s3
  assign block_c = v_s2 && task_s2.setidx == c_task_set && !(task_s2.mshr && !task_s2.meta_wen);
  assign block_b = v_s2 && task_s2.setidx == in_b_set || v_s3 && task_s3.setidx == in_b_set;

  // the refill buffer, read at s2 and its response registered for s3, so
  // it holds with the task (RequestArb.scala:235-238)
  logic [BANKS*BANKBITS-1:0] refill_s3;
  always_ff @(posedge clock) if (v_s2) refill_s3 <= in_m_refill_data;

  // the replacer's answer for the task at s3, held with it (validHold,
  // MainPipe.scala:237)
  logic            repl_valid_s3, repl_retry_s3;
  logic [     1:0] repl_state_s3;
  logic [WAYS-1:0] repl_way_oh_s3;
  always_ff @(posedge clock)
    if (v_s2) begin
      repl_way_oh_s3 <= in_repl_way_oh;
      repl_valid_s3 <= in_repl_valid_hold;
      repl_retry_s3 <= in_repl_retry;
      repl_state_s3 <= in_repl_state;
    end

  // ---- the directory: read in s1 for a channel task, written by MainPipe
  // at s3 ----
  logic hit, dir_valid, err_on_snp;
  logic [ WAYBITS-1:0] dir_way;
  logic [METABITS-1:0] meta_on_hit;
  logic meta_wen, tag_wen, replacer_wen;
  logic [METABITS-1:0] meta_wmeta;
  logic [WAYS-1:0] meta_wway_oh, tag_wway_oh;
  l2_directory #(
      .SETS(SETS),
      .WAYS(WAYS),
      .TAGBITS(TAGBITS),
      .METABITS(METABITS)
  ) u_dir (
      .clock         (clock),
      .reset         (reset),
      .read_fire     (fire_s1 && !fire_m),
      .read_set      (task_s1.setidx),
      .read_tag      (task_s1.tag),
      .tag_wen       (tag_wen),
      .tag_wset      (task_s3.setidx),
      .tag_wway_oh   (tag_wway_oh),
      .tag_wtag      (task_s3.tag),
      .meta_wen      (meta_wen),
      .meta_wset     (task_s3.setidx),
      .meta_wway_oh  (meta_wway_oh),
      .meta_wmeta    (meta_wmeta),
      .repl_way_oh_s3(repl_way_oh_s3),
      .resp_valid_s3 (dir_valid),
      .hit_s3        (hit),
      .way_s3        (dir_way),
      .meta_s3       (),
      .meta_on_hit_s3(meta_on_hit),
      .err_on_snp_s3 (err_on_snp)
  );
  // the arrays are single ported: a write this cycle is no read
  // (Directory.scala:343); the replacer is written on every hit (:390)
  assign replacer_wen   = dir_valid && hit;
  assign dir_read_ready = !meta_wen && !tag_wen && !replacer_wen;

  // ---- s3: MainPipe's decision (MainPipe.scala:160-304) ----
  // As MainPipe does, the decision is made on the task's bits, which hold
  // for two cycles, and the valid is applied where each consumer takes it
  // (:309, :499-504, :605): the data array's request must hold for both.
  logic a_s3, b_s3, c_s3, m_s3;
  assign a_s3 = !task_s3.mshr && task_s3.from_a;
  assign b_s3 = !task_s3.mshr && task_s3.from_b;
  assign c_s3 = !task_s3.mshr && task_s3.from_c;
  assign m_s3 = task_s3.mshr;

  logic req_get, req_hint, req_acquire_block, req_acquire, cbo_clean, cbo_flush, cbo_inval, cmo;
  assign req_get           = a_s3 && task_s3.opcode == GET;  // :172-179
  assign req_hint          = a_s3 && task_s3.opcode == HINT;
  assign req_acquire_block = a_s3 && task_s3.opcode == ACQUIRE_BLOCK;
  assign req_acquire       = a_s3 && (task_s3.opcode == ACQUIRE_BLOCK || task_s3.opcode == ACQUIRE_PERM);
  assign cbo_clean         = a_s3 && task_s3.opcode == CBO_CLEAN;
  assign cbo_flush         = a_s3 && task_s3.opcode == CBO_FLUSH;
  assign cbo_inval         = a_s3 && task_s3.opcode == CBO_INVAL;
  assign cmo               = cbo_clean || cbo_flush || cbo_inval;  // :220

  logic [1:0] state;
  logic has_clients, dirty, tag_err;
  assign state       = meta_on_hit[1:0];
  assign has_clients = meta_on_hit[M_CLIENTS];
  assign dirty       = meta_on_hit[M_DIRTY];
  assign tag_err     = meta_on_hit[M_TAGERR];

  // a hit whose client holds the line under another alias (:225-226)
  logic cache_alias;
  assign cache_alias = req_acquire && hit && has_clients && meta_on_hit[M_ALIAS+:2] != task_s3.alias_bits;

  // channel A (:244-265)
  logic acquire_on_miss, acquire_on_hit, need_acquire_a, need_probe_a, need_mshr_a;
  assign acquire_on_miss = req_acquire || req_hint || req_get;
  assign acquire_on_hit  = state == BRANCH && task_s3.need_t && !req_hint;
  assign need_acquire_a  = a_s3 && ((hit ? acquire_on_hit : acquire_on_miss) || cmo);
  assign need_probe_a    = hit && has_clients &&
                           (req_get && state == TRUNK || cbo_clean && state == TRUNK || cbo_flush || cbo_inval);
  assign need_mshr_a     = need_acquire_a || need_probe_a || cache_alias;

  // channel B, a snoop (:281-302)
  logic snp_stable, snp_to_b, snp_to_n, snp_fwd, snp_resp_data;
  assign {snp_resp_data, snp_fwd, snp_to_n, snp_to_b, snp_stable} = task_s3.snoop;
  logic do_fwd, need_pprobe_b, need_mshr_b;
  assign do_fwd        = snp_fwd && hit && !(tag_err || err_on_snp);
  assign need_pprobe_b = b_s3 && hit && (
      snp_stable && state == TRUNK && has_clients ||
      snp_to_b && state == TRUNK && has_clients ||
      snp_to_n && has_clients ||
      err_on_snp || tag_err);
  assign need_mshr_b   = need_pprobe_b || b_s3 && do_fwd;

  logic need_mshr;
  assign need_mshr = need_mshr_a || need_mshr_b;  // :304

  // the replacer's answer for a refill (:237-239)
  logic retry, need_repl;
  assign retry     = repl_valid_s3 && repl_retry_s3;
  assign need_repl = repl_valid_s3 && repl_state_s3 != INVALID;

  // MainPipe's directory writes (:538-616)
  logic mw_a, mw_b, mw_c, mw_m, mw_cmo;
  assign mw_a   = a_s3 && !need_mshr_a && !req_get && !req_hint && !cmo;
  assign mw_b   = b_s3 && !need_mshr_b && hit && (state == TIP || state == BRANCH && snp_to_n);
  assign mw_c   = c_s3 && hit;
  assign mw_m   = m_s3 && task_s3.meta_wen && !(task_s3.refill && retry);
  assign mw_cmo = cbo_inval && hit;
  logic [METABITS-1:0] meta_w_a, meta_w_b, meta_w_c, meta_w_m;
  always_comb begin
    meta_w_a            = meta_on_hit;
    meta_w_a[1:0]       = task_s3.need_t ? TRUNK : state;
    meta_w_a[M_CLIENTS] = 1'b1;
    meta_w_a[M_ALIAS+:2] = task_s3.alias_bits;
    meta_w_b            = meta_on_hit;
    meta_w_b[1:0]       = snp_to_n ? INVALID : BRANCH;
    meta_w_c            = meta_on_hit;
    meta_w_c[1:0]       = TIP;
    meta_w_c[M_DIRTY]   = dirty || task_s3.c_from_t;
    meta_w_c[M_CLIENTS] = 1'b0;
    meta_w_m            = '0;
    meta_w_m[1:0]       = TIP;
  end
  assign meta_wen     = v_s3 && (mw_a || mw_b || mw_c || mw_m || mw_cmo);  // :605-606
  assign meta_wmeta   = mw_a ? meta_w_a : mw_b ? meta_w_b : mw_c ? meta_w_c : mw_m ? meta_w_m : '0;
  assign meta_wway_oh = m_s3 ? WAYS'(1) << task_s3.way : WAYS'(1) << dir_way;
  assign tag_wen      = v_s3 && m_s3 && task_s3.refill && !retry;  // :613
  assign tag_wway_oh  = WAYS'(1) << task_s3.way;

  // ---- s3: MSHR allocation (MainPipe.scala:309, 1021-1059;
  // MSHRCtl.scala:97-137): the lowest idle MSHR takes the request and the
  // state its hit decided ----
  logic [5:0] alloc_state;
  assign alloc_state = {
    !need_pprobe_b,  // s_pprobe
    !need_acquire_a,  // s_acquire
    cmo || hit,  // w_replResp (:1022)
    !(need_acquire_a && !cmo),  // s_rcompack (:1026)
    !need_probe_a,  // s_rprobe
    !cmo  // s_cmoresp
  };
  l2_mshr_ctl #(
      .MSHRS  (MSHRS),
      .TAGBITS(TAGBITS)
  ) u_mshr_ctl (
      .clock       (clock),
      .reset       (reset),
      .alloc_valid (v_s3 && need_mshr),
      .alloc_state (alloc_state),
      .alloc_tag   (task_s3.tag),
      .free        (in_mshr_free),
      .query       (in_mshr_query),
      .status_tag  (mshr_status_tag),
      .status_state(mshr_status_state)
  );

  // ---- s3: the L1 hint, "chnTask Hit will fire@s3" (CustomL1Hint.scala:91-126) ----
  logic sink_resp, enq_s3, enq_has_data;
  logic [2:0] d_opcode;
  assign sink_resp = a_s3 && !need_mshr_a;  // sink_resp_s3.valid (:432)
  // odOpGen (MainPipe.scala:434): Get, AcquireBlock and AcquirePerm answer
  // AccessAckData, GrantData and Grant; anything else no hint (HINT_ACK)
  assign d_opcode = req_get ? ACCESS_ACK_DATA : req_acquire_block ? GRANT_DATA :
                    req_acquire ? GRANT : HINT_ACK;
  assign enq_s3 = v_s3 && sink_resp && (d_opcode == GRANT || d_opcode == GRANT_DATA ||
                                d_opcode == ACCESS_ACK_DATA);
  assign enq_has_data = d_opcode != GRANT;

  l2_custom_l1_hint #(
      .SOURCEBITS(SOURCEBITS),
      .ENTRIES   (MSHRS)
  ) u_custom_l1_hint (
      .clock          (clock),
      .reset          (reset),
      .enq_s3         (enq_s3),
      .enq_s3_has_data(enq_has_data),
      .enq_s3_source  (task_s3.source),
      .s1_valid       (in_hint_s1_valid),
      .s1_source      (in_hint_s1_source),
      .hint_ready     (in_hint_ready),
      .hint_valid     (hint_valid),
      .hint_source    (hint_source),
      .hint_has_data  (hint_has_data)
  );

  // ---- s3: the data array's request (MainPipe.scala:484-519) ----
  // en is the cycle's pulse that opens the array's clock gate; req holds
  // for two cycles, and so do its way, set and write data
  // (DataStorage.scala:52-65). The gate's enable is a register here: a
  // clock gate's latch has the same setup check at the same edge. A
  // release that hits writes its data, from SinkC's buffer; a refill
  // writes the MSHR's.
  logic ren, wen, ds_en, ds_req_valid, ds_cg_en;
  logic [WAYBITS-1:0] ds_way;
  assign ren = hit && (req_get || req_acquire_block) ||  // need_data_a (:484-488)
               b_s3 && (snp_resp_data || do_fwd || hit && state == TRUNK) ||
               task_s3.refill && need_repl && !retry ||
               cmo && hit && dirty;
  assign wen = c_s3 && task_s3.c_from_t && hit ||  // wen_c (:490)
               m_s3 && task_s3.ds_wen && (!task_s3.refill || !need_repl && !retry);
  assign ds_en        = v_s3 && (ren || wen);
  assign ds_req_valid = v_s3_hold2 && (ren || wen);
  assign ds_way       = m_s3 ? task_s3.way : dir_way;
  always_ff @(posedge clock) ds_cg_en <= !reset && ds_en;
  assign ds_clock_en = ds_cg_en;

  logic [BANKBITS-1:0] bank_rdata[BANKS];
  for (genvar b = 0; b < BANKS; b++) begin : g_bank
    logic [BANKBITS-1:0] wdata;
    assign wdata = m_s3 ? refill_s3[b*BANKBITS+:BANKBITS] :
                          secded128(buf_resp_s3[b*128+:128]);
    l2_data_sram u_sram (
        .RW0_clk  (clock),
        .RW0_en   (ds_req_valid),
        .RW0_wmode(wen),
        .RW0_addr ({ds_way, task_s3.setidx}),
        .RW0_wdata(wdata),
        .RW0_rdata(bank_rdata[b])
    );
  end

  // s5: the read data, two cycles after the read edge ("s3 read, s4 pass
  // and s5 to destination", DataStorage.scala:119-121). Its destinations
  // are inside the slice, so s5 is too, and the port takes it a cycle
  // later: an output register is drawn to its pin.
  logic [BANKS*BANKBITS-1:0] rdata_s5;
  always_ff @(posedge clock) begin
    for (int b = 0; b < BANKS; b++) rdata_s5[b*BANKBITS+:BANKBITS] <= bank_rdata[b];
    ds_rdata <= rdata_s5;
  end
endmodule
