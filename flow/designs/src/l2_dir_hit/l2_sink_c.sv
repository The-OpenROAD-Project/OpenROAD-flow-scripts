// SinkC: a release's two beats into a data buffer, its task into a task
// buffer that waits for RequestArb, and the task's data read the cycle it
// fires (coupledL2/SinkC.scala:48-193, XSCache at 300515bc). The read
// register's enable is task_fire, so RequestArb's ready reaches every bit
// of it.
module l2_sink_c #(
    parameter int SETBITS = 10,
    parameter int TAGBITS = 32,
    parameter int BUFBLOCKS = 4,  // bufBlocks (CoupledL2.scala:75)
    parameter int BEATBITS = 256  // beatBytes = 32
) (
    input  logic                         clock,
    input  logic                         reset,
    // channel C
    input  logic                         c_valid,
    input  logic                         c_last,
    input  logic [          SETBITS-1:0] c_set,
    input  logic [          TAGBITS-1:0] c_tag,
    input  logic [         BEATBITS-1:0] c_data,
    output logic                         c_ready,
    // the task to RequestArb
    output logic                         task_valid,
    output logic [          SETBITS-1:0] task_set,
    output logic [          TAGBITS-1:0] task_tag,
    output logic [$clog2(BUFBLOCKS)-1:0] task_buf_idx,
    input  logic                         task_ready,
    // bufResp, the task's data two cycles after it fired (:190)
    output logic [       2*BEATBITS-1:0] buf_resp
);
  localparam int BUFBITS = $clog2(BUFBLOCKS);

  logic [BEATBITS-1:0] data_buf  [BUFBLOCKS][2];
  logic [ SETBITS-1:0] task_sets [BUFBLOCKS];
  logic [ TAGBITS-1:0] task_tags [BUFBLOCKS];
  logic [BUFBLOCKS-1:0] task_valids, data_valids;
  logic first_beat, buf_full;
  logic [BUFBITS-1:0] next_ptr, next_ptr_reg, c_ptr;
  assign buf_full = &(task_valids | data_valids);
  always_comb begin  // PriorityEncoder(~bufValids) (:64)
    next_ptr = '0;
    for (int i = BUFBLOCKS - 1; i >= 0; i--)
    if (!(task_valids[i] || data_valids[i])) next_ptr = i[BUFBITS-1:0];
  end
  assign c_ptr   = first_beat ? next_ptr : next_ptr_reg;
  assign c_ready = !first_beat || !buf_full;  // :188

  // taskArb: the lowest valid entry goes to RequestArb (:134-147)
  always_comb begin
    task_valid   = |task_valids;
    task_buf_idx = '0;
    for (int i = BUFBLOCKS - 1; i >= 0; i--) if (task_valids[i]) task_buf_idx = i[BUFBITS-1:0];
  end
  assign task_set = task_sets[task_buf_idx];
  assign task_tag = task_tags[task_buf_idx];

  logic task_fire;
  assign task_fire = task_valid && task_ready;

  // bufResp := RegNext(RegEnable(dataBuf(bufIdx), io.task.fire)); the
  // entry frees the cycle after (:190-193)
  logic [2*BEATBITS-1:0] buf_resp_q;
  logic                  fired_q;
  logic [   BUFBITS-1:0] fired_idx_q;
  always_ff @(posedge clock) begin
    if (task_fire) buf_resp_q <= {data_buf[task_buf_idx][1], data_buf[task_buf_idx][0]};
    buf_resp    <= buf_resp_q;
    fired_q     <= !reset && task_fire;
    fired_idx_q <= task_buf_idx;
  end

  always_ff @(posedge clock) begin
    if (reset) begin
      task_valids  <= '0;
      data_valids  <= '0;
      first_beat   <= 1'b1;
      next_ptr_reg <= '0;
    end else begin
      if (fired_q) data_valids[fired_idx_q] <= 1'b0;
      if (task_fire) task_valids[task_buf_idx] <= 1'b0;
      if (c_valid && c_ready) begin
        data_buf[c_ptr][!first_beat] <= c_data;
        data_valids[c_ptr]           <= 1'b1;
        if (first_beat) next_ptr_reg <= next_ptr;
        first_beat <= c_last;
        if (c_last) begin
          task_valids[c_ptr] <= 1'b1;
          task_sets[c_ptr]   <= c_set;
          task_tags[c_ptr]   <= c_tag;
        end
      end
    end
  end
endmodule
