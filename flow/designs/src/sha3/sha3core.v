//======================================================================
//
// sha3core.v
// -------------
// Verilog 2001 implementation of the SHA3 hash function.
// This is the internal core with wide interfaces.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2016 Secworks Sweden AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module sha3_core(
                   input wire            clk,
                   input wire            reset_n,

                   input wire            init,
                   input wire            next,
                   input wire [1 : 0]    mode,

                   input wire            work_factor,
                   input wire [31 : 0]   work_factor_num,

                   input wire [1023 : 0] block,

                   output wire           ready,
                   output wire [511 : 0] digest,
                   output wire           digest_valid
                  );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter SHA512_ROUNDS = 79;

  parameter CTRL_IDLE   = 0;
  parameter CTRL_ROUNDS = 1;
  parameter CTRL_DONE   = 2;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg [63 : 0] a_reg;
  reg [63 : 0] a_new;
  reg [63 : 0] b_reg;
  reg [63 : 0] b_new;
  reg [63 : 0] c_reg;
  reg [63 : 0] c_new;
  reg [63 : 0] d_reg;
  reg [63 : 0] d_new;
  reg [63 : 0] e_reg;
  reg [63 : 0] e_new;
  reg [63 : 0] f_reg;
  reg [63 : 0] f_new;
  reg [63 : 0] g_reg;
  reg [63 : 0] g_new;
  reg [63 : 0] h_reg;
  reg [63 : 0] h_new;
  reg          a_h_we;

  reg [63 : 0] H0_reg;
  reg [63 : 0] H0_new;
  reg [63 : 0] H1_reg;
  reg [63 : 0] H1_new;
  reg [63 : 0] H2_reg;
  reg [63 : 0] H2_new;
  reg [63 : 0] H3_reg;
  reg [63 : 0] H3_new;
  reg [63 : 0] H4_reg;
  reg [63 : 0] H4_new;
  reg [63 : 0] H5_reg;
  reg [63 : 0] H5_new;
  reg [63 : 0] H6_reg;
  reg [63 : 0] H6_new;
  reg [63 : 0] H7_reg;
  reg [63 : 0] H7_new;
  reg          H_we;

  reg [6 : 0] t_ctr_reg;
  reg [6 : 0] t_ctr_new;
  reg         t_ctr_we;
  reg         t_ctr_inc;
  reg         t_ctr_rst;

  reg [31 : 0] work_factor_ctr_reg;
  reg [31 : 0] work_factor_ctr_new;
  reg          work_factor_ctr_rst;
  reg          work_factor_ctr_inc;
  reg          work_factor_ctr_done;
  reg          work_factor_ctr_we;

  reg digest_valid_reg;
  reg digest_valid_new;
  reg digest_valid_we;

  reg [1 : 0] sha512_ctrl_reg;
  reg [1 : 0] sha512_ctrl_new;
  reg         sha512_ctrl_we;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg digest_init;
  reg digest_update;

  reg state_init;
  reg state_update;

  reg first_block;

  reg ready_flag;

  reg [63 : 0] t1;
  reg [63 : 0] t2;

  wire [63 : 0] k_data;

  reg           w_init;
  reg           w_next;
  wire [63 : 0] w_data;

  wire [63 : 0] H0_0;
  wire [63 : 0] H0_1;
  wire [63 : 0] H0_2;
  wire [63 : 0] H0_3;
  wire [63 : 0] H0_4;
  wire [63 : 0] H0_5;
  wire [63 : 0] H0_6;
  wire [63 : 0] H0_7;


  //----------------------------------------------------------------
  // Module instantiantions.
  //----------------------------------------------------------------


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign ready = ready_flag;

  assign digest = {H0_reg, H1_reg, H2_reg, H3_reg,
                   H4_reg, H5_reg, H6_reg, H7_reg};

  assign digest_valid = digest_valid_reg;


  //----------------------------------------------------------------
  // reg_update
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with asynchronous
  // active low reset. All registers have write enable.
  //----------------------------------------------------------------
  always @ (posedge clk or negedge reset_n)
    begin : reg_update
      if (!reset_n)
        begin
          a_reg               <= 64'h0000000000000000;
          b_reg               <= 64'h0000000000000000;
          c_reg               <= 64'h0000000000000000;
          d_reg               <= 64'h0000000000000000;
          e_reg               <= 64'h0000000000000000;
          f_reg               <= 64'h0000000000000000;
          g_reg               <= 64'h0000000000000000;
          h_reg               <= 64'h0000000000000000;
          H0_reg              <= 64'h0000000000000000;
          H1_reg              <= 64'h0000000000000000;
          H2_reg              <= 64'h0000000000000000;
          H3_reg              <= 64'h0000000000000000;
          H4_reg              <= 64'h0000000000000000;
          H5_reg              <= 64'h0000000000000000;
          H6_reg              <= 64'h0000000000000000;
          H7_reg              <= 64'h0000000000000000;
          work_factor_ctr_reg <= 32'h00000000;
          digest_valid_reg    <= 0;
          t_ctr_reg           <= 7'h00;
          sha512_ctrl_reg     <= CTRL_IDLE;
        end
      else
        begin

          if (a_h_we)
            begin
              a_reg <= a_new;
              b_reg <= b_new;
              c_reg <= c_new;
              d_reg <= d_new;
              e_reg <= e_new;
              f_reg <= f_new;
              g_reg <= g_new;
              h_reg <= h_new;
            end

          if (H_we)
            begin
              H0_reg <= H0_new;
              H1_reg <= H1_new;
              H2_reg <= H2_new;
              H3_reg <= H3_new;
              H4_reg <= H4_new;
              H5_reg <= H5_new;
              H6_reg <= H6_new;
              H7_reg <= H7_new;
            end

          if (t_ctr_we)
            begin
              t_ctr_reg <= t_ctr_new;
            end

          if (work_factor_ctr_we)
            begin
              work_factor_ctr_reg <= work_factor_ctr_new;
            end

          if (digest_valid_we)
            begin
              digest_valid_reg <= digest_valid_new;
            end

          if (sha512_ctrl_we)
            begin
              sha512_ctrl_reg <= sha512_ctrl_new;
            end
        end
    end // reg_update


  //----------------------------------------------------------------
  // digest_logic
  //
  // The logic needed to init as well as update the digest.
  //----------------------------------------------------------------
  always @*
    begin : digest_logic
      H0_new = 64'h00000000;
      H1_new = 64'h00000000;
      H2_new = 64'h00000000;
      H3_new = 64'h00000000;
      H4_new = 64'h00000000;
      H5_new = 64'h00000000;
      H6_new = 64'h00000000;
      H7_new = 64'h00000000;
      H_we = 0;

      if (digest_init)
        begin
          H0_new = H0_0;
          H1_new = H0_1;
          H2_new = H0_2;
          H3_new = H0_3;
          H4_new = H0_4;
          H5_new = H0_5;
          H6_new = H0_6;
          H7_new = H0_7;
          H_we = 1;
        end

      if (digest_update)
        begin
          H0_new = H0_reg + a_reg;
          H1_new = H1_reg + b_reg;
          H2_new = H2_reg + c_reg;
          H3_new = H3_reg + d_reg;
          H4_new = H4_reg + e_reg;
          H5_new = H5_reg + f_reg;
          H6_new = H6_reg + g_reg;
          H7_new = H7_reg + h_reg;
          H_we = 1;
        end
    end // digest_logic


  //----------------------------------------------------------------
  // t1_logic
  //
  // The logic for the T1 function.
  //----------------------------------------------------------------
  always @*
    begin : t1_logic
      reg [63 : 0] sum1;
      reg [63 : 0] ch;

      sum1 = {e_reg[13 : 0], e_reg[63 : 14]} ^
             {e_reg[17 : 0], e_reg[63 : 18]} ^
             {e_reg[40 : 0], e_reg[63 : 41]};

      ch = (e_reg & f_reg) ^ ((~e_reg) & g_reg);

      t1 = h_reg + sum1 + ch + k_data + w_data;
    end // t1_logic


  //----------------------------------------------------------------
  // t2_logic
  //
  // The logic for the T2 function
  //----------------------------------------------------------------
  always @*
    begin : t2_logic
      reg [63 : 0] sum0;
      reg [63 : 0] maj;

      sum0 = {a_reg[27 : 0], a_reg[63 : 28]} ^
             {a_reg[33 : 0], a_reg[63 : 34]} ^
             {a_reg[38 : 0], a_reg[63 : 39]};

      maj = (a_reg & b_reg) ^ (a_reg & c_reg) ^ (b_reg & c_reg);

      t2 = sum0 + maj;
    end // t2_logic


  //----------------------------------------------------------------
  // state_logic
  //
  // The logic needed to init as well as update the state during
  // round processing.
  //----------------------------------------------------------------
  always @*
    begin : state_logic
      a_new  = 64'h00000000;
      b_new  = 64'h00000000;
      c_new  = 64'h00000000;
      d_new  = 64'h00000000;
      e_new  = 64'h00000000;
      f_new  = 64'h00000000;
      g_new  = 64'h00000000;
      h_new  = 64'h00000000;
      a_h_we = 0;

      if (state_init)
        begin
          if (first_block)
            begin
              a_new  = H0_0;
              b_new  = H0_1;
              c_new  = H0_2;
              d_new  = H0_3;
              e_new  = H0_4;
              f_new  = H0_5;
              g_new  = H0_6;
              h_new  = H0_7;
              a_h_we = 1;
            end
          else
            begin
              a_new  = H0_reg;
              b_new  = H1_reg;
              c_new  = H2_reg;
              d_new  = H3_reg;
              e_new  = H4_reg;
              f_new  = H5_reg;
              g_new  = H6_reg;
              h_new  = H7_reg;
              a_h_we = 1;
            end
        end

      if (state_update)
        begin
          a_new  = t1 + t2;
          b_new  = a_reg;
          c_new  = b_reg;
          d_new  = c_reg;
          e_new  = d_reg + t1;
          f_new  = e_reg;
          g_new  = f_reg;
          h_new  = g_reg;
          a_h_we = 1;
        end
    end // state_logic


  //----------------------------------------------------------------
  // t_ctr
  //
  // Update logic for the round counter, a monotonically
  // increasing counter with reset.
  //----------------------------------------------------------------
  always @*
    begin : t_ctr
      t_ctr_new = 7'h00;
      t_ctr_we  = 0;

      if (t_ctr_rst)
        begin
          t_ctr_new = 7'h00;
          t_ctr_we  = 1;
        end

      if (t_ctr_inc)
        begin
          t_ctr_new = t_ctr_reg + 1'b1;
          t_ctr_we  = 1;
        end
    end // t_ctr


  //----------------------------------------------------------------
  // work_factor_ctr
  //
  // Work factor counter logic.
  //----------------------------------------------------------------
  always @*
    begin : work_factor_ctr
      work_factor_ctr_new  = 32'h00000000;
      work_factor_ctr_we   = 0;
      work_factor_ctr_done = 0;

      if (work_factor_ctr_reg == work_factor_num)
        begin
          work_factor_ctr_done = 1;
        end

      if (work_factor_ctr_rst)
        begin
          work_factor_ctr_new  = 32'h00000000;
          work_factor_ctr_we   = 1;
        end

      if (work_factor_ctr_inc)
        begin
          work_factor_ctr_new  = work_factor_ctr_reg + 1'b1;
          work_factor_ctr_we   = 1;
        end
    end // work_factor_ctr


  //----------------------------------------------------------------
  // sha512_ctrl_fsm
  //
  // Logic for the state machine controlling the core behaviour.
  //----------------------------------------------------------------
  always @*
    begin : sha512_ctrl_fsm
      digest_init         = 0;
      digest_update       = 0;

      state_init          = 0;
      state_update        = 0;

      first_block         = 0;
      ready_flag          = 0;

      w_init              = 0;
      w_next              = 0;

      t_ctr_inc           = 0;
      t_ctr_rst           = 0;

      digest_valid_new    = 0;
      digest_valid_we     = 0;

      work_factor_ctr_rst = 0;
      work_factor_ctr_inc = 0;

      sha512_ctrl_new     = CTRL_IDLE;
      sha512_ctrl_we      = 0;


      case (sha512_ctrl_reg)
        CTRL_IDLE:
          begin
            ready_flag = 1;

            if (init)
              begin
                work_factor_ctr_rst = 1;
                digest_init         = 1;
                w_init              = 1;
                state_init          = 1;
                first_block         = 1;
                t_ctr_rst           = 1;
                digest_valid_new    = 0;
                digest_valid_we     = 1;
                sha512_ctrl_new     = CTRL_ROUNDS;
                sha512_ctrl_we      = 1;
              end

            if (next)
              begin
                work_factor_ctr_rst = 1;
                w_init              = 1;
                state_init          = 1;
                t_ctr_rst           = 1;
                digest_valid_new    = 0;
                digest_valid_we     = 1;
                sha512_ctrl_new     = CTRL_ROUNDS;
                sha512_ctrl_we      = 1;
              end
          end


        CTRL_ROUNDS:
          begin
            w_next       = 1;
            state_update = 1;
            t_ctr_inc    = 1;

            if (t_ctr_reg == SHA512_ROUNDS)
              begin
                work_factor_ctr_inc = 1;
                sha512_ctrl_new     = CTRL_DONE;
                sha512_ctrl_we      = 1;
              end
          end


        CTRL_DONE:
          begin
            if (work_factor)
              begin
                if (!work_factor_ctr_done)
                  begin
                    w_init              = 1;
                    state_init          = 1;
                    t_ctr_rst           = 1;
                    sha512_ctrl_new     = CTRL_ROUNDS;
                    sha512_ctrl_we      = 1;
                  end
                else
                  begin
                    digest_update    = 1;
                    digest_valid_new = 1;
                    digest_valid_we  = 1;
                    sha512_ctrl_new  = CTRL_IDLE;
                    sha512_ctrl_we   = 1;
                  end
              end
            else
              begin
                digest_update    = 1;
                digest_valid_new = 1;
                digest_valid_we  = 1;
                sha512_ctrl_new  = CTRL_IDLE;
                sha512_ctrl_we   = 1;
              end
          end
      endcase // case (sha512_ctrl_reg)
    end // sha512_ctrl_fsm

endmodule // sha512_core

//======================================================================
// EOF sha512_core.v
//======================================================================
