/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Branch prediction module
  Generates a predicted flag output and compares that to the real flag
  when it comes back in the following pipeline stage.
  Signals are deliberately not named after the pipeline stage they belong to,
  in order to keep this module generic.

  Copyright (C) 2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
  Copyright (C) 2016 Alexey Baturo <baturo.alexey@gmail.com>

 ******************************************************************************/

`include "mor1kx-defines.v"

module mor1kx_branch_prediction
  #(
    parameter [95:0] FEATURE_BRANCH_PREDICTOR = "SIMPLE",
    parameter OPTION_OPERAND_WIDTH = 32
    )
   (
   input clk,
   input rst,

   // Signals belonging to the stage where the branch is predicted.
   input op_bf_i,               // from decode stage, brn is bf
   input op_bnf_i,              // from decode stage, brn is bnf
   input [9:0] immjbr_upper_i,  // from decode stage, imm
   input [OPTION_OPERAND_WIDTH - 1:0] brn_pc_i, // pc of brn being predicted
   output predicted_flag_o,     // to decode-execute stage, flag we predict to be

   // Signals belonging to the stage where the branch is resolved.
   input prev_op_brcond_i,      // from decode-execute stage, prev brn was cond
   input prev_predicted_flag_i, // from decode-execute, prev predicted flag
   input flag_i,                // from execute-ctrl stage, real flag we got

   input padv_decode_i,         // is decode stage stalled
   input execute_bf_i,          // prev insn was bf
   input execute_bnf_i,         // prev insn was bnf

   // Branch misprediction indicator
   output 	branch_mispredict_o // to decode-execute stage, was brn mispredicted or not
   );

   // Compare the real flag with the previously predicted flag and signal a
   // misprediction in case of a mismatch.
   assign branch_mispredict_o = prev_op_brcond_i & (flag_i != prev_predicted_flag_i);

generate
if (FEATURE_BRANCH_PREDICTOR=="SAT_COUNTER") begin : branch_predictor_saturation_counter
   mor1kx_branch_predictor_saturation_counter
      mor1kx_branch_predictor_saturation_counter
      (
         // Outputs
         .predicted_flag_o                 (predicted_flag_o),
         // Inputs
         .clk                              (clk),
         .rst                              (rst),
         .flag_i                           (flag_i),
         .execute_op_bf_i                  (execute_bf_i),
         .execute_op_bnf_i                 (execute_bnf_i),
         .op_bf_i                          (op_bf_i),
         .op_bnf_i                         (op_bnf_i),
         .prev_op_brcond_i                 (prev_op_brcond_i),
         .padv_decode_i                    (padv_decode_i),
         .branch_mispredict_i              (branch_mispredict_o));

end else if (FEATURE_BRANCH_PREDICTOR=="GSHARE") begin : branch_predictor_gshare
   mor1kx_branch_predictor_gshare
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
       )
      mor1kx_branch_predictor_gshare
      (
         // Outputs
         .predicted_flag_o                 (predicted_flag_o),
         // Inputs
         .clk                              (clk),
         .rst                              (rst),
         .flag_i                           (flag_i),
         .execute_op_bf_i                  (execute_bf_i),
         .execute_op_bnf_i                 (execute_bnf_i),
         .op_bf_i                          (op_bf_i),
         .brn_pc_i                         (brn_pc_i),
         .op_bnf_i                         (op_bnf_i),
         .prev_op_brcond_i                 (prev_op_brcond_i),
         .padv_decode_i                    (padv_decode_i),
         .branch_mispredict_i              (branch_mispredict_o));

end else if (FEATURE_BRANCH_PREDICTOR=="SIMPLE") begin : branch_predictor_simple
   mor1kx_branch_predictor_simple
      mor1kx_branch_predictor_simple
      (
         // Outputs
         .predicted_flag_o                 (predicted_flag_o),
         // Inputs
         .op_bf_i                          (op_bf_i),
         .op_bnf_i                         (op_bnf_i),
         .immjbr_upper_i                   (immjbr_upper_i));

end else begin
   initial begin
      $display("Error: FEATURE_PREDICTOR_TYPE, %s, not valid", FEATURE_BRANCH_PREDICTOR);
      $finish();
   end
end
endgenerate

endmodule
