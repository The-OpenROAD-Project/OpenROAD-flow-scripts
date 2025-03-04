// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

module mempool_cc
  import snitch_pkg::meta_id_t;
#(
  parameter logic [31:0] BootAddr   = 32'h0000_1000,
  parameter logic [31:0] MTVEC      = BootAddr,
  parameter bit          RVE        = 0,  // Reduced-register extension
  parameter bit          RVM        = 1,  // Enable IntegerMmultiplication & Division Extension
  parameter bit RegisterOffloadReq  = 1,
  parameter bit RegisterOffloadResp = 1,
  parameter bit RegisterTCDMReq     = 0,
  parameter bit RegisterTCDMResp    = 0
) (
  input  logic               clk_i,
  input  logic               rst_i,
  input  logic [31:0]        hart_id_i,
  // Instruction Port
  output logic [31:0]        inst_addr_o,
  input  logic [31:0]        inst_data_i,
  output logic               inst_valid_o,
  input  logic               inst_ready_i,
  // TCDM Ports
  output logic [31:0]        data_qaddr_o,
  output logic               data_qwrite_o,
  output logic [3:0]         data_qamo_o,
  output logic [31:0]        data_qdata_o,
  output logic [3:0]         data_qstrb_o,
  output meta_id_t           data_qid_o,
  output logic               data_qvalid_o,
  input  logic               data_qready_i,
  input  logic [31:0]        data_pdata_i,
  input  logic               data_perror_i,
  input  meta_id_t           data_pid_i,
  input  logic               data_pvalid_i,
  output logic               data_pready_o,
  input  logic               wake_up_sync_i,
  // Core event strobes
  output snitch_pkg::core_events_t core_events_o
);

  // Data port signals
  snitch_pkg::dreq_t  data_req_d, data_req_q;
  snitch_pkg::dresp_t data_resp_d, data_resp_q;

  logic data_req_d_valid, data_req_d_ready, data_resp_d_valid, data_resp_d_ready;
  logic data_req_q_valid, data_req_q_ready, data_resp_q_valid, data_resp_q_ready;

  // Accelerator signals
  snitch_pkg::acc_req_t  acc_req_d,  acc_req_q;
  snitch_pkg::acc_resp_t acc_resp_d, acc_resp_q;

  logic acc_req_d_valid, acc_req_d_ready, acc_resp_d_valid, acc_resp_d_ready;
  logic acc_req_q_valid, acc_req_q_ready, acc_resp_q_valid, acc_resp_q_ready;

  // Snitch Integer Core
  snitch #(
    .BootAddr ( BootAddr ),
    .MTVEC    ( MTVEC    ),
    .RVE      ( RVE      ),
    .RVM      ( RVM      )
  ) i_snitch (
    .clk_i                                   ,
    .rst_i                                   ,
    .hart_id_i                               ,
    .inst_addr_o                             ,
    .inst_data_i                             ,
    .inst_valid_o                            ,
    .inst_ready_i                            ,
    .acc_qaddr_o      ( acc_req_d.addr      ),
    .acc_qid_o        ( acc_req_d.id        ),
    .acc_qdata_op_o   ( acc_req_d.data_op   ),
    .acc_qdata_arga_o ( acc_req_d.data_arga ),
    .acc_qdata_argb_o ( acc_req_d.data_argb ),
    .acc_qdata_argc_o ( acc_req_d.data_argc ),
    .acc_qvalid_o     ( acc_req_d_valid     ),
    .acc_qready_i     ( acc_req_d_ready     ),
    .acc_pdata_i      ( acc_resp_q.data     ),
    .acc_pid_i        ( acc_resp_q.id       ),
    .acc_perror_i     ( acc_resp_q.error    ),
    .acc_pvalid_i     ( acc_resp_q_valid    ),
    .acc_pready_o     ( acc_resp_q_ready    ),
    .data_qaddr_o     ( data_req_d.addr     ),
    .data_qwrite_o    ( data_req_d.write    ),
    .data_qamo_o      ( data_req_d.amo      ),
    .data_qdata_o     ( data_req_d.data     ),
    .data_qstrb_o     ( data_req_d.strb     ),
    .data_qid_o       ( data_req_d.id       ),
    .data_qvalid_o    ( data_req_d_valid    ),
    .data_qready_i    ( data_req_d_ready    ),
    .data_pdata_i     ( data_resp_q.data    ),
    .data_perror_i    ( data_resp_q.error   ),
    .data_pid_i       ( data_resp_q.id      ),
    .data_pvalid_i    ( data_resp_q_valid   ),
    .data_pready_o    ( data_resp_q_ready   ),
    .wake_up_sync_i   ( wake_up_sync_i      ),
    .core_events_o    ( core_events_o       )
  );

  // Cut off-loading request path
  spill_register #(
    .T      ( snitch_pkg::acc_req_t ),
    .Bypass ( !RegisterOffloadReq   )
  ) i_spill_register_acc_req (
    .clk_i   ,
    .rst_ni  ( ~rst_i          ),
    .valid_i ( acc_req_d_valid ),
    .ready_o ( acc_req_d_ready ),
    .data_i  ( acc_req_d       ),
    .valid_o ( acc_req_q_valid ),
    .ready_i ( acc_req_q_ready ),
    .data_o  ( acc_req_q       )
  );

  // Cut off-loading response path
  spill_register #(
    .T      ( snitch_pkg::acc_resp_t ),
    .Bypass ( !RegisterOffloadResp   )
  ) i_spill_register_acc_resp (
    .clk_i                       ,
    .rst_ni  ( ~rst_i           ),
    .valid_i ( acc_resp_d_valid ),
    .ready_o ( acc_resp_d_ready ),
    .data_i  ( acc_resp_d       ),
    .valid_o ( acc_resp_q_valid ),
    .ready_i ( acc_resp_q_ready ),
    .data_o  ( acc_resp_q       )
  );

  // Snitch IPU accelerator
  snitch_ipu #(
    .IdWidth ( 5 )
  ) i_snitch_ipu (
    .clk_i                                   ,
    .rst_i                                   ,
    .acc_qaddr_i      ( acc_req_q.addr      ),
    .acc_qid_i        ( acc_req_q.id        ),
    .acc_qdata_op_i   ( acc_req_q.data_op   ),
    .acc_qdata_arga_i ( acc_req_q.data_arga ),
    .acc_qdata_argb_i ( acc_req_q.data_argb ),
    .acc_qdata_argc_i ( acc_req_q.data_argc ),
    .acc_qvalid_i     ( acc_req_q_valid     ),
    .acc_qready_o     ( acc_req_q_ready     ),
    .acc_pdata_o      ( acc_resp_d.data     ),
    .acc_pid_o        ( acc_resp_d.id       ),
    .acc_perror_o     ( acc_resp_d.error    ),
    .acc_pvalid_o     ( acc_resp_d_valid    ),
    .acc_pready_i     ( acc_resp_d_ready    )
  );

  // Cut TCDM data request path
  spill_register #(
    .T      ( snitch_pkg::dreq_t ),
    .Bypass ( !RegisterTCDMReq   )
  ) i_spill_register_tcdm_req (
    .clk_i                       ,
    .rst_ni  ( ~rst_i           ),
    .valid_i ( data_req_d_valid ),
    .ready_o ( data_req_d_ready ),
    .data_i  ( data_req_d       ),
    .valid_o ( data_req_q_valid ),
    .ready_i ( data_req_q_ready ),
    .data_o  ( data_req_q       )
  );

  // Cut TCDM data response path
  spill_register #(
    .T      ( snitch_pkg::dresp_t ),
    .Bypass ( !RegisterTCDMResp   )
  ) i_spill_register_tcdm_resp (
    .clk_i                       ,
    .rst_ni  ( ~rst_i           ),
    .valid_i ( data_resp_d_valid ),
    .ready_o ( data_resp_d_ready ),
    .data_i  ( data_resp_d       ),
    .valid_o ( data_resp_q_valid ),
    .ready_i ( data_resp_q_ready ),
    .data_o  ( data_resp_q       )
  );

  // Assign TCDM data interface
  assign data_qaddr_o      = data_req_q.addr;
  assign data_qwrite_o     = data_req_q.write;
  assign data_qamo_o       = data_req_q.amo;
  assign data_qdata_o      = data_req_q.data;
  assign data_qstrb_o      = data_req_q.strb;
  assign data_qid_o        = data_req_q.id;
  assign data_qvalid_o     = data_req_q_valid;
  assign data_req_q_ready  = data_qready_i;
  assign data_resp_d.data  = data_pdata_i;
  assign data_resp_d.id    = data_pid_i;
  assign data_resp_d.error = data_perror_i;
  assign data_resp_d_valid = data_pvalid_i;
  assign data_pready_o     = data_resp_d_ready;

  // --------------------------
  // Tracer
  // --------------------------
  // pragma translate_off
  int f;
  string fn;
  logic [63:0] cycle;
  int unsigned stall, stall_ins, stall_raw, stall_lsu, stall_acc;

  always_ff @(posedge rst_i) begin
    if(rst_i) begin
      $sformat(fn, "trace_hart_%04x.dasm", hart_id_i);
      f = $fopen(fn, "w");
      $display("[Tracer] Logging Hart %d to %s", hart_id_i, fn);
    end
  end

  typedef enum logic [1:0] {SrcSnitch =  0, SrcFpu = 1, SrcFpuSeq = 2} trace_src_e;
  localparam int SnitchTrace = `ifdef SNITCH_TRACE `SNITCH_TRACE `else 0 `endif;

  always_ff @(posedge clk_i or posedge rst_i) begin
      automatic string trace_entry;
      automatic string extras_str;

      if (!rst_i) begin
        cycle <= cycle + 1;
        // Trace snitch iff:
        // Tracing enabled by CSR register
        // we are not stalled <==> we have issued and processed an instruction (including offloads)
        // OR we are retiring (issuing a writeback from) a load or accelerator instruction
        if ((i_snitch.csr_trace_q || SnitchTrace) && (!i_snitch.stall || i_snitch.retire_load || i_snitch.retire_acc)) begin
          // Manual loop unrolling for Verilator
          // Data type keys for arrays are currently not supported in Verilator
          extras_str = "{";
          // State
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "source",      SrcSnitch);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall",       i_snitch.stall);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall_tot",   stall);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall_ins",   stall_ins);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall_raw",   stall_raw);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall_lsu",   stall_lsu);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "stall_acc",   stall_acc);
          // Decoding
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "rs1",         i_snitch.rs1);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "rs2",         i_snitch.rs2);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "rd",          i_snitch.rd);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "is_load",     i_snitch.is_load);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "is_store",    i_snitch.is_store);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "is_branch",   i_snitch.is_branch);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "pc_d",        i_snitch.pc_d);
          // Operands
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "opa",         i_snitch.opa);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "opb",         i_snitch.opb);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "opa_select",  i_snitch.opa_select);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "opb_select",  i_snitch.opb_select);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "write_rd",    i_snitch.write_rd);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "csr_addr",    i_snitch.inst_data_i[31:20]);
          // Pipeline writeback
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "writeback",   i_snitch.alu_writeback);
          // Load/Store
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "gpr_rdata_1", i_snitch.gpr_rdata[1]);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "ls_size",     i_snitch.ls_size);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "ld_result_32",i_snitch.ld_result[31:0]);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "lsu_rd",      i_snitch.lsu_rd);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "retire_load", i_snitch.retire_load);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "alu_result",  i_snitch.alu_result);
          // Atomics
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "ls_amo",      i_snitch.ls_amo);
          // Accumulator
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "retire_acc",  i_snitch.retire_acc);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "acc_pid",     i_snitch.acc_pid_i);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "acc_pdata_32",i_snitch.acc_pdata_i[31:0]);
          // FPU offload
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "fpu_offload", 1'b0);
          extras_str = $sformatf("%s'%s': 0x%8x, ", extras_str, "is_seq_insn", 1'b0);
          extras_str = $sformatf("%s}", extras_str);

          $sformat(trace_entry, "%t %8d 0x%h DASM(%h) #; %s\n",
              $time, cycle, i_snitch.pc_q, i_snitch.inst_data_i, extras_str);
          $fwrite(f, trace_entry);
        end

        // Reset all stalls when we execute an instruction
        if (!i_snitch.stall) begin
            stall <= 0;
            stall_ins <= 0;
            stall_raw <= 0;
            stall_lsu <= 0;
            stall_acc <= 0;
        end else begin
          // We are currently stalled, let's count the stall causes
          if (i_snitch.stall) begin
            stall <= stall + 1;
          end
          if ((!i_snitch.inst_ready_i) && (i_snitch.inst_valid_o)) begin
            stall_ins <= stall_ins + 1;
          end
          if ((!i_snitch.operands_ready) || (!i_snitch.dst_ready)) begin
            stall_raw <= stall_raw + 1;
          end
          if (i_snitch.lsu_stall) begin
            stall_lsu <= stall_lsu + 1;
          end
          if (i_snitch.acc_stall) begin
            stall_acc <= stall_acc + 1;
          end
        end
      end else begin
        cycle <= '0;
        stall <= 0;
        stall_ins <= 0;
        stall_raw <= 0;
        stall_lsu <= 0;
        stall_acc <= 0;
      end
    end

  final begin
    $fclose(f);
  end
  // pragma translate_on

endmodule
