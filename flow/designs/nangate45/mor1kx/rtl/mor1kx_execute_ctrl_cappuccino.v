/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: execute to control stage signal passing

  Generate valid signal when stage is done

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>
             Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_execute_ctrl_cappuccino
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				 `OR1K_RESET_VECTOR,8'd0},
    parameter OPTION_RF_ADDR_WIDTH = 5,
    parameter FEATURE_FPU   = "NONE", // ENABLED|NONE
    parameter FEATURE_MULTIPLIER = "THREESTAGE"
    )
   (
    input 				  clk,
    input 				  rst,

    input 				  padv_i,
    input 				  padv_ctrl_i,

    input 				  execute_except_ibus_err_i,
    input 				  execute_except_itlb_miss_i,
    input 				  execute_except_ipagefault_i,
    input 				  execute_except_illegal_i,
    input 				  execute_except_ibus_align_i,
    input 				  execute_except_syscall_i,
    input 				  lsu_except_dbus_i,
    input 				  lsu_except_align_i,
    input 				  lsu_except_dtlb_miss_i,
    input 				  lsu_except_dpagefault_i,
    input 				  execute_except_trap_i,

    input 				  pipeline_flush_i,

    input 				  op_mul_i,

    input 				  op_lsu_load_i,
    input 				  op_lsu_store_i,
    input 				  op_lsu_atomic_i,
    input [1:0] 			  lsu_length_i,
    input 				  lsu_zext_i,

    input                                 op_msync_i,

    input 				  op_mfspr_i,
    input 				  op_mtspr_i,
    input 				  alu_valid_i,
    input 				  lsu_valid_i,

    input 				  msync_stall_i,

    input 				  op_jr_i,
    input 				  op_jal_i,
    input 				  op_rfe_i,

    input [OPTION_OPERAND_WIDTH-1:0] 	  alu_result_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  adder_result_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  rfb_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  execute_jal_result_i,
    input 				  flag_set_i,
    input 				  flag_clear_i,
    input 				  carry_set_i,
    input 				  carry_clear_i,
    input 				  overflow_set_i,
    input 				  overflow_clear_i,

    input [`OR1K_FPCSR_WIDTH-1:0]         fpcsr_i,
    input                                 fpcsr_set_i,
    

    input [OPTION_OPERAND_WIDTH-1:0] 	  pc_execute_i,

    input 				  execute_rf_wb_i,
    output reg 				  ctrl_rf_wb_o,
    output reg 				  wb_rf_wb_o,


    // address of destination register from execute stage
    input [OPTION_RF_ADDR_WIDTH-1:0] 	  execute_rfd_adr_i,
    output reg [OPTION_RF_ADDR_WIDTH-1:0] ctrl_rfd_adr_o,
    output reg [OPTION_RF_ADDR_WIDTH-1:0] wb_rfd_adr_o,

    input 				  execute_bubble_i,

    // Input from control stage for mfspr/mtspr ack
    input 				  ctrl_mfspr_ack_i,
    input 				  ctrl_mtspr_ack_i,

    output reg [OPTION_OPERAND_WIDTH-1:0] ctrl_alu_result_o,
    output reg [OPTION_OPERAND_WIDTH-1:0] ctrl_lsu_adr_o,
    output reg [OPTION_OPERAND_WIDTH-1:0] ctrl_rfb_o,
    output reg 				  ctrl_flag_set_o,
    output reg 				  ctrl_flag_clear_o,
    output reg 				  ctrl_carry_set_o,
    output reg 				  ctrl_carry_clear_o,
    output reg 				  ctrl_overflow_set_o,
    output reg 				  ctrl_overflow_clear_o,

    output reg [`OR1K_FPCSR_WIDTH-1:0]    ctrl_fpcsr_o,
    output reg                            ctrl_fpcsr_set_o,
    

    output reg [OPTION_OPERAND_WIDTH-1:0] pc_ctrl_o,

    output reg 				  ctrl_op_mul_o,

    output reg 				  ctrl_op_lsu_load_o,
    output reg 				  ctrl_op_lsu_store_o,
    output reg 				  ctrl_op_lsu_atomic_o,
    output reg [1:0] 			  ctrl_lsu_length_o,
    output reg 				  ctrl_lsu_zext_o,

    output reg                            ctrl_op_msync_o,

    output reg 				  ctrl_op_mfspr_o,
    output reg 				  ctrl_op_mtspr_o,

    output reg 				  ctrl_op_rfe_o,

    output reg 				  ctrl_except_ibus_err_o,
    output reg 				  ctrl_except_itlb_miss_o,
    output reg 				  ctrl_except_ipagefault_o,
    output reg 				  ctrl_except_ibus_align_o,
    output reg 				  ctrl_except_illegal_o,
    output reg 				  ctrl_except_syscall_o,
    output reg 				  ctrl_except_dbus_o,
    output reg 				  ctrl_except_dtlb_miss_o,
    output reg 				  ctrl_except_dpagefault_o,
    output reg 				  ctrl_except_align_o,
    output reg 				  ctrl_except_trap_o,

    output 				  execute_valid_o,
    output 				  ctrl_valid_o
    );

   wire 				  ctrl_stall;
   wire 				  execute_stall;

   // LSU or MTSPR/MFSPR can stall from ctrl stage
   assign ctrl_stall = (ctrl_op_lsu_load_o | ctrl_op_lsu_store_o) &
		       !lsu_valid_i |
                       ctrl_op_msync_o & msync_stall_i |
		       ctrl_op_mfspr_o & !ctrl_mfspr_ack_i |
		       ctrl_op_mtspr_o & !ctrl_mtspr_ack_i;
   assign ctrl_valid_o = !ctrl_stall;

   // Execute stage can be stalled from ctrl stage and by ALU
   assign execute_stall = ctrl_stall | !alu_valid_i;
   assign execute_valid_o = !execute_stall;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	ctrl_except_ibus_err_o <= 0;
	ctrl_except_itlb_miss_o <= 0;
	ctrl_except_ipagefault_o <= 0;
	ctrl_except_ibus_align_o <= 0;
	ctrl_except_illegal_o <= 0;
	ctrl_except_syscall_o <= 0;
	ctrl_except_trap_o <= 0;
	ctrl_except_dbus_o <= 0;
	ctrl_except_align_o <= 0;
     end
     else if (pipeline_flush_i) begin
	ctrl_except_ibus_err_o <= 0;
	ctrl_except_itlb_miss_o <= 0;
	ctrl_except_ipagefault_o <= 0;
	ctrl_except_ibus_align_o <= 0;
	ctrl_except_illegal_o <= 0;
	ctrl_except_syscall_o <= 0;
	ctrl_except_trap_o <= 0;
	ctrl_except_dbus_o <= 0;
	ctrl_except_align_o <= 0;
     end
     else begin
	if (padv_i) begin
	   ctrl_except_ibus_err_o <= execute_except_ibus_err_i;
	   ctrl_except_itlb_miss_o <= execute_except_itlb_miss_i;
	   ctrl_except_ipagefault_o <= execute_except_ipagefault_i;
	   ctrl_except_ibus_align_o <= execute_except_ibus_align_i;
	   ctrl_except_illegal_o <= execute_except_illegal_i;
	   ctrl_except_syscall_o <= execute_except_syscall_i;
	   ctrl_except_trap_o <= execute_except_trap_i;
	end
	ctrl_except_dbus_o <= lsu_except_dbus_i;
	ctrl_except_align_o <= lsu_except_align_i;
	ctrl_except_dtlb_miss_o <= lsu_except_dtlb_miss_i;
	ctrl_except_dpagefault_o <= lsu_except_dpagefault_i;
     end

   always @(posedge clk)
     if (padv_i)
	if (op_jal_i)
	  ctrl_alu_result_o <= execute_jal_result_i;
	else
	  ctrl_alu_result_o <= alu_result_i;

   always @(posedge clk)
     if (padv_i & (op_lsu_store_i | op_lsu_load_i))
       ctrl_lsu_adr_o <= adder_result_i;

   always @(posedge clk)
     if (padv_i)
       ctrl_rfb_o <= rfb_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	ctrl_flag_set_o <= 0;
	ctrl_flag_clear_o <= 0;
	ctrl_carry_set_o <= 0;
	ctrl_carry_clear_o <= 0;
	ctrl_overflow_set_o <= 0;
	ctrl_overflow_clear_o <= 0;
     end
     else if (padv_i) begin
	ctrl_flag_set_o <= flag_set_i;
	ctrl_flag_clear_o <= flag_clear_i;
	ctrl_carry_set_o <= carry_set_i;
	ctrl_carry_clear_o <= carry_clear_i;
	ctrl_overflow_set_o <= overflow_set_i;
	ctrl_overflow_clear_o <= overflow_clear_i;
     end

   // pc_ctrl should not advance when a nop bubble moves from execute to
   // ctrl/mem stage
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       pc_ctrl_o <= OPTION_RESET_PC;
     else if (padv_i & !execute_bubble_i)
       pc_ctrl_o <= pc_execute_i;

   //
   // The pipeline flush comes when the instruction that has caused
   // an exception or the instruction that has been interrupted is in
   // ctrl stage, so the padv_execute signal has to have higher prioity
   // than the pipeline flush in order to not accidently kill a valid
   // instruction coming in from execute stage.
   //

generate
if (FEATURE_MULTIPLIER=="PIPELINED") begin
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_op_mul_o <= 0;
     else if (padv_i)
       ctrl_op_mul_o <= op_mul_i;
     else if (pipeline_flush_i)
       ctrl_op_mul_o <= 0;
end else begin
   always @(posedge clk)
       ctrl_op_mul_o <= 0;
end
endgenerate

   // FPU related
   generate
     /* verilator lint_off WIDTH */
     if (FEATURE_FPU!="NONE") begin : fpu_execute_ctrl_ena
     /* verilator lint_on WIDTH */
       always @(posedge clk `OR_ASYNC_RST) begin
         if (rst) begin
           ctrl_fpcsr_o <= {`OR1K_FPCSR_WIDTH{1'b0}};
           ctrl_fpcsr_set_o <= 0;
         end else if (pipeline_flush_i) begin
           ctrl_fpcsr_o <= {`OR1K_FPCSR_WIDTH{1'b0}};
           ctrl_fpcsr_set_o <= 0;
         end else if (padv_i) begin
           ctrl_fpcsr_o <= fpcsr_i;
           ctrl_fpcsr_set_o <= fpcsr_set_i;
         end
       end // @clk
     end
     else begin : fpu_execute_ctrl_none
       always @(posedge clk `OR_ASYNC_RST) begin
         if (rst) begin
           ctrl_fpcsr_o <= {`OR1K_FPCSR_WIDTH{1'b0}};
           ctrl_fpcsr_set_o <= 0;
         end
       end // @clk
     end
   endgenerate // FPU related

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	ctrl_op_mfspr_o <= 0;
	ctrl_op_mtspr_o <= 0;
     end else if (padv_i) begin
	ctrl_op_mfspr_o <= op_mfspr_i;
	ctrl_op_mtspr_o <= op_mtspr_i;
     end else if (pipeline_flush_i) begin
	ctrl_op_mfspr_o <= 0;
	ctrl_op_mtspr_o <= 0;
     end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_op_rfe_o <= 0;
     else if (padv_i)
       ctrl_op_rfe_o <= op_rfe_i;
     else if (pipeline_flush_i)
       ctrl_op_rfe_o <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_op_msync_o <= 0;
     else if (padv_i)
       ctrl_op_msync_o <= op_msync_i;
     else if (pipeline_flush_i)
       ctrl_op_msync_o <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	ctrl_op_lsu_load_o <= 0;
	ctrl_op_lsu_store_o <= 0;
	ctrl_op_lsu_atomic_o <= 0;
     end else if (ctrl_except_align_o | ctrl_except_dbus_o |
		  ctrl_except_dtlb_miss_o | ctrl_except_dpagefault_o) begin
	ctrl_op_lsu_load_o <= 0;
	ctrl_op_lsu_store_o <= 0;
	ctrl_op_lsu_atomic_o <= 0;
    end else if (padv_i) begin
	ctrl_op_lsu_load_o <= op_lsu_load_i;
	ctrl_op_lsu_store_o <= op_lsu_store_i;
	ctrl_op_lsu_atomic_o <= op_lsu_atomic_i;
     end else if (pipeline_flush_i) begin
	ctrl_op_lsu_load_o <= 0;
	ctrl_op_lsu_store_o <= 0;
	ctrl_op_lsu_atomic_o <= 0;
     end

   always @(posedge clk)
     if (padv_i) begin
	ctrl_lsu_length_o <= lsu_length_i;
	ctrl_lsu_zext_o <= lsu_zext_i;
     end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
	ctrl_rf_wb_o <= 0;
     else if (padv_i)
	ctrl_rf_wb_o <= execute_rf_wb_i;
     else if (ctrl_op_mfspr_o & ctrl_mfspr_ack_i |
	      ctrl_op_lsu_load_o & lsu_valid_i)
       // Deassert the write enable when the "bus" access is done, to avoid:
       // 1) Writing multiple times to RF
       // 2) Signaling a need to bypass from control stage, when it really
       //    should be a bypass from wb stage.
       ctrl_rf_wb_o <= 0;
     else if (pipeline_flush_i)
       ctrl_rf_wb_o <= 0;

   always @(posedge clk)
     if (padv_i)
       ctrl_rfd_adr_o <= execute_rfd_adr_i;

   // load and mfpsr can stall from ctrl stage, so we have to hold off the
   // write back on them
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       wb_rf_wb_o <= 0;
     else if (pipeline_flush_i)
       wb_rf_wb_o <= 0;
     else if (ctrl_op_mfspr_o)
       wb_rf_wb_o <= ctrl_rf_wb_o & ctrl_mfspr_ack_i;
     else if (ctrl_op_lsu_load_o)
       wb_rf_wb_o <= ctrl_rf_wb_o & lsu_valid_i;
     else
       wb_rf_wb_o <= ctrl_rf_wb_o & padv_ctrl_i;

   always @(posedge clk)
     wb_rfd_adr_o <= ctrl_rfd_adr_o;


/*----------------Formal Checking-----------------*/

`ifdef FORMAL

`ifdef EXECUTE_CTRL
`define ASSUME assume
`else
`define ASSUME assert
`endif

   reg f_past_valid;
   initial f_past_valid = 1'b0;
   initial assume (rst);

   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

   //Reset and pipeline flush conditions
   always @(posedge clk `OR_ASYNC_RST) begin
      if (f_past_valid && ($past(rst) || $past(pipeline_flush_i))) begin
         assert (!ctrl_except_ibus_err_o);
         assert (!ctrl_except_itlb_miss_o);
         assert (!ctrl_except_ipagefault_o);
         assert (!ctrl_except_ibus_align_o);
         assert (!ctrl_except_illegal_o);
         assert (!ctrl_except_syscall_o);
         assert (!ctrl_except_trap_o);
         assert (!ctrl_except_dbus_o);
         assert (!ctrl_except_align_o);
         assert (!wb_rf_wb_o);
         if (FEATURE_FPU != "NONE")
         assert (ctrl_fpcsr_o == {`OR1K_FPCSR_WIDTH{1'b0}}
                 && !ctrl_fpcsr_set_o);
      end
   end

   //Reset Conditions
   always @(posedge clk `OR_ASYNC_RST) begin
      if (f_past_valid && $past(rst)) begin
         assert (!ctrl_flag_set_o);
         assert (!ctrl_flag_clear_o);
         assert (!ctrl_carry_set_o);
         assert (!ctrl_carry_clear_o);
         assert (!ctrl_overflow_set_o);
         assert (!ctrl_overflow_clear_o);
         assert (pc_ctrl_o == OPTION_RESET_PC);
         assert (!ctrl_op_mul_o);
         assert (!ctrl_op_mfspr_o);
         assert (!ctrl_op_mtspr_o);
         assert (!ctrl_op_rfe_o);
         assert (!ctrl_op_msync_o);
         assert (!ctrl_op_lsu_load_o);
         assert (!ctrl_op_lsu_store_o);
         assert (!ctrl_op_lsu_atomic_o);
         assert (!ctrl_rf_wb_o);
      end
   end

    wire [7:0] f_input_opcodes;
    wire [7:0] f_output_opcodes;
    assign f_input_opcodes = {op_lsu_load_i, op_lsu_store_i,
			      op_mfspr_i, op_mtspr_i,
			      op_rfe_i, op_mul_i, op_msync_i};
    assign f_output_opcodes = {ctrl_op_lsu_load_o, ctrl_op_lsu_store_o,
			       ctrl_op_mfspr_o, ctrl_op_mtspr_o,
			       ctrl_op_rfe_o, ctrl_op_mul_o,
			       ctrl_op_msync_o};

   //one instruction => one opcode
   always @(*) begin
      if (f_past_valid) begin
	 `ASSUME ($onehot0(f_input_opcodes));
	 assert ($onehot0(f_output_opcodes));
      end
   end

   //If bubble is inserted in the pipeline
   //then the pc ctrl shouldn't advance to the next execution pc.
   always @(posedge clk)
      if (f_past_valid && $past(execute_bubble_i) && !$past(rst))
         assert ($stable(pc_ctrl_o));

   //Executed mtspr insn shouldn't be lost on the pipeline flush.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(pipeline_flush_i)
          && $past(padv_i) && $past(op_mtspr_i))
         assert (ctrl_op_mtspr_o);

   //Executed mfspr insn shouldn't be lost on the pipeline flush.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(pipeline_flush_i)
          && $past(padv_i) && $past(op_mfspr_i))
         assert (ctrl_op_mfspr_o);

   //Pipeline flush shouldn't disturb multiplication execution
   always @(posedge clk)
      if (FEATURE_MULTIPLIER == "PIPELINED" && !$past(rst)
          && f_past_valid && $past(pipeline_flush_i) &&
          $past(padv_i) && $past(op_mul_i))
         assert (ctrl_op_mul_o);

   //Pipeline flush shouldn't destroy rfe instruction.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(op_rfe_i)
          && $past(pipeline_flush_i) && $past(padv_i))
         assert (ctrl_op_rfe_o);

   //Instruction msync_o shouldn't be lost if pipeline flush occurs.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(pipeline_flush_i)
          && $past(padv_i) && $past(op_msync_i))
         assert (ctrl_op_msync_o);

   //Abort load-store signals on any exceptions related to data bus.
   always @(posedge clk)
      if (f_past_valid && $past(ctrl_except_align_o) |
          $past(ctrl_except_dbus_o) | $past(ctrl_except_dtlb_miss_o)
          | $past(ctrl_except_dpagefault_o) && !$past(rst))
         assert (!ctrl_op_lsu_load_o && !ctrl_op_lsu_store_o &&
                 !ctrl_op_lsu_atomic_o);

    //Control signals should remain unchanged if pipeline hasn't advanced
    always @(posedge clk) begin
       if (f_past_valid && !$past(rst) && !$past(padv_i)
           && !$past(pipeline_flush_i)) begin
          assert ($stable(ctrl_alu_result_o));
          assert ($stable(ctrl_lsu_adr_o));
          assert ($stable(ctrl_rfb_o));
          assert ($stable(pc_ctrl_o));
          assert ($stable(ctrl_op_mul_o));
          assert ($stable(ctrl_op_mfspr_o));
          assert ($stable(ctrl_op_mtspr_o));
          assert ($stable(ctrl_op_rfe_o));
          assert ($stable(ctrl_op_msync_o));
          assert ($stable(ctrl_lsu_length_o));
          assert ($stable(ctrl_lsu_zext_o));
       end
    end

`endif

endmodule // mor1kx_execute_ctrl_cappuccino
