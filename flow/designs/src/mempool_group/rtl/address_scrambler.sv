// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Description: Scrambles the address in such a way, that part of the memory is accessed
// sequentially and part is interleaved.
// Current constraints:

// Author: Samuel Riedel <sriedel@iis.ee.ethz.ch>

module address_scrambler #(
  parameter int unsigned AddrWidth         = 32,
  parameter int unsigned ByteOffset        = 2,
  parameter int unsigned NumTiles          = 2,
  parameter int unsigned NumBanksPerTile   = 2,
  parameter bit          Bypass            = 0,
  parameter int unsigned SeqMemSizePerTile = 4*1024
) (
  input  logic [AddrWidth-1:0] address_i,
  output logic [AddrWidth-1:0] address_o
);
  localparam int unsigned BankOffsetBits    = $clog2(NumBanksPerTile);
  localparam int unsigned TileIdBits        = $clog2(NumTiles);
  localparam int unsigned SeqPerTileBits    = $clog2(SeqMemSizePerTile);
  localparam int unsigned SeqTotalBits      = SeqPerTileBits+TileIdBits;
  localparam int unsigned ConstantBitsLSB   = ByteOffset + BankOffsetBits;
  localparam int unsigned ScrambleBits      = SeqPerTileBits-ConstantBitsLSB;

  if (Bypass || NumTiles < 2) begin
    assign address_o = address_i;
  end else begin
    logic [ScrambleBits-1:0]    scramble;    // Address bits that have to be shuffled around
    logic [TileIdBits-1:0]      tile_id;     // Which tile does  this address region belong to

    // Leave this part of the address unchanged
    // The LSBs that correspond to the offset inside a tile. These are the byte offset (bank width)
    // and the Bank offset (Number of Banks in tile)
    assign address_o[ConstantBitsLSB-1:0] = address_i[ConstantBitsLSB-1:0];
    // The MSBs that are outside of the sequential memory size. Currently the sequential memory size
    // always starts at 0. These are all the MSBs up to SeqMemSizePerTile*NumTiles
    assign address_o[AddrWidth-1:SeqTotalBits] = address_i[AddrWidth-1:SeqTotalBits];

    // Scramble the middle part
    // Bits that would have gone to different tiles but now go to increasing lines in the same tile
    assign scramble = address_i[SeqPerTileBits-1:ConstantBitsLSB]; // Bits that would
    // Bits that would have gone to increasing lines in the same tile but now go to different tiles
    assign tile_id  = address_i[SeqTotalBits-1:SeqPerTileBits];

    always_comb begin
      // Default: Unscrambled
      address_o[SeqTotalBits-1:ConstantBitsLSB] = {tile_id, scramble};
      // If not in bypass mode and address is in sequential region and more than one tile
      if (address_i < (NumTiles * SeqMemSizePerTile)) begin
        address_o[SeqTotalBits-1:ConstantBitsLSB] = {scramble, tile_id};
      end
    end
  end

  // Check for unsupported configurations
  if (NumBanksPerTile < 2)
    $fatal(1, "NumBanksPerTile must be greater than 2. The special case '1' is currently not supported!");
  if (SeqMemSizePerTile % (2**ByteOffset*NumBanksPerTile) != 0)
    $fatal(1, "SeqMemSizePerTile must be a multiple of BankWidth*NumBanksPerTile!");
endmodule : address_scrambler
