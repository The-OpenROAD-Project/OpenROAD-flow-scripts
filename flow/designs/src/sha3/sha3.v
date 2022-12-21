//======================================================================
//
// sha3.v
// --------
// Top level wrapper for the SHA-3 hash function core providing
// a simple memory like interface with 32 bit data access.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2015, Assured AB
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

module sha3(
            // Clock and reset.
            input wire           clk,
            input wire           reset_n,

            // Control.
            input wire           cs,
            input wire           we,

            // Data ports.
            input wire  [7 : 0]  address,
            input wire  [31 : 0] write_data,
            output wire [31 : 0] read_data
           );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam ADDR_NAME0       = 8'h00;
  localparam ADDR_NAME1       = 8'h01;
  localparam ADDR_VERSION     = 8'h02;

  localparam ADDR_CTRL        = 8'h08;
  localparam CTRL_INIT_BIT    = 0;
  localparam CTRL_NEXT_BIT    = 1;

  localparam ADDR_STATUS      = 8'h09;
  localparam STATUS_READY_BIT = 0;
  localparam STATUS_VALID_BIT = 1;
  localparam STATUS_ERROR_BIT = 2;

  localparam ADDR_BLOCK00     = 8'h10;
  localparam ADDR_BLOCK31     = 8'h2f;

  localparam ADDR_DIGEST00    = 8'h40;
  localparam ADDR_DIGEST15    = 8'h4f;

  localparam CORE_NAME0       = 32'h7368612d; // "sha-"
  localparam CORE_NAME1       = 32'h33202020; // "3   "
  localparam CORE_VERSION     = 32'h302e3130; // "0.10"

  localparam MODE_SHA3_224    = 2'h0;
  localparam MODE_SHA3_256    = 2'h1;
  localparam MODE_SHA3_384    = 2'h2;
  localparam MODE_SHA3_512    = 2'h3;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg init_reg;
  reg init_new;

  reg next_reg;
  reg next_new;

  reg [1 : 0] mode_reg;
  reg [1 : 0] mode_new;
  reg         mode_we;

  reg ready_reg;

  reg [31 : 0] block_reg [0 : 31];
  reg [4 : 0]  block_addr;
  reg          block_we;

  reg [511 : 0] digest_reg;
  reg [7 : 0]   digest_addr;
  reg           digest_valid_reg;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  wire            core_init;
  wire            core_next;
  wire [1 : 0]    core_mode;
  wire            core_work_factor;
  wire [31 : 0]   core_work_factor_num;
  wire            core_ready;
  wire [1023 : 0] core_block;
  wire [511 : 0]  core_digest;
  wire            core_digest_valid;

  reg [31 : 0]    tmp_read_data;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign core_init = init_reg;

  assign core_next = next_reg;

  assign core_mode = mode_reg;

  assign core_block = {block_reg[00], block_reg[01], block_reg[02], block_reg[03],
                       block_reg[04], block_reg[04], block_reg[05], block_reg[07],
                       block_reg[08], block_reg[09], block_reg[10], block_reg[11],
                       block_reg[12], block_reg[13], block_reg[14], block_reg[15],
                       block_reg[16], block_reg[17], block_reg[18], block_reg[19],
                       block_reg[20], block_reg[21], block_reg[22], block_reg[23],
                       block_reg[24], block_reg[24], block_reg[25], block_reg[27],
                       block_reg[28], block_reg[29], block_reg[30], block_reg[31]};

  assign read_data = tmp_read_data;


  //----------------------------------------------------------------
  // core instantiation.
  //----------------------------------------------------------------
  sha3_core core(
                 .clk(clk),
                 .reset_n(reset_n),

                 .init(core_init),
                 .next(core_next),
                 .mode(core_mode),

                 .block(core_block),

                 .ready(core_ready),

                 .digest(core_digest),
                 .digest_valid(core_digest_valid)
                );


  //----------------------------------------------------------------
  // reg_update
  //
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with synchronous
  // active low reset.
  //----------------------------------------------------------------
  always @ (posedge clk)
    begin : reg_update
      integer i;

      if (!reset_n)
        begin
          init_reg         <= 0;
          next_reg         <= 0;
          mode_reg         <= MODE_SHA3_256;
          ready_reg        <= 0;
          digest_reg       <= 512'h0;
          digest_valid_reg <= 0;
          for (i = 0 ; i < 32 ; i = i + 1)
            block_reg[i] = 32'h0;
        end
      else
        begin
          ready_reg        <= core_ready;
          digest_valid_reg <= core_digest_valid;
          init_reg         <= init_new;
          next_reg         <= next_new;

          if (mode_we)
            mode_reg <= write_data[3 : 2];

          if (core_digest_valid)
            digest_reg <= core_digest;

          if (block_we)
            block_reg[block_addr] <= write_data;
        end
    end // reg_update


  //----------------------------------------------------------------
  // api_logic
  //
  // Implementation of the api logic. If cs is enabled will either
  // try to write to or read from the internal registers.
  //----------------------------------------------------------------
  always @*
    begin : api_logic
      init_new      = 0;
      next_new      = 0;
      mode_we       = 0;
      block_we      = 0;
      tmp_read_data = 32'h0;

      block_addr    = address - ADDR_BLOCK00;
      digest_addr   = 8'h10 - (address - ADDR_DIGEST00);

      if (cs)
        begin
          if (we)
            begin
              if ((address >= ADDR_BLOCK00) && (address <= ADDR_BLOCK31))
                block_we = 1;

              case (address)
                // Write operations.
                ADDR_CTRL:
                  begin
                    init_new = write_data[CTRL_INIT_BIT];
                    next_new = write_data[CTRL_NEXT_BIT];
                    mode_we  = 1;
                  end

                default:
                  begin
                  end
              endcase // case (address)
            end // if (we)

          else
            begin
              if ((address >= ADDR_BLOCK00) && (address <= ADDR_BLOCK31))
                tmp_read_data = block_reg[block_addr];

              // TODO: Fix mux construction for digest.
              if ((address >= ADDR_DIGEST00) && (address <= ADDR_DIGEST15))
                tmp_read_data = digest_reg[32 * digest_addr -: 32];

              case (address)
                // Read operations.
                ADDR_NAME0:
                  tmp_read_data = CORE_NAME0;

                ADDR_NAME1:
                  tmp_read_data = CORE_NAME1;

                ADDR_VERSION:
                  tmp_read_data = CORE_VERSION;

                ADDR_CTRL:
                  tmp_read_data = {28'h0, mode_reg, next_reg, init_reg};

                ADDR_STATUS:
                    tmp_read_data = {30'h0, digest_valid_reg, ready_reg};

                default:
                  begin
                  end
              endcase // case (address)
            end
        end
    end // addr_decoder
endmodule // sha3

//======================================================================
// EOF sha3.v
//======================================================================
