/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Saturating counter branch predictor
  This is FSM with 4 states: strongly not taken, weakly not taken,
  weakly taken, strongly taken.
  Fsm changes it state upon real(not predicted) flag.
  If flag was "true" and instruction was bf  or flag was "false" and
  instruction was bnf fsm changes its state towards "taken". And vice versa
  otherwise.
  We predict flag on current fsm state and current branch type.
  If we are in any "taken" state and current instruction is bf,
  we predict flag to be "true". Or we're in any "not taken" state and
  current instruction is bnf, we predict flag to be "true".

  Copyright (C) 2016 Alexey Baturo <baturo.alexey@gmail.com>

 ******************************************************************************/

`include "mor1kx-defines.v"

module mor1kx_branch_predictor_saturation_counter
   (
    input clk,
    input rst,

    // Signals belonging to the stage where the branch is predicted.
    output predicted_flag_o,     //result of predictor

    input execute_op_bf_i,       // prev insn was bf
    input execute_op_bnf_i,      // prev insn was bnf
    input op_bf_i,               // cur insn is bf
    input op_bnf_i,              // cur insn is bnf
    input padv_decode_i,         // pipeline is moved
    input flag_i,                // prev predicted flag

    // Signals belonging to the stage where the branch is resolved.
    input prev_op_brcond_i,      // prev op was cond brn
    input branch_mispredict_i    // prev brn was mispredicted
    );

   localparam [1:0]
      STATE_STRONGLY_NOT_TAKEN = 2'b00,
      STATE_WEAKLY_NOT_TAKEN   = 2'b01,
      STATE_WEAKLY_TAKEN       = 2'b10,
      STATE_STRONGLY_TAKEN     = 2'b11;

   reg [1:0] state = STATE_WEAKLY_TAKEN;

   assign predicted_flag_o = (state[1] && op_bf_i) || (!state[1] && op_bnf_i);
   wire brn_taken = (execute_op_bf_i && flag_i) || (execute_op_bnf_i && !flag_i);
 
   always @(posedge clk) begin
      if (rst) begin
         state <= STATE_WEAKLY_TAKEN;
      end else begin
         if (prev_op_brcond_i && padv_decode_i) begin
            if (!brn_taken) begin
               // change fsm state:
               //   STATE_STRONGLY_TAKEN -> STATE_WEAKLY_TAKEN
               //   STATE_WEAKLY_TAKEN -> STATE_WEAKLY_NOT_TAKEN
               //   STATE_WEAKLY_NOT_TAKEN -> STATE_STRONGLY_NOT_TAKEN
               //   STATE_STRONGLY_NOT_TAKEN -> STATE_STRONGLY_NOT_TAKEN
               case (state)
                  STATE_STRONGLY_TAKEN:
                     state <= STATE_WEAKLY_TAKEN;
                  STATE_WEAKLY_TAKEN:
                     state <= STATE_WEAKLY_NOT_TAKEN;
                  STATE_WEAKLY_NOT_TAKEN:
                     state <= STATE_STRONGLY_NOT_TAKEN;
                  STATE_STRONGLY_NOT_TAKEN:
                     state <= STATE_STRONGLY_NOT_TAKEN;
               endcase
            end else begin
               // change fsm state:
               //   STATE_STRONGLY_NOT_TAKEN -> STATE_WEAKLY_NOT_TAKEN
               //   STATE_WEAKLY_NOT_TAKEN -> STATE_WEAKLY_TAKEN
               //   STATE_WEAKLY_TAKEN -> STATE_STRONGLY_TAKEN
               //   STATE_STRONGLY_TAKEN -> STATE_STRONGLY_TAKEN
               case (state)
                  STATE_STRONGLY_NOT_TAKEN:
                     state <= STATE_WEAKLY_NOT_TAKEN;
                  STATE_WEAKLY_NOT_TAKEN:
                     state <= STATE_WEAKLY_TAKEN;
                  STATE_WEAKLY_TAKEN:
                     state <= STATE_STRONGLY_TAKEN;
                  STATE_STRONGLY_TAKEN:
                     state <= STATE_STRONGLY_TAKEN;
               endcase
            end
         end
      end
   end
endmodule
