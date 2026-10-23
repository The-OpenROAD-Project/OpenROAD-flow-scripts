// SPDX-License-Identifier: Apache-2.0
// Copyright 2016-2017 SiFive, Inc.
// Changed from the original: rewritten as readable SystemVerilog from
// rocket-chip's Chisel. SOURCE.md names the source and its license.
//
// A synchroniser: WIDTH independent chains of SYNC flops, each bit
// clocked into the destination domain. Rocket-chip's
// AsyncResetSynchronizerShiftReg (util/SynchronizerReg.scala at a2df1a4,
// the commit XiangShan pins), which wraps its chains in their own module
// "to allow for backend flows to replace or constrain them properly when
// used for CDC synchronization, rather than buffering". constraint.sdc
// does exactly that, by these names.
//
// The chain is rocket-chip's: sync[SYNC-1] takes the asynchronous input,
// sync[0] is the output, every flop is asynchronously reset to INIT.
module sync_shift_reg #(
    parameter int WIDTH = 1,
    parameter int SYNC  = 3,
    parameter bit INIT  = 1'b0
) (
    input  logic             clock,
    input  logic             reset,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
  // A synchroniser has at least two flops (util/SynchronizerReg.scala:82).
  if (SYNC < 2) begin : sync_check
    $error("sync_shift_reg: SYNC must be at least 2");
  end

  for (genvar i = 0; i < WIDTH; i++) begin : bit_
    logic [SYNC-1:0] sync;
    always_ff @(posedge clock or posedge reset) begin
      if (reset) sync <= {SYNC{INIT}};
      else sync <= {d[i], sync[SYNC-1:1]};
    end
    assign q[i] = sync[0];
  end
endmodule
